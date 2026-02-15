<#
.SYNOPSIS
    Returns available DNS provider configurations.
.OUTPUTS
    [PSCustomObject[]] DNS provider objects.
#>
function Get-ForgeDNSProviders {
    [CmdletBinding()]
    param()

    $dataFile = "$PSScriptRoot\..\Data\dns-providers.json"
    if (Test-Path $dataFile) {
        return Get-Content $dataFile -Raw | ConvertFrom-Json -DateKind Json
    }

    # Fallback built-in list
    return @(
        [PSCustomObject]@{ Name = "Cloudflare"; Primary = "1.1.1.1"; Secondary = "1.0.0.1"; Description = "Fast, privacy-focused" }
        [PSCustomObject]@{ Name = "Google"; Primary = "8.8.8.8"; Secondary = "8.8.4.4"; Description = "Reliable, global" }
        [PSCustomObject]@{ Name = "Quad9"; Primary = "9.9.9.9"; Secondary = "149.112.112.112"; Description = "Security-focused, malware blocking" }
        [PSCustomObject]@{ Name = "AdGuard"; Primary = "94.140.14.14"; Secondary = "94.140.15.15"; Description = "Ad and tracker blocking" }
        [PSCustomObject]@{ Name = "OpenDNS"; Primary = "208.67.222.222"; Secondary = "208.67.220.220"; Description = "Cisco umbrella" }
    )
}
