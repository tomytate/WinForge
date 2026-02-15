# Forge.UI — WPF GUI for WinForge
# Dot-source all Public and Private functions

$Public  = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"  -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue)

foreach ($file in @($Public + $Private)) {
    try {
        . $file.FullName
        Write-Verbose "Loaded: $($file.Name)"
    }
    catch {
        Write-Error "Failed to load $($file.Name): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName
