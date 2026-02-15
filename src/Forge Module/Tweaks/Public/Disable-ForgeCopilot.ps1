<#
.SYNOPSIS
    Auto-generated synopsis for Disable-ForgeCopilot.
.DESCRIPTION
    This function was identified as missing documentation during the audit.
#>
function Disable-ForgeCopilot {
    [CmdletBinding()]
    param([switch]$ApplyToDefaultUser)

    Set-ForgeRegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Type "DWord" -Value 1
    Set-ForgeRegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton" -Type "DWord" -Value 0
    Set-ForgeRegistryValue -Path "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Type "DWord" -Value 1

    if ($ApplyToDefaultUser -and (Test-Path "Registry::HKLM\WinForge_Default")) {
        Set-ForgeRegistryValue -Path "HKLM:\WinForge_Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton" -Type "DWord" -Value 0
        Set-ForgeRegistryValue -Path "HKLM:\WinForge_Default\Software\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Type "DWord" -Value 1
    }
    Write-ForgeLog -Message "Copilot disabled" -Level Success
}

