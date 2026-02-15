<#
.SYNOPSIS
    Applies gaming performance optimizations.
.DESCRIPTION
    Disables Nagle's algorithm, mouse acceleration, and tunes MMCSS for gaming.
#>
function Set-ForgeGaming {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [switch]$DisableNagle,
        [switch]$DisableMouseAcceleration,
        [switch]$TuneMMCSS,
        [switch]$All
    )

    if ($All) { $DisableNagle = $DisableMouseAcceleration = $TuneMMCSS = $true }

    if ($DisableNagle) {
        $adapters = Get-NetAdapter -Physical -ErrorAction SilentlyContinue
        foreach ($adapter in $adapters) {
            $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$($adapter.InterfaceGuid)"
            Set-ForgeRegistry -Path $regPath -Name "TcpAckFrequency" -Value 1
            Set-ForgeRegistry -Path $regPath -Name "TCPNoDelay" -Value 1
        }
        Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters" -Name "TCPNoDelay" -Value 1
        Write-ForgeLog -Message "Nagle's algorithm disabled (TCPNoDelay)" -Level Success
    }

    if ($DisableMouseAcceleration) {
        Set-ForgeRegistry -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0" -Type String
        Set-ForgeRegistry -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "0" -Type String
        Set-ForgeRegistry -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "0" -Type String
        Write-ForgeLog -Message "Mouse acceleration disabled (raw input)" -Level Success
    }

    if ($TuneMMCSS) {
        $mmcssPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        Set-ForgeRegistry -Path $mmcssPath -Name "SystemResponsiveness" -Value 0
        Set-ForgeRegistry -Path $mmcssPath -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord
        Set-ForgeRegistry -Path "$mmcssPath\Tasks\Games" -Name "Priority" -Value 6
        Set-ForgeRegistry -Path "$mmcssPath\Tasks\Games" -Name "Scheduling Category" -Value "High" -Type String
        Set-ForgeRegistry -Path "$mmcssPath\Tasks\Games" -Name "SFIO Priority" -Value "High" -Type String
        Write-ForgeLog -Message "MMCSS tuned for gaming priority" -Level Success
    }
}
