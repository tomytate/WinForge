<#
.SYNOPSIS
    Runs maintenance: disk cleanup, DISM component cleanup, and app updates.
#>
function Invoke-ForgeMaintenance {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    Write-ForgeLog -Message "Running WinForge maintenance..." -Level Info

    # 1. Disk Cleanup
    try {
        Write-ForgeLog -Message "Running disk cleanup..." -Level Info
        Start-Process "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait -ErrorAction SilentlyContinue
    }
    catch { Write-ForgeLog -Message "Disk cleanup skipped" -Level Debug }

    # 2. DISM Component Cleanup
    try {
        Write-ForgeLog -Message "Running DISM component cleanup..." -Level Info
        $dism = Start-Process "dism.exe" -ArgumentList "/Online /Cleanup-Image /StartComponentCleanup /ResetBase" -NoNewWindow -Wait -PassThru
        if ($dism.ExitCode -eq 0) { Write-ForgeLog -Message "Component cleanup complete" -Level Success }
    }
    catch { Write-ForgeLog -Message "DISM cleanup skipped" -Level Debug }

    # 3. Winget Updates
    try {
        $winget = Get-Command winget -ErrorAction SilentlyContinue
        if ($winget) {
            Write-ForgeLog -Message "Updating apps via Winget..." -Level Info
            Start-Process "winget" -ArgumentList "upgrade --all --accept-source-agreements --accept-package-agreements --silent" -NoNewWindow -Wait
            Write-ForgeLog -Message "App updates complete" -Level Success
        }
    }
    catch { Write-ForgeLog -Message "Winget updates skipped" -Level Debug }

    Write-ForgeLog -Message "Maintenance complete" -Level Success
}
