# About WinForge

**WinForge** is a modular PowerShell 7.5+ toolkit for Windows 10/11 that removes bloatware, hardens privacy, optimizes performance, and applies system tweaks.

## Architecture

WinForge is organized into 6 pillars under `src/`, following the `Forge <Name>` naming convention:

| Pillar | Directory | Purpose |
|--------|-----------|---------|
| **Forge Core** | `src/Forge Core/` | Logging, registry, system info, elevation |
| **Forge Profiles** | `src/Forge Profiles/` | YAML configuration engine with 5 presets |
| **Forge Snapshots** | `src/Forge Snapshots/` | DPAPI-encrypted system state backup |
| **Forge Module** | `src/Forge Module/` | 15 optimization modules |
| **Forge CLI** | `src/Forge CLI/` | Interactive TUI with TrueColor ANSI |
| **Forge UI** | `src/Forge UI/` | WPF dashboard |

### Dependency Order

Each layer only depends on layers loaded before it:

```
Forge Core → Forge Profiles → Forge Snapshots → Forge Module → Forge CLI → Forge UI
```

## Stats

- **20 modules** | **82+ public functions** | **PowerShell 7.5+**
- Dual-edition build: Standard (clean) and Extras
- YAML-driven profiles with hardware recommendation
- DPAPI-encrypted system snapshots
