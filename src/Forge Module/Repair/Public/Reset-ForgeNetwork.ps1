<#
.SYNOPSIS
    Resets the network stack (Winsock, IP, DNS, firewall).
#>
function Reset-ForgeNetwork {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    if ($PSCmdlet.ShouldProcess("Network Stack", "Reset")) {
        netsh winsock reset | Out-Null
        netsh int ip reset | Out-Null
        netsh advfirewall reset | Out-Null
        ipconfig /flushdns | Out-Null
        ipconfig /release | Out-Null
        ipconfig /renew | Out-Null
        Write-ForgeLog -Message "Network stack reset. Restart required." -Level Success
    }
}
