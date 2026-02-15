<#
.SYNOPSIS
    Removes WinForge telemetry blocks from the hosts file.
#>
function Remove-ForgeHostsBlock {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    $hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"
    $content = Get-Content $hostsFile -ErrorAction Stop

    $inBlock = $false
    $newContent = @()
    foreach ($line in $content) {
        if ($line -match "^# WinForge Telemetry Block") { $inBlock = $true; continue }
        if ($line -match "^# End WinForge Block") { $inBlock = $false; continue }
        if (-not $inBlock) { $newContent += $line }
    }

    if ($PSCmdlet.ShouldProcess("hosts file", "Remove WinForge blocks")) {
        Set-Content -Path $hostsFile -Value $newContent -Encoding ASCII
        Write-ForgeLog -Message "Removed WinForge blocks from hosts file" -Level Success
    }
}
