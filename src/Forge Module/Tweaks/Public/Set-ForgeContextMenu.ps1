<#
.SYNOPSIS
    Switches between Classic and Modern context menus.
.PARAMETER Style
    Classic (Win10) or Modern (Win11).
#>
function Set-ForgeContextMenu {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [ValidateSet("Classic", "Modern")]
        [string]$Style = "Classic"
    )

    $clsid = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
    if ($Style -eq "Classic") {
        New-Item -Path $clsid -Force | Out-Null
        Set-ItemProperty -Path $clsid -Name "(Default)" -Value "" -Force
    } else {
        Remove-Item -Path $clsid -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-ForgeLog -Message "Context menu set to $Style" -Level Success
}
