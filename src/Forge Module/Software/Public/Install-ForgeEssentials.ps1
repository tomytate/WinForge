<#
.SYNOPSIS
    Installs a curated set of essential applications.
#>
function Install-ForgeEssentials {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [ValidateSet("Browsers", "Runtimes", "Utilities", "Media", "Dev", "All")]
        [string]$Category = "All"
    )

    $essentials = @{
        Browsers  = @("Mozilla.Firefox", "Google.Chrome", "BraveSoftware.BraveBrowser")
        Runtimes  = @("Microsoft.VCRedist.2015+.x64", "Microsoft.DotNet.DesktopRuntime.8", "Oracle.JavaRuntimeEnvironment")
        Utilities = @("7zip.7zip", "Notepad++.Notepad++", "voidtools.Everything", "Microsoft.PowerToys")
        Media     = @("VideoLAN.VLC", "GIMP.GIMP", "OBSProject.OBSStudio")
        Dev       = @("Microsoft.VisualStudioCode", "Git.Git", "Microsoft.WindowsTerminal")
    }

    $packages = if ($Category -eq "All") { $essentials.Values | ForEach-Object { $_ } } else { $essentials.$Category }

    if ($packages) {
        Install-ForgeSoftware -Packages $packages -Manager Winget
    }
}
