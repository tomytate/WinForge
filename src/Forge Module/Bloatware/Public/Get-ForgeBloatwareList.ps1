<#
.SYNOPSIS
    Returns the list of known bloatware app patterns.
.DESCRIPTION
    Returns a categorized list of pre-installed Windows app packages
    considered bloatware. Used by Remove-ForgeBloatware to identify
    apps for removal.
.PARAMETER Category
    Filter by category: All, Communication, Entertainment, Unnecessary, Microsoft.
.OUTPUTS
    [string[]] Array of app package name patterns.
.EXAMPLE
    Get-ForgeBloatwareList
    Get-ForgeBloatwareList -Category Entertainment
#>
function Get-ForgeBloatwareList {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [ValidateSet("All", "Communication", "Entertainment", "Unnecessary", "Microsoft")]
        [string]$Category = "All"
    )

    $dataFile = "$PSScriptRoot\..\Data\bloatware-patterns.json"
    if (Test-Path $dataFile) {
        $patterns = Get-Content $dataFile -Raw | ConvertFrom-Json -DateKind Json
        if ($Category -eq "All") {
            return $patterns.PSObject.Properties.Value | ForEach-Object { $_ }
        }
        return $patterns.$Category
    }

    # Fallback: built-in list
    $apps = @{
        Communication = @(
            "Microsoft.People", "Microsoft.SkypeApp", "Microsoft.YourPhone",
            "Microsoft.WindowsCommunicationsApps"
        )
        Entertainment = @(
            "Microsoft.ZuneVideo", "Microsoft.ZuneMusic", "Microsoft.MixedReality.Portal",
            "Microsoft.Xbox.TCUI", "Microsoft.XboxApp", "Microsoft.XboxGameOverlay",
            "Microsoft.XboxGamingOverlay", "Microsoft.XboxIdentityProvider",
            "Microsoft.XboxSpeechToTextOverlay", "Microsoft.GamingApp"
        )
        Unnecessary   = @(
            "Microsoft.BingWeather", "Microsoft.BingNews", "Microsoft.GetHelp",
            "Microsoft.Getstarted", "Microsoft.MicrosoftSolitaireCollection",
            "Microsoft.WindowsFeedbackHub", "Microsoft.WindowsMaps",
            "Microsoft.MicrosoftStickyNotes", "Microsoft.WindowsSoundRecorder",
            "Microsoft.PowerAutomateDesktop", "Microsoft.Todos",
            "MicrosoftCorporationII.QuickAssist", "Microsoft.ScreenSketch",
            "Clipchamp.Clipchamp", "Microsoft.549981C3F5F10", "Microsoft.OutlookForWindows",
            "Microsoft.BingSearch", "Microsoft.Windows.DevHome", "Microsoft.Copilot"
        )
        Microsoft     = @(
            "Microsoft.Office.OneNote", "Microsoft.MicrosoftOfficeHub",
            "Microsoft.OneDriveSync", "Microsoft.OneDrive"
        )
    }

    if ($Category -eq "All") {
        return $apps.Values | ForEach-Object { $_ }
    }
    return $apps[$Category]
}
