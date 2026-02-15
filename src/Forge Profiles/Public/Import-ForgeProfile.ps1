<#
.SYNOPSIS
    Imports and validates a WinForge configuration profile.

.DESCRIPTION
    Loads a YAML configuration file, validates against the profile schema,
    and returns a structured configuration object. Handles dependency
    resolution for powershell-yaml (bundled in Vendor/ or installed on demand).

.PARAMETER Path
    Full path to the YAML profile file.

.PARAMETER SkipDependencyCheck
    If specified, skips the dependency check for powershell-yaml.

.OUTPUTS
    [psobject] The validated configuration object.

.EXAMPLE
    $config = Import-ForgeProfile -Path "profiles/balanced.yaml"
    $config = Import-ForgeProfile -Path "profiles/gaming.yaml" -SkipDependencyCheck
#>
function Import-ForgeProfile {
    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$Path,

        [switch]$SkipDependencyCheck
    )

    Write-ForgeLog -Message "Loading profile: $Path" -Level Info

    # Check for vendored powershell-yaml module (bundled in Profiles pillar)
    $vendorPath = "$PSScriptRoot\Vendor\powershell-yaml"
    if (Test-Path $vendorPath) {
        $moduleManifest = Get-ChildItem -Path $vendorPath -Filter "powershell-yaml.psd1" -Recurse | Select-Object -First 1

        if ($moduleManifest) {
            Write-ForgeLog -Message "Loading vendored 'powershell-yaml' from $($moduleManifest.FullName)" -Level Debug
            Import-Module $moduleManifest.FullName -Force -ErrorAction SilentlyContinue
        }
    }

    # Check for powershell-yaml module with user consent (SEC-001 fix)
    if (-not $SkipDependencyCheck) {
        if (-not (Get-Module -Name "powershell-yaml" -ErrorAction SilentlyContinue) -and -not (Get-Module -ListAvailable -Name "powershell-yaml")) {
            Write-ForgeLog -Message "Module 'powershell-yaml' not found." -Level Warning

            $response = Read-Host "Install 'powershell-yaml' from PowerShell Gallery? [Y/N]"

            if ($response -match '^[Yy]') {
                try {
                    Write-ForgeLog -Message "Installing 'powershell-yaml' via PSResourceGet..." -Level Info
                    # PS 7.5+: Uses Install-PSResource (preferred over Install-Module)
                    Install-PSResource -Name "powershell-yaml" -Scope CurrentUser -TrustRepository -ErrorAction Stop
                    Import-Module "powershell-yaml" -ErrorAction Stop
                    Write-ForgeLog -Message "Successfully installed 'powershell-yaml'." -Level Success
                }
                catch {
                    Write-ForgeLog -Message "Failed to install 'powershell-yaml'. Error: $($_.Exception.Message)" -Level Error
                    throw "Dependency 'powershell-yaml' is missing and installation failed."
                }
            }
            else {
                throw "Dependency 'powershell-yaml' is required. Please install it manually: Install-PSResource powershell-yaml"
            }
        }
        elseif (-not (Get-Module -Name "powershell-yaml" -ErrorAction SilentlyContinue)) {
            Import-Module "powershell-yaml" -ErrorAction Stop
        }
    }

    try {
        $Content = Get-Content $Path -Raw -ErrorAction Stop
        $Config = $Content | ConvertFrom-Yaml -ErrorAction Stop

        # Schema Validation (SEC-004 fix)
        $validationErrors = @()

        # 1. Check required sections
        if (-not $Config.metadata) {
            $validationErrors += "Missing required 'metadata' section"
        }
        else {
            foreach ($field in $Script:ProfileSchema.MetadataRequired) {
                if (-not $Config.metadata.$field) {
                    $validationErrors += "Missing required metadata field: '$field'"
                }
            }
        }

        # 2. Validate telemetry level
        if ($Config.privacy -and $Config.privacy.telemetry_level) {
            if ($Config.privacy.telemetry_level -notin $Script:ProfileSchema.ValidTelemetryLevels) {
                $validationErrors += "Invalid telemetry_level: '$($Config.privacy.telemetry_level)'. Valid: $($Script:ProfileSchema.ValidTelemetryLevels -join ', ')"
            }
        }

        # 3. Validate power plan
        if ($Config.performance -and $Config.performance.power_plan) {
            if ($Config.performance.power_plan -notin $Script:ProfileSchema.ValidPowerPlans) {
                $validationErrors += "Invalid power_plan: '$($Config.performance.power_plan)'. Valid: $($Script:ProfileSchema.ValidPowerPlans -join ', ')"
            }
        }

        # 4. Validate removal mode
        if ($Config.bloatware -and $Config.bloatware.removal_mode) {
            if ($Config.bloatware.removal_mode -notin $Script:ProfileSchema.ValidRemovalModes) {
                $validationErrors += "Invalid removal_mode: '$($Config.bloatware.removal_mode)'. Valid: $($Script:ProfileSchema.ValidRemovalModes -join ', ')"
            }

            if ($Config.bloatware.removal_mode -eq 'Custom' -and (-not $Config.bloatware.custom_list)) {
                $validationErrors += "Removal mode is 'Custom' but 'custom_list' is missing or empty."
            }
        }

        # 4b. Normalize Lists (Force Array)
        $listFields = @(
            @{ Section = 'bloatware'; Field = 'custom_list' }
            @{ Section = 'bloatware'; Field = 'exclude_list' }
            @{ Section = 'software'; Field = 'install_list' }
        )

        foreach ($item in $listFields) {
            $sec = $item.Section
            $fld = $item.Field

            if ($Config.$sec -and $Config.$sec.$fld) {
                if ($Config.$sec.$fld -isnot [Array]) {
                    $Config.$sec.$fld = @($Config.$sec.$fld)
                }
            }
        }

        # 5. Check for common typos (camelCase vs snake_case)
        $typoMap = @{
            'telemetry-level'       = 'telemetry_level'
            'telemetryLevel'        = 'telemetry_level'
            'powerPlan'             = 'power_plan'
            'power-plan'            = 'power_plan'
            'disableBackgroundApps' = 'disable_background_apps'
            'removalMode'           = 'removal_mode'
            'removal-mode'          = 'removal_mode'
            'excludeList'           = 'exclude_list'
            'customList'            = 'custom_list'
            'disableCopilot'        = 'disable_copilot'
            'disableRecall'         = 'disable_recall'
        }

        foreach ($section in $Config.PSObject.Properties) {
            if ($null -ne $section.Value -and $section.Value -is [PSCustomObject]) {
                foreach ($prop in $section.Value.PSObject.Properties) {
                    if ($typoMap.ContainsKey($prop.Name)) {
                        Write-ForgeLog -Message "Config typo: '$($prop.Name)' should be '$($typoMap[$prop.Name])' in [$($section.Name)]" -Level Warning
                    }
                }
            }
        }

        # Report validation errors
        if ($validationErrors.Count -gt 0) {
            foreach ($err in $validationErrors) {
                Write-ForgeLog -Message "Validation Error: $err" -Level Error
            }
            throw "Profile validation failed with $($validationErrors.Count) error(s)"
        }

        Write-ForgeLog -Message "Profile loaded: $($Config.metadata.name) v$($Config.metadata.version)" -Level Success
        return $Config
    }
    catch {
        Write-ForgeLog -Message "Failed to load profile: $($_.Exception.Message)" -Level Error
        throw
    }
}
