<#
.SYNOPSIS
    WinForge Drivers Module
.DESCRIPTION
    Driver management and updates.
.NOTES
    Module: Forge.Drivers
    Version: 1.0.0
#>
#Requires -Version 7.5

$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue)
$Public  = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"  -ErrorAction SilentlyContinue)
foreach ($file in @($Private + $Public)) {
    try { . $file.FullName } catch { Write-Error "Failed to load $($file.FullName): $_" }
}
Export-ModuleMember -Function $Public.BaseName
