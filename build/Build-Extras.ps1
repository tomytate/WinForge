<#
.SYNOPSIS
    Build script for WinForge Extras edition.
.DESCRIPTION
    Creates a self-contained package including Extras module.
#>
param([string]$OutputDir = ".\dist\extras")

$ErrorActionPreference = "Stop"
Write-Host "Building WinForge Extras..."

# First build standard
& "$PSScriptRoot\Build-Standard.ps1" -OutputDir $OutputDir

# Then add Extras
$extrasSource = Join-Path $PSScriptRoot "..\src\Forge Module\Extras"
$extrasDest = Join-Path $OutputDir "src\Forge Module\Extras"
if (Test-Path $extrasSource) {
    Copy-Item $extrasSource -Destination $extrasDest -Recurse -Force
}

Write-Host "Extras build complete: $OutputDir" -ForegroundColor Green

