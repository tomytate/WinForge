<#
.SYNOPSIS
    Auto-generated synopsis for Disable-ForgeDesktopSpotlight.
.DESCRIPTION
    This function was identified as missing documentation during the audit.
#>
function Disable-ForgeDesktopSpotlight {
    [CmdletBinding()]
    param([switch]$ApplyToDefaultUser)

    Set-ForgeRegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{2cc5ca98-6485-489a-920e-b3e88a6ccce3}" -Type "DWord" -Value 1
    Set-ForgeRegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableLightThemeForConnectedStandby" -Type "DWord" -Value 0

    if ($ApplyToDefaultUser -and (Test-Path "Registry::HKLM\WinForge_Default")) {
        Set-ForgeRegistryValue -Path "HKLM:\WinForge_Default\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{2cc5ca98-6485-489a-920e-b3e88a6ccce3}" -Type "DWord" -Value 1
    }
    Write-ForgeLog -Message "Desktop Spotlight disabled" -Level Success
}

