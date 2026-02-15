<#
.SYNOPSIS
    Auto-generated synopsis for Disable-ForgeClickToDo.
.DESCRIPTION
    This function was identified as missing documentation during the audit.
#>
function Disable-ForgeClickToDo {
    [CmdletBinding()]
    param([switch]$ApplyToDefaultUser)

    Set-ForgeRegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ClickToDoEnabled" -Type "DWord" -Value 0
    if ($ApplyToDefaultUser -and (Test-Path "Registry::HKLM\WinForge_Default")) {
        Set-ForgeRegistryValue -Path "HKLM:\WinForge_Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ClickToDoEnabled" -Type "DWord" -Value 0
    }
    Write-ForgeLog -Message "Click-to-Do disabled" -Level Success
}

