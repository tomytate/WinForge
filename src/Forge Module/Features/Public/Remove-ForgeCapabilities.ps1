<#
.SYNOPSIS
    Removes legacy Windows capabilities (WordPad, Math Recognizer, etc.).
#>
function Remove-ForgeCapabilities {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [string[]]$Capabilities = @(
            "Microsoft.Windows.WordPad~~~~0.0.1.0",
            "Microsoft.Windows.MSPaint~~~~0.0.1.0",
            "MathRecognizer~~~~0.0.1.0",
            "Browser.InternetExplorer~~~~0.0.11.0"
        )
    )

    foreach ($cap in $Capabilities) {
        try {
            $state = Get-WindowsCapability -Online -Name $cap -ErrorAction SilentlyContinue
            if ($state -and $state.State -eq "Installed") {
                if ($PSCmdlet.ShouldProcess($cap, "Remove")) {
                    Remove-WindowsCapability -Online -Name $cap -ErrorAction Stop | Out-Null
                    Write-ForgeLog -Message "Removed capability: $cap" -Level Success
                }
            }
        }
        catch {
            Write-ForgeLog -Message "Could not remove $cap : $($_.Exception.Message)" -Level Warning
        }
    }
}
