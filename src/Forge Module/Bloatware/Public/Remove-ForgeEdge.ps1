<#
.SYNOPSIS
    Removes Microsoft Edge browser.
.DESCRIPTION
    Attempts to remove Edge via its installer. This is an aggressive action
    that may affect system components relying on Edge WebView2.
.EXAMPLE
    Remove-ForgeEdge
#>
function Remove-ForgeEdge {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param()

    Write-ForgeLog -Message "Removing Microsoft Edge..." -Level Warning

    try {
        $edgePaths = @(
            "${env:ProgramFiles(x86)}\Microsoft\Edge\Application",
            "$env:ProgramFiles\Microsoft\Edge\Application"
        )

        foreach ($edgePath in $edgePaths) {
            if (Test-Path $edgePath) {
                $setupPath = Get-ChildItem -Path $edgePath -Recurse -Filter "setup.exe" | Select-Object -First 1
                if ($setupPath -and $PSCmdlet.ShouldProcess("Microsoft Edge", "Uninstall")) {
                    $args = "--uninstall --system-level --verbose-logging --force-uninstall"
                    Start-Process $setupPath.FullName -ArgumentList $args -NoNewWindow -Wait
                    Write-ForgeLog -Message "Edge uninstall initiated" -Level Success
                }
            }
        }
    }
    catch {
        Write-ForgeLog -Message "Edge removal failed: $($_.Exception.Message)" -Level Error
    }
}
