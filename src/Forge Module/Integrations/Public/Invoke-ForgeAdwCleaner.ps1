<#
.SYNOPSIS
    Downloads and runs Malwarebytes AdwCleaner.
#>
function Invoke-ForgeAdwCleaner {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    Write-ForgeLog -Message "Downloading AdwCleaner..." -Level Info
    $url = "https://adwcleaner.malwarebytes.com/adwcleaner?channel=release"
    $tempPath = "$env:TEMP\adwcleaner.exe"

    try {
        Invoke-WebRequest -Uri $url -OutFile $tempPath -UseBasicParsing -ErrorAction Stop
        if ($PSCmdlet.ShouldProcess("AdwCleaner", "Run")) {
            Start-Process $tempPath -Wait
        }
        Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
        Write-ForgeLog -Message "AdwCleaner completed" -Level Success
    }
    catch {
        Write-ForgeLog -Message "Failed to download AdwCleaner: $($_.Exception.Message)" -Level Error
    }
}
