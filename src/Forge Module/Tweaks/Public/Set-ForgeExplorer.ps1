<#
.SYNOPSIS
    Configures File Explorer settings.
#>
function Set-ForgeExplorer {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [switch]$HideGallery,
        [switch]$HideHome,
        [switch]$ShowFileExtensions,
        [switch]$ShowHiddenFiles
    )

    $explorerPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    if ($HideGallery) {
        Set-ForgeRegistry -Path "HKCU:\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" -Name "System.IsPinnedToNameSpaceTree" -Value 0
    }
    if ($HideHome) {
        Set-ForgeRegistry -Path "HKCU:\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" -Name "System.IsPinnedToNameSpaceTree" -Value 0
    }
    if ($ShowFileExtensions) { Set-ForgeRegistry -Path $explorerPath -Name "HideFileExt" -Value 0 }
    if ($ShowHiddenFiles)    { Set-ForgeRegistry -Path $explorerPath -Name "Hidden" -Value 1 }

    Write-ForgeLog -Message "Explorer settings updated" -Level Success
}
