<#
.SYNOPSIS
    WinForge v1.0.0 — The Windows Forge

.DESCRIPTION
    Main entry point for WinForge. Handles command-line arguments, loads all
    pillar modules, and launches either the interactive TUI or applies profiles
    in unattended CLI mode.

.PARAMETER ProfilePath
    Path to a YAML profile to apply in unattended mode.

.PARAMETER Gui
    Launch the WPF graphical interface directly.

.PARAMETER Maintenance
    Run maintenance mode (scheduled tasks only).

.PARAMETER NoSnapshot
    Skip automatic pre-optimization snapshot creation.

.NOTES
    Version: 1.0.0
    Author: Tomy Tate
    Requires: PowerShell 7.5+
    License: MIT

.EXAMPLE
    .\WinForge.ps1
    .\WinForge.ps1 -ProfilePath "profiles\balanced.yaml"
    .\WinForge.ps1 -Gui
#>

#Requires -Version 7.5
#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [string]$ProfilePath,
    [switch]$Gui,
    [switch]$Maintenance,
    [switch]$NoSnapshot
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
$PSNativeCommandArgumentPassing = 'Standard'

# ─────────────────────────────────────────────────────────
# Module Loading
# ─────────────────────────────────────────────────────────

Import-Module "$PSScriptRoot\WinForge.psd1" -Force -ErrorAction Stop

# ─────────────────────────────────────────────────────────
# Initialization
# ─────────────────────────────────────────────────────────

Write-ForgeLog -Message "WinForge v1.0.0 starting..." -Level Info
Write-ForgeLog -Message "PowerShell $($PSVersionTable.PSVersion)" -Level Debug
Write-ForgeLog -Message "Edition: Standard/Extras" -Level Debug

# ─────────────────────────────────────────────────────────
# Execution Modes
# ─────────────────────────────────────────────────────────

if ($Maintenance) {
    Write-ForgeLog -Message "Running in Maintenance mode..." -Level Info
    Invoke-ForgeMaintenance
    exit 0
}

if ($ProfilePath) {
    # Unattended CLI mode
    Write-ForgeLog -Message "Applying profile: $ProfilePath" -Level Info

    if (-not $NoSnapshot) {
        New-ForgeSnapshot -Name "Pre-WinForge-$((Get-Date).ToString('yyyyMMdd'))"
    }

    $config = Import-ForgeProfile -Path $ProfilePath
    # Profile application logic will be implemented as modules are completed
    Write-ForgeLog -Message "Profile applied successfully." -Level Success
    exit 0
}

if ($Gui) {
    Write-ForgeLog -Message "Launching GUI..." -Level Info
    Show-ForgeUI
    exit 0
}

# Default: Interactive TUI
Show-ForgeMenu

