<#
.SYNOPSIS
    Enables or disables IPv6.
.PARAMETER Enable
    Enable IPv6. Default action is to disable.
#>
function Set-ForgeIPv6 {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [switch]$Enable
    )

    if ($Enable) {
        Set-ForgeRegistry -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" -Name "DisabledComponents" -Value 0
        Write-ForgeLog -Message "IPv6 enabled" -Level Success
    }
    else {
        Set-ForgeRegistry -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" -Name "DisabledComponents" -Value 255
        Write-ForgeLog -Message "IPv6 disabled" -Level Success
    }
}
