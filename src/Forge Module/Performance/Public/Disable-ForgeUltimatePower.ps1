<#
.SYNOPSIS
    Removes the Ultimate Performance power plan and reverts to Balanced.
#>
function Disable-ForgeUltimatePower {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    try {
        $installedPlan = powercfg -list | Select-String -Pattern "WinForge Ultimate"
        if ($installedPlan) {
            $planGUID = ($installedPlan -split '\s+')[3]
            $balancedGUID = "381b4222-f694-41f0-9685-ff5bb260df2e"
            powercfg -setactive $balancedGUID | Out-Null
            powercfg -delete $planGUID | Out-Null
            Write-ForgeLog -Message "Ultimate Performance plan uninstalled, Balanced active" -Level Success
        }
        else {
            Write-ForgeLog -Message "Ultimate Performance plan not found" -Level Info
        }
    }
    catch {
        Write-ForgeLog -Message "Error disabling Ultimate Power: $($_.Exception.Message)" -Level Error
    }
}
