<#
.SYNOPSIS
    WinForge Performance Module

.DESCRIPTION
    System performance optimization: power plans, visual effects, services,
    RAM optimization, and benchmarking.

.NOTES
    Module: Forge.Performance
    Version: 1.0.0
#>

#Requires -Version 7.5

$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue)
$Public = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"  -ErrorAction SilentlyContinue)

foreach ($file in @($Private + $Public)) {
    try { . $file.FullName } catch { Write-Error "Failed to load $($file.FullName): $_" }
}

Export-ModuleMember -Function $Public.BaseName
