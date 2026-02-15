<#
.SYNOPSIS
    Auto-generated synopsis for Disable-ForgePaintAI.
.DESCRIPTION
    This function was identified as missing documentation during the audit.
#>
function Disable-ForgePaintAI {
    [CmdletBinding()]
    param([switch]$ApplyToDefaultUser)

    $regPath = "HKCU:\Software\Microsoft\Paint"
    Set-ForgeRegistryValue -Path $regPath -Name "CocreatorEnabled" -Type "DWord" -Value 0
    Set-ForgeRegistryValue -Path $regPath -Name "ImageCreatorEnabled" -Type "DWord" -Value 0
    Set-ForgeRegistryValue -Path $regPath -Name "GenerativeFillEnabled" -Type "DWord" -Value 0
    Set-ForgeRegistryValue -Path $regPath -Name "GenerativeEraseEnabled" -Type "DWord" -Value 0

    if ($ApplyToDefaultUser -and (Test-Path "Registry::HKLM\WinForge_Default")) {
        $defaultPath = "HKLM:\WinForge_Default\Software\Microsoft\Paint"
        Set-ForgeRegistryValue -Path $defaultPath -Name "CocreatorEnabled" -Type "DWord" -Value 0
        Set-ForgeRegistryValue -Path $defaultPath -Name "ImageCreatorEnabled" -Type "DWord" -Value 0
        Set-ForgeRegistryValue -Path $defaultPath -Name "GenerativeFillEnabled" -Type "DWord" -Value 0
        Set-ForgeRegistryValue -Path $defaultPath -Name "GenerativeEraseEnabled" -Type "DWord" -Value 0
    }
    Write-ForgeLog -Message "Paint AI features disabled" -Level Success
}

