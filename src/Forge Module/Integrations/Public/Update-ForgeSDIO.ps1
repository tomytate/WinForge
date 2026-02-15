<#
.SYNOPSIS
    Downloads/updates Snappy Driver Installer Origin (SDIO).
#>
function Update-ForgeSDIO {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    Write-ForgeLog -Message "Launching SDIO..." -Level Info
    $sdioDir = "$env:ProgramData\WinForge\SDIO"
    $sdioExe = "$sdioDir\SDIO_auto.bat"

    if (-not (Test-Path $sdioDir)) {
        New-Item -Path $sdioDir -ItemType Directory -Force | Out-Null
    }

    $url = "https://www.snappy-driver-installer.org/downloads/SDIO_auto.bat"
    try {
        Write-Warning "This will download and execute an external batch file from: $url"
        Write-Warning "Please verify the source matches 'https://www.snappy-driver-installer.org/' if possible."
        
        Invoke-WebRequest -Uri $url -OutFile $sdioExe -UseBasicParsing -ErrorAction Stop
        
        if ($PSCmdlet.ShouldProcess("SDIO", "Execute external script: $sdioExe")) {
            Start-Process $sdioExe -WorkingDirectory $sdioDir -Wait
        }
        Write-ForgeLog -Message "SDIO complete" -Level Success
    }
    catch {
        Write-ForgeLog -Message "Failed to download SDIO: $($_.Exception.Message)" -Level Error
    }
}
