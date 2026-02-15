<#
.SYNOPSIS
    Sets a registry key value with proper validation and error handling.

.DESCRIPTION
    Creates the registry path if it doesn't exist and sets the specified value.
    Includes ACL validation to ensure write permissions before attempting changes (SEC-002 fix).

.PARAMETER Path
    The full registry path (e.g., HKLM:\SOFTWARE\MyApp)

.PARAMETER Name
    The registry value name.

.PARAMETER Value
    The value to set.

.PARAMETER Type
    The registry value type (DWord, String, QWord, Binary, MultiString, ExpandString).

.OUTPUTS
    [bool] Returns $true if successful, $false otherwise.

.EXAMPLE
    Set-ForgeRegistry -Path "HKCU:\SOFTWARE\Test" -Name "MySetting" -Value 1
    Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Policies\Test" -Name "Enabled" -Value 0 -Type DWord
#>
function Set-ForgeRegistry {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -notmatch '^HK(LM|CU|CR|U|CC):\\') {
                    throw "Invalid registry path '$_'. Must start with a valid hive (e.g. HKLM:\)"
                }
                $true
            })]
        [string]$Path,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [AllowNull()]
        $Value,

        [ValidateSet("DWord", "String", "QWord", "Binary", "MultiString", "ExpandString")]
        [string]$Type = "DWord"
    )

    try {
        # Validate and create path if needed
        if (-not (Test-Path $Path)) {
            if ($PSCmdlet.ShouldProcess($Path, "Create Registry Key")) {
                New-Item -Path $Path -Force -ErrorAction Stop | Out-Null
                Write-ForgeLog -Message "Created registry path: $Path" -Level Debug
            }
        }

        # Validate we have write access (SEC-002 fix)
        $acl = Get-Acl -Path $Path -ErrorAction Stop
        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $hasWriteAccess = $false

        foreach ($accessRule in $acl.Access) {
            if ($accessRule.IdentityReference.Value -match "Administrators|SYSTEM|$($currentUser.Name)") {
                if ($accessRule.RegistryRights -band [System.Security.AccessControl.RegistryRights]::SetValue) {
                    $hasWriteAccess = $true
                    break
                }
            }
        }

        if (-not $hasWriteAccess) {
            Write-ForgeLog -Message "Insufficient permissions to modify: $Path" -Level Warning
        }

        # Set the value
        if ($PSCmdlet.ShouldProcess("$Path\$Name", "Set Value to $Value ($Type)")) {
            Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force -ErrorAction Stop
            Write-ForgeLog -Message "Set registry: $Path\$Name = $Value" -Level Debug
            return $true
        }

        return $false
    }
    catch {
        Write-ForgeLog -Message "Failed to set registry '$Path\$Name': $($_.Exception.Message)" -Level Error
        return $false
    }
}
