<#
.SYNOPSIS
    Configures the Start Menu.
#>
function Set-ForgeStartMenu {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [switch]$DisableRecommended,
        [switch]$DisableBingSearch
    )

    if ($DisableRecommended) {
        Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "HideRecommendedSection" -Value 1
        Write-ForgeLog -Message "Start Menu Recommended section hidden" -Level Success
    }
    if ($DisableBingSearch) {
        Set-ForgeRegistry -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1
        Set-ForgeRegistry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
        Write-ForgeLog -Message "Bing search in Start Menu disabled" -Level Success
    }
}
