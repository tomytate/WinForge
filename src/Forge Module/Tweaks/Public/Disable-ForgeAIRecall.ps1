<#
.SYNOPSIS
    Auto-generated synopsis for Disable-ForgeAIRecall.
.DESCRIPTION
    This function was identified as missing documentation during the audit.
#>
function Disable-ForgeAIRecall {
    [CmdletBinding()]
    param([switch]$ApplyToDefaultUser)

    $tweaks = @(
        @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"; Name = "DisableAIDataAnalysis"; Type = "DWord"; Value = 1 },
        @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"; Name = "AllowRecallEnablement"; Type = "DWord"; Value = 0 }
    )
    foreach ($t in $tweaks) { Set-ForgeRegistryValue @t }

    if ($ApplyToDefaultUser -and (Test-Path "Registry::HKLM\WinForge_Default")) {
        Set-ForgeRegistryValue -Path "HKLM:\WinForge_Default\Software\Policies\Microsoft\Windows\WindowsAI" -Name "DisableAIDataAnalysis" -Type "DWord" -Value 1
    }
    Write-ForgeLog -Message "AI Recall disabled" -Level Success
}

