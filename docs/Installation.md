# Installation

## Requirements

- **PowerShell 7.5.4+** — [Download](https://github.com/PowerShell/PowerShell/releases/tag/v7.5.4)
- **Windows 10** (1903+) or **Windows 11** (including 25H2)
- **Administrator** privileges

## Download

### Standard Edition
Includes all 20 modules (Infrastructure + Optimizations), profiles, snapshots, CLI, and UI.

### Extras Edition
Adds Defender Remover and MAS activation tools (inside `src/Forge Module/Extras/`).

## Run

```powershell
cd WinForge

# Interactive TUI menu
.\WinForge.ps1

# Apply a YAML profile
.\WinForge.ps1 -ProfilePath '.\src\Forge Profiles\Presets\balanced.yaml'

# WPF UI mode
.\WinForge.ps1 -UI

# Maintenance mode
.\WinForge.ps1 -Maintenance
```

## Build from Source

```powershell
.\build\Build-Standard.ps1    # Standard edition
.\build\Build-Extras.ps1      # Extras edition
.\build\Build-DualRelease.ps1 # Dual release
```
