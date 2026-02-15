<#
.SYNOPSIS
    Disables Game DVR and Game Bar recording.
#>
function Disable-ForgeGameDVR {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    Set-ForgeRegistry -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0
    Set-ForgeRegistry -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0
    Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0
    Write-ForgeLog -Message "Game DVR and Game Bar disabled" -Level Success
}
