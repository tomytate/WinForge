<#
.SYNOPSIS
    WinForge Snapshots Module

.DESCRIPTION
    Safety and rollback mechanisms: create, restore, and manage encrypted
    system snapshots. Uses PS 7.5 ConvertTo-CliXml for serialization
    and DPAPI for optional encryption.

.NOTES
    Module: Forge.Snapshots
    Version: 1.0.0
    Requires: PowerShell 7.5+
#>

#Requires -Version 7.5

using namespace System.Management.Automation
using namespace System.Collections.Generic
using namespace System.Security.Cryptography

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
