# Home

Welcome to **WinForge** — The Windows Forge.

## What is WinForge?

WinForge is a PowerShell 7.5+ toolkit that helps you debloat, harden, and optimize Windows 10/11. It ships with **20 modules** (15 optimization + 5 infrastructure) organized into 6 pillars under `src/`:

- **Forge Core** — Foundation (logging, registry, system info)
- **Forge Profiles** — YAML configuration engine
- **Forge Snapshots** — DPAPI-encrypted system state backup
- **Forge Module** — 15 optimization modules (Bloatware, Privacy, etc.)
- **Forge CLI** — Interactive TUI menu
- **Forge UI** — WPF dashboard

## Quick Start

```powershell
# Interactive menu
.\WinForge.ps1

# Apply a profile
.\WinForge.ps1 -ProfilePath '.\src\Forge Profiles\Presets\balanced.yaml'

# UI mode
.\WinForge.ps1 -UI
```

## Navigation

- [About](About.md)
- [Installation](Installation.md)
- [Features](Features.md)
- [Modules](Modules.md)
- [Profiles](Profiles.md)
- [Troubleshooting](Troubleshooting.md)
