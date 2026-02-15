<#
.SYNOPSIS
    Removes bloatware apps based on profile configuration.
.PARAMETER Mode
    Removal mode: Conservative, Moderate, Aggressive, Custom.
.PARAMETER CustomList
    Custom list of app patterns to remove (used with -Mode Custom).
.PARAMETER ExcludeList
    List of app patterns to exclude from removal.
.EXAMPLE
    Remove-ForgeBloatware -Mode Moderate
    Remove-ForgeBloatware -Mode Custom -CustomList @("Microsoft.BingWeather")
#>
function Remove-ForgeBloatware {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [ValidateSet("Conservative", "Moderate", "Aggressive", "Custom")]
        [string]$Mode = "Moderate",

        [string[]]$CustomList,
        [string[]]$ExcludeList = @()
    )

    Write-ForgeLog -Message "Removing bloatware (Mode: $Mode)..." -Level Info

    $apps = if ($Mode -eq "Custom" -and $CustomList) {
        $CustomList
    }
    else {
        Get-ForgeBloatwareList -Category All
    }

    $removed = 0
    foreach ($pattern in $apps) {
        if ($ExcludeList -contains $pattern) { continue }

        $installed = Get-AppxPackage -Name $pattern -AllUsers -ErrorAction SilentlyContinue
        if ($installed) {
            foreach ($app in $installed) {
                if ($PSCmdlet.ShouldProcess($app.Name, "Remove AppxPackage")) {
                    try {
                        $app | Remove-AppxPackage -AllUsers -ErrorAction Stop
                        Write-ForgeLog -Message "Removed: $($app.Name)" -Level Success
                        $removed++
                    }
                    catch {
                        Write-ForgeLog -Message "Failed to remove $($app.Name): $($_.Exception.Message)" -Level Warning
                    }
                }
            }
        }

        # Also remove provisioned packages
        $provisioned = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
            Where-Object { $_.PackageName -like "*$pattern*" }
        foreach ($prov in $provisioned) {
            if ($PSCmdlet.ShouldProcess($prov.DisplayName, "Remove Provisioned Package")) {
                try {
                    Remove-AppxProvisionedPackage -Online -PackageName $prov.PackageName -ErrorAction Stop | Out-Null
                    Write-ForgeLog -Message "Deprovisioned: $($prov.DisplayName)" -Level Success
                }
                catch {
                    Write-ForgeLog -Message "Failed to deprovision: $($_.Exception.Message)" -Level Warning
                }
            }
        }
    }

    Write-ForgeLog -Message "Bloatware removal complete: $removed apps removed" -Level Success
}
