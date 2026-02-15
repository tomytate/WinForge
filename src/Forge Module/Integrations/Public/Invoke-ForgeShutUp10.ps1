<#
.SYNOPSIS
    Downloads and runs O&O ShutUp10++.
#>
function Invoke-ForgeShutUp10 {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    Write-ForgeLog -Message "Downloading O&O ShutUp10++..." -Level Info
    $url = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
    $tempPath = "$env:TEMP\OOSU10.exe"

    try {
        Invoke-WebRequest -Uri $url -OutFile $tempPath -UseBasicParsing -ErrorAction Stop
        if ($PSCmdlet.ShouldProcess("OOSU10", "Run")) {
            Start-Process $tempPath -Wait
        }
        Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
        Write-ForgeLog -Message "ShutUp10 completed" -Level Success
    }
    catch {
        Write-ForgeLog -Message "Failed to download ShutUp10: $($_.Exception.Message)" -Level Error
    }
}
