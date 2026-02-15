<#
.SYNOPSIS
    Adds telemetry domain blocks to the hosts file.
.EXAMPLE
    Add-ForgeHostsBlock
#>
function Add-ForgeHostsBlock {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    $hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"
    $marker = "# WinForge Telemetry Block"
    $domains = Get-ForgeTelemetryDomains

    if (Select-String -Path $hostsFile -Pattern $marker -Quiet -ErrorAction SilentlyContinue) {
        Write-ForgeLog -Message "Hosts block already present" -Level Info
        return
    }

    # Backup
    Copy-Item $hostsFile "$hostsFile.winforge.bak" -Force -ErrorAction SilentlyContinue

    if ($PSCmdlet.ShouldProcess("hosts file", "Add telemetry blocks")) {
        $entries = @($marker)
        foreach ($domain in $domains) {
            $entries += "0.0.0.0 $domain"
        }
        $entries += "# End WinForge Block"

        Add-Content -Path $hostsFile -Value ($entries -join "`n") -Encoding ASCII
        Write-ForgeLog -Message "Added $($domains.Count) domain blocks to hosts file" -Level Success
    }
}
