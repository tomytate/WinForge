<#
.SYNOPSIS
    Sets GPU scheduling priority for gaming.
#>
function Set-ForgeGPUPriority {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0
    Set-ForgeRegistry -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2
    Write-ForgeLog -Message "GPU scheduling priority set for gaming" -Level Success
}
