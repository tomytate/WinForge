<#
.SYNOPSIS
    Auto-generated synopsis for Disable-ForgeSettings365Ads.
.DESCRIPTION
    This function was identified as missing documentation during the audit.
#>
function Disable-ForgeSettings365Ads {
    [CmdletBinding()]
    param([switch]$ApplyToDefaultUser)

    Set-ForgeRegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSyncProviderNotifications" -Type "DWord" -Value 0
    if ($ApplyToDefaultUser -and (Test-Path "Registry::HKLM\WinForge_Default")) {
        Set-ForgeRegistryValue -Path "HKLM:\WinForge_Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSyncProviderNotifications" -Type "DWord" -Value 0
    }
    Write-ForgeLog -Message "Settings 365 ads disabled" -Level Success
}

