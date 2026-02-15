<#
.SYNOPSIS
    Build script for WinForge Standard edition.
.DESCRIPTION
    Creates a self-contained package excluding Extras module.
#>
param([string]$OutputDir = ".\dist\standard")

$ErrorActionPreference = "Stop"
Write-Host "Building WinForge Standard..."

if (Test-Path $OutputDir) { Remove-Item $OutputDir -Recurse -Force }
New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null

# Copy core structure
$include = @(
    "WinForge.ps1", "WinForge.psd1", "LICENSE", "README.md",
    "src\Forge Core", "src\Forge Profiles", "src\Forge Snapshots",
    "src\Forge Module", "src\Forge CLI", "src\Forge UI"
)

foreach ($item in $include) {
    $source = Join-Path $PSScriptRoot "..\$item"
    if (Test-Path $source) {
        $dest = Join-Path $OutputDir $item
        if ((Get-Item $source).PSIsContainer) {
            Copy-Item $source -Destination $dest -Recurse -Force
        }
        else {
            $destDir = Split-Path $dest -Parent
            New-Item -Path $destDir -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
            Copy-Item $source -Destination $dest -Force
        }
    }
}

# Remove Extras from Standard build
if (Test-Path "$OutputDir\src\Forge Module\Extras") {
    Remove-Item "$OutputDir\src\Forge Module\Extras" -Recurse -Force -ErrorAction SilentlyContinue
}

# Remove old .psm1 files from core (they are replaced by new structure)
Get-ChildItem "$OutputDir\src\Forge Core\*.psm1" | Where-Object { $_.Name -ne "Forge.Core.psm1" } | Remove-Item -Force -ErrorAction SilentlyContinue
Remove-Item "$OutputDir\src\Forge Core\*.cs" -Force -ErrorAction SilentlyContinue

Write-Host "Standard build complete: $OutputDir" -ForegroundColor Green

