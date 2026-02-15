<#
.SYNOPSIS
    Auto-generated synopsis for Disable-ForgeNotepadAI.
.DESCRIPTION
    This function was identified as missing documentation during the audit.
#>
function Disable-ForgeNotepadAI {
    [CmdletBinding()]
    param([switch]$ApplyToDefaultUser)

    Set-ForgeRegistryValue -Path "HKCU:\Software\Microsoft\Notepad" -Name "EnableAI" -Type "DWord" -Value 0
    if ($ApplyToDefaultUser -and (Test-Path "Registry::HKLM\WinForge_Default")) {
        Set-ForgeRegistryValue -Path "HKLM:\WinForge_Default\Software\Microsoft\Notepad" -Name "EnableAI" -Type "DWord" -Value 0
    }
    Write-ForgeLog -Message "Notepad AI disabled" -Level Success
}

