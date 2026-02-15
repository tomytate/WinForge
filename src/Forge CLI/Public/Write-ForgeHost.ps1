<#
.SYNOPSIS
    Writes colored text to the console using TrueColor ANSI escapes.
.PARAMETER Text
    Text to display.
.PARAMETER Color
    Hex color code (e.g., "#2196F3").
#>
function Write-ForgeHost {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string]$Text,
        [string]$Color = "#FFFFFF"
    )

    # Parse hex color
    $hex = $Color.TrimStart('#')
    $r = [Convert]::ToInt32($hex.Substring(0, 2), 16)
    $g = [Convert]::ToInt32($hex.Substring(2, 2), 16)
    $b = [Convert]::ToInt32($hex.Substring(4, 2), 16)

    # TrueColor ANSI: ESC[38;2;R;G;Bm
    $esc = [char]27
    Write-Host "${esc}[38;2;${r};${g};${b}m${Text}${esc}[0m"
}
