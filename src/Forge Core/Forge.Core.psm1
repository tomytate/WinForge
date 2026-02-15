<#
.SYNOPSIS
    WinForge Core Engine Module

.DESCRIPTION
    Provides foundational utilities for the WinForge framework:
    logging, registry manipulation, system inspection, and Sysprep support.
    All public functions follow the Verb-ForgeNoun naming convention.

.NOTES
    Module: Forge.Core
    Version: 1.0.0
    Requires: PowerShell 7.5+
#>

#Requires -Version 7.5

using namespace System.Management.Automation
using namespace System.Security.AccessControl

# Dot-source all private helpers first, then public functions
$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue)
$Public  = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"  -ErrorAction SilentlyContinue)

foreach ($file in @($Private + $Public)) {
    try {
        . $file.FullName
        Write-Verbose "Loaded: $($file.Name)"
    }
    catch {
        Write-Error "Failed to load $($file.FullName): $_"
    }
}

# Export only Public functions
Export-ModuleMember -Function $Public.BaseName
