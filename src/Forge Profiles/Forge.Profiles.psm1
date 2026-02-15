<#
.SYNOPSIS
    WinForge Profiles Module

.DESCRIPTION
    Configuration-as-code engine: loads, validates, and manages YAML profiles.
    Bundles powershell-yaml in Vendor/ for offline capability.

.NOTES
    Module: Forge.Profiles
    Version: 1.0.0
    Requires: PowerShell 7.5+
#>

#Requires -Version 7.5

using namespace System.Management.Automation

# Dot-source all private helpers first, then public functions
$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue)
$Public = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"  -ErrorAction SilentlyContinue)

foreach ($file in @($Private + $Public)) {
    try {
        . $file.FullName
        Write-Verbose "Loaded: $($file.Name)"
    }
    catch {
        Write-Error "Failed to load $($file.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName
