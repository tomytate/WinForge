<#
.SYNOPSIS
    Removes Microsoft OneDrive completely.
.EXAMPLE
    Remove-ForgeOneDrive
#>
function Remove-ForgeOneDrive {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    Write-ForgeLog -Message "Removing OneDrive..." -Level Info

    try {
        # Stop OneDrive process
        Get-Process "OneDrive" -ErrorAction SilentlyContinue | Stop-Process -Force

        # Run uninstaller
        $paths = @(
            "$env:SystemRoot\System32\OneDriveSetup.exe",
            "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
        )

        foreach ($path in $paths) {
            if (Test-Path $path) {
                if ($PSCmdlet.ShouldProcess("OneDrive", "Uninstall")) {
                    Start-Process $path -ArgumentList "/uninstall" -NoNewWindow -Wait
                }
                break
            }
        }

        # Remove leftover directories
        $leftoverPaths = @(
            "$env:USERPROFILE\OneDrive",
            "$env:LOCALAPPDATA\Microsoft\OneDrive",
            "$env:ProgramData\Microsoft OneDrive"
        )
        foreach ($p in $leftoverPaths) {
            if (Test-Path $p) { Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue }
        }

        # Remove from Explorer sidebar
        Set-ForgeRegistry -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0

        Write-ForgeLog -Message "OneDrive removed" -Level Success
    }
    catch {
        Write-ForgeLog -Message "OneDrive removal failed: $($_.Exception.Message)" -Level Error
    }
}
