<#
.SYNOPSIS
    Resets Windows Update components.
#>
function Reset-ForgeUpdate {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    if ($PSCmdlet.ShouldProcess("Windows Update", "Reset components")) {
        $services = @("bits", "wuauserv", "appidsvc", "cryptsvc")
        foreach ($svc in $services) {
            Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        }

        Remove-Item "$env:ALLUSERSPROFILE\Application Data\Microsoft\Network\Downloader\qmgr*.dat" -Force -ErrorAction SilentlyContinue
        Rename-Item "$env:SystemRoot\SoftwareDistribution" "$env:SystemRoot\SoftwareDistribution.old" -Force -ErrorAction SilentlyContinue
        Rename-Item "$env:SystemRoot\System32\catroot2" "$env:SystemRoot\System32\catroot2.old" -Force -ErrorAction SilentlyContinue

        foreach ($svc in $services) {
            Start-Service -Name $svc -ErrorAction SilentlyContinue
        }

        Write-ForgeLog -Message "Windows Update components reset" -Level Success
    }
}
