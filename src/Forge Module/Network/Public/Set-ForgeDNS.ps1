<#
.SYNOPSIS
    Sets DNS servers for all active network adapters.
.PARAMETER Provider
    DNS provider name (e.g., Cloudflare, Google, Quad9).
.PARAMETER Primary
    Custom primary DNS address.
.PARAMETER Secondary
    Custom secondary DNS address.
#>
function Set-ForgeDNS {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [string]$Provider,
        [string]$Primary,
        [string]$Secondary
    )

    if ($Provider) {
        $providers = Get-ForgeDNSProviders
        $selected = $providers | Where-Object { $_.Name -eq $Provider }
        if (-not $selected) {
            Write-ForgeLog -Message "Unknown DNS provider: $Provider" -Level Error
            return
        }
        $Primary = $selected.Primary
        $Secondary = $selected.Secondary
    }

    if (-not $Primary) {
        Write-ForgeLog -Message "No DNS address specified" -Level Error
        return
    }

    $adapters = Get-NetAdapter -Physical | Where-Object { $_.Status -eq "Up" }
    foreach ($adapter in $adapters) {
        if ($PSCmdlet.ShouldProcess($adapter.Name, "Set DNS to $Primary, $Secondary")) {
            Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses @($Primary, $Secondary)
            Write-ForgeLog -Message "DNS set on $($adapter.Name): $Primary, $Secondary" -Level Success
        }
    }

    Clear-DnsClientCache
    Write-ForgeLog -Message "DNS cache flushed" -Level Info
}
