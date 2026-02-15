<#
.SYNOPSIS
    Checks if WinForge hosts blocks are active.
.OUTPUTS
    [PSCustomObject] Status with BlockCount and IsActive.
#>
function Get-ForgeHostsStatus {
    [CmdletBinding()]
    param()

    $hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"
    $content = Get-Content $hostsFile -ErrorAction SilentlyContinue
    $blockCount = ($content | Where-Object { $_ -match "^0\.0\.0\.0" -and $_ -notmatch "localhost" }).Count
    $hasMarker = $content | Where-Object { $_ -match "WinForge Telemetry Block" }

    [PSCustomObject]@{
        IsActive   = [bool]$hasMarker
        BlockCount = $blockCount
        HostsFile  = $hostsFile
    }
}
