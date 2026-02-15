<#
.SYNOPSIS
    Configures Windows taskbar alignment and settings.
.PARAMETER Alignment
    Left or Center.
#>
function Set-ForgeTaskbar {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [ValidateSet("Left", "Center")]
        [string]$Alignment = "Left",
        [switch]$HideSearch,
        [switch]$HideWidgets,
        [switch]$HideChat
    )

    $taskbarPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    if ($Alignment -eq "Left") {
        Set-ForgeRegistry -Path $taskbarPath -Name "TaskbarAl" -Value 0
    } else {
        Set-ForgeRegistry -Path $taskbarPath -Name "TaskbarAl" -Value 1
    }

    if ($HideSearch)  { Set-ForgeRegistry -Path $taskbarPath -Name "SearchboxTaskbarMode" -Value 0 }
    if ($HideWidgets) { Set-ForgeRegistry -Path $taskbarPath -Name "TaskbarDa" -Value 0 }
    if ($HideChat)    { Set-ForgeRegistry -Path $taskbarPath -Name "TaskbarMn" -Value 0 }

    Write-ForgeLog -Message "Taskbar configured (Alignment: $Alignment)" -Level Success
}
