<#
.SYNOPSIS
    Displays the WinForge branded header.
#>
function Show-ForgeHeader {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $esc = [char]27
    $blue = "${esc}[38;2;33;150;243m"
    $cyan = "${esc}[38;2;0;188;212m"
    $white = "${esc}[38;2;255;255;255m"
    $grey = "${esc}[38;2;120;144;156m"
    $reset = "${esc}[0m"

    $version = "1.0.0"
    $edition = if (Get-Module Forge.Extras -ErrorAction SilentlyContinue) { "Extras" } else { "Standard" }

    Write-Host ""
    Write-Host "${blue}    ██╗    ██╗██╗███╗   ██╗███████╗ ██████╗ ██████╗  ██████╗ ███████╗${reset}"
    Write-Host "${blue}    ██║    ██║██║████╗  ██║██╔════╝██╔═══██╗██╔══██╗██╔════╝ ██╔════╝${reset}"
    Write-Host "${cyan}    ██║ █╗ ██║██║██╔██╗ ██║█████╗  ██║   ██║██████╔╝██║  ███╗█████╗  ${reset}"
    Write-Host "${cyan}    ██║███╗██║██║██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║   ██║██╔══╝  ${reset}"
    Write-Host "${white}    ╚███╔███╔╝██║██║ ╚████║██║     ╚██████╔╝██║  ██║╚██████╔╝███████╗${reset}"
    Write-Host "${white}     ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝${reset}"
    Write-Host ""
    Write-Host "${grey}    The Windows Forge — v${version} ${edition} Edition${reset}"
    Write-Host "${grey}    PowerShell $($PSVersionTable.PSVersion) | $(Get-ForgeWindowsVersion | Select-Object -Expand Version)${reset}"
    Write-Host ""
}
