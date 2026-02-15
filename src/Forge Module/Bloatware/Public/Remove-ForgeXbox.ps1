<#
.SYNOPSIS
    Removes Xbox-related apps and services.
.EXAMPLE
    Remove-ForgeXbox
#>
function Remove-ForgeXbox {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    Write-ForgeLog -Message "Removing Xbox components..." -Level Info

    $xboxApps = @(
        "Microsoft.Xbox.TCUI", "Microsoft.XboxApp", "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay", "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay", "Microsoft.GamingApp",
        "Microsoft.GamingServices"
    )

    foreach ($app in $xboxApps) {
        $pkg = Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue
        if ($pkg -and $PSCmdlet.ShouldProcess($app, "Remove")) {
            try {
                $pkg | Remove-AppxPackage -AllUsers -ErrorAction Stop
                Write-ForgeLog -Message "Removed: $app" -Level Success
            }
            catch {
                Write-ForgeLog -Message "Could not remove ${app}: $($_.Exception.Message)" -Level Warning
            }
        }
    }
}
