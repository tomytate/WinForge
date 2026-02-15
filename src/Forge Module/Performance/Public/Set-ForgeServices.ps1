<#
.SYNOPSIS
    Configures system services based on a preset.
.PARAMETER Preset
    Service preset: Privacy, Performance, Security, Minimal.
#>
function Set-ForgeServices {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Privacy", "Performance", "Security", "Minimal")]
        [string]$Preset
    )

    $dataFile = "$PSScriptRoot\..\Data\services.json"
    if (-not (Test-Path $dataFile)) {
        Write-ForgeLog -Message "services.json not found at: $dataFile" -Level Error
        return
    }

    $allPresets = Get-Content $dataFile -Raw | ConvertFrom-Json -DateKind Json
    $services = $allPresets.$Preset

    if (-not $services) {
        Write-ForgeLog -Message "Unknown preset: $Preset" -Level Error
        return
    }

    $changed = 0
    foreach ($svc in $services) {
        try {
            $current = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
            if ($current -and $PSCmdlet.ShouldProcess($svc.Name, "Set to $($svc.StartType)")) {
                Set-Service -Name $svc.Name -StartupType $svc.StartType -ErrorAction Stop
                $changed++
            }
        }
        catch {
            Write-ForgeLog -Message "Could not configure $($svc.Name): $($_.Exception.Message)" -Level Warning
        }
    }

    Write-ForgeLog -Message "Services preset '$Preset' applied: $changed services configured" -Level Success
}
