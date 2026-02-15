<#
.SYNOPSIS
    Gets current network adapter status and DNS configuration.
.OUTPUTS
    [PSCustomObject[]] Network status objects.
#>
function Get-ForgeNetworkStatus {
    [CmdletBinding()]
    param()

    Get-NetAdapter -Physical | ForEach-Object {
        $dns = Get-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            Name       = $_.Name
            Status     = $_.Status
            Speed      = "$([math]::Round($_.LinkSpeed / 1MB))Mbps"
            MAC        = $_.MacAddress
            IPv4DNS    = ($dns | Where-Object { $_.AddressFamily -eq 2 }).ServerAddresses -join ", "
            IPv6DNS    = ($dns | Where-Object { $_.AddressFamily -eq 23 }).ServerAddresses -join ", "
        }
    }
}
