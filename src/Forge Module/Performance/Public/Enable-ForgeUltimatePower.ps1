<#
.SYNOPSIS
    Enables and activates the Ultimate Performance power plan.
#>
function Enable-ForgeUltimatePower {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    try {
        $ultimateGUID = "e9a42b02-d5df-448d-aa00-03f14749eb61"
        $existingPlan = powercfg -list | Select-String -Pattern "WinForge Ultimate"
        if ($existingPlan) {
            Write-ForgeLog -Message "Ultimate Performance plan already installed" -Level Info
            return
        }

        $duplicateOutput = powercfg /duplicatescheme $ultimateGUID 2>&1
        $guid = $null
        foreach ($line in $duplicateOutput) {
            if ($line -match '\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\b') {
                $guid = $matches[0]; break
            }
        }

        if (-not $guid) {
            Write-ForgeLog -Message "Failed to create Ultimate Performance plan" -Level Error
            return
        }

        powercfg /changename $guid "WinForge Ultimate" "Ultimate Performance plan" | Out-Null
        powercfg /setactive $guid | Out-Null
        Write-ForgeLog -Message "Ultimate Performance plan installed and activated" -Level Success
    }
    catch {
        Write-ForgeLog -Message "Error enabling Ultimate Power: $($_.Exception.Message)" -Level Error
    }
}
