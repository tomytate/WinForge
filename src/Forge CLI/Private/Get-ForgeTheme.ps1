<#
.SYNOPSIS
    Returns the WinForge TrueColor theme palette.
.DESCRIPTION
    Defines the brand color palette used across all CLI output.
    Colors are specified as hex values for TrueColor ANSI rendering.
.OUTPUTS
    [hashtable] Theme color definitions.
#>
function Get-ForgeTheme {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    return @{
        # Brand Colors
        Primary      = "#2196F3"    # Blue 500
        Secondary    = "#00BCD4"    # Cyan 500
        Accent       = "#FF9800"    # Orange 500

        # Status Colors
        Success      = "#4CAF50"    # Green 500
        Warning      = "#FFC107"    # Amber 500
        Error        = "#F44336"    # Red 500
        Info         = "#2196F3"    # Blue 500
        Debug        = "#78909C"    # Blue Grey 400

        # UI Colors
        Header       = "#FFFFFF"    # White
        Text         = "#ECEFF1"    # Blue Grey 50
        Muted        = "#78909C"    # Blue Grey 400
        Separator    = "#37474F"    # Blue Grey 800
        Highlight    = "#E91E63"    # Pink 500

        # Category Colors
        Bloatware    = "#FF9800"    # Orange
        Privacy      = "#9C27B0"    # Purple
        Performance  = "#00BCD4"    # Cyan
        Gaming       = "#E91E63"    # Pink
        Network      = "#3F51B5"    # Indigo
        Security     = "#4CAF50"    # Green
        Repair       = "#607D8B"    # Blue Grey
        Tweaks       = "#F44336"    # Red (AI Nuke)
        Extras       = "#FF5722"    # Deep Orange
    }
}
