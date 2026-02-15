<#
.SYNOPSIS
    Applies performance optimizations.
.PARAMETER DisableBackgroundApps
    Disable background apps.
.PARAMETER OptimizeVisualEffects
    Optimize visual effects for performance.
.PARAMETER OptimizeRAM
    Split SVCHost for better RAM management.
#>
function Set-ForgePerformance {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [switch]$DisableBackgroundApps,
        [switch]$OptimizeVisualEffects,
        [switch]$OptimizeRAM,
        [switch]$All
    )

    if ($All) { $DisableBackgroundApps = $OptimizeVisualEffects = $OptimizeRAM = $true }

    if ($DisableBackgroundApps) {
        Set-ForgeRegistry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1
        Set-ForgeRegistry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BackgroundAppGlobalToggle" -Value 0
        Write-ForgeLog -Message "Background apps disabled" -Level Success
    }

    if ($OptimizeVisualEffects) {
        Set-ForgeRegistry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
        Set-ForgeRegistry -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary
        Write-ForgeLog -Message "Visual effects optimized for performance" -Level Success
    }

    if ($OptimizeRAM) {
        $ramKB = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1KB
        Set-ForgeRegistry -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Value ([int]$ramKB) -Type DWord
        Write-ForgeLog -Message "SvcHost split threshold set to $([int]($ramKB / 1MB)) GB" -Level Success
    }
}
