<div align="center">

# ⚒ WinForge

**The Windows Forge — Debloat, Harden, Optimize**

[![PowerShell](https://img.shields.io/badge/PowerShell-7.5+-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)
[![Windows](https://img.shields.io/badge/Windows-10_%7C_11-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Version](https://img.shields.io/badge/Version-1.0.0-00D9FF?style=for-the-badge)](https://github.com/tomytate/WinForge/releases)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

*20 Modules · 82+ Functions · YAML-Driven Profiles · DPAPI Snapshots*

</div>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Key Features](#-key-features)
- [Quick Start](#-quick-start)
- [Editions](#-editions)
- [Architecture](#-architecture)
- [Module Reference](#-module-reference)
- [YAML Profiles](#-yaml-profiles)
- [Security](#-security)
- [Building](#-building)
- [Testing](#-testing)

---

## Overview

WinForge is a modular PowerShell 7.5+ toolkit for Windows 10/11 that removes bloatware, hardens privacy, optimizes performance, and applies system tweaks through YAML-driven profiles or an interactive TUI/GUI menu.

Every operation creates an encrypted DPAPI snapshot beforehand — so you can always roll back with a single command.

---

## ✨ Key Features

| Category | What It Does |
|----------|--------------|
| 🗑 **Bloatware** | Remove UWP apps, OneDrive, Edge, Xbox, AI components |
| 🔒 **Privacy** | Disable telemetry, block tracking domains via hosts, disable spy scheduled tasks |
| ⚡ **Performance** | Optimize services, power plans, RAM, system benchmarking |
| 🎮 **Gaming** | Disable Nagle, mouse accel, Game DVR; GPU priority tuning |
| 🌐 **Network** | DNS provider switching (10 providers), IPv6 toggle |
| 🛡 **Security** | Disable SMBv1, enable PUA protection |
| 🤖 **AI Nuke** | Kill Recall, Copilot, Click-to-Do, Notepad AI, Paint AI, Edge AI |
| 🔧 **Repair** | DISM/SFC healing, network reset, Windows Update reset |
| 📸 **Snapshots** | DPAPI-encrypted system state snapshots with one-command restore |
| 📋 **Profiles** | YAML-based configuration (essential, balanced, aggressive, gaming, enterprise) |

---

## 🚀 Quick Start

### Requirements

- **PowerShell 7.5+** — [Install guide](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)
- **Windows 10** (1903+) or **Windows 11** (including 25H2)
- **Administrator** privileges

### Run

```powershell
# Interactive TUI Menu
.\WinForge.ps1

# Apply a YAML profile directly
.\WinForge.ps1 -ProfilePath .\src\"Forge Profiles"\Presets\balanced.yaml

# GUI Mode (WPF Dashboard)
.\WinForge.ps1 -UI

# Maintenance Mode
.\WinForge.ps1 -Maintenance
```

---

## 📦 Editions

| Feature | Standard | Extras |
|---------|:--------:|:------:|
| 20 Core Modules | ✅ | ✅ |
| 82+ Functions | ✅ | ✅ |
| YAML Profiles | ✅ | ✅ |
| Snapshots (DPAPI) | ✅ | ✅ |
| UI + TUI | ✅ | ✅ |
| Defender Remover | ❌ | ✅ |
| MAS Activation | ❌ | ✅ |

---

## 🏗 Architecture

```
WinForge/
├── WinForge.ps1                      # Entry point
├── WinForge.psd1                     # Master module manifest
├── WinForge.psm1                     # Module loader
├── src/
│   ├── Forge Core/                   # Logging, Registry, System Info, Sysprep
│   │   ├── Public/                   # 9 exported functions
│   │   └── Private/                  # Internal helpers
│   │
│   ├── Forge Profiles/               # YAML configuration engine
│   │   ├── Public/                   # 3 exported functions
│   │   ├── Presets/                  # essential, balanced, aggressive, gaming, enterprise
│   │   ├── Schema/                   # Profile validation schema
│   │   └── Vendor/                   # powershell-yaml (vendored)
│   │
│   ├── Forge Snapshots/              # DPAPI-encrypted state snapshots
│   │   └── Public/                   # 4 exported functions
│   │
│   ├── Forge Module/                 # 15 optimization modules
│   │   ├── Bloatware/                # 6 functions
│   │   ├── Privacy/                  # 8 functions
│   │   ├── Performance/              # 7 functions
│   │   ├── Gaming/                   # 3 functions
│   │   ├── Network/                  # 4 functions
│   │   ├── Security/                 # 2 functions
│   │   ├── Repair/                   # 3 functions
│   │   ├── Maintenance/              # 2 functions
│   │   ├── Software/                 # 3 functions
│   │   ├── Drivers/                  # 3 functions
│   │   ├── Tweaks/                   # 12 functions (7 AI + 1 privacy + 4 UI)
│   │   ├── Features/                 # 2 functions
│   │   ├── Windows11/                # 2 functions
│   │   ├── Integrations/             # 4 functions
│   │   └── Extras/                   # 2 functions (Extras edition only)
│   │
│   ├── Forge CLI/                    # Interactive TUI menu
│   │   └── Public/                   # 3 exported functions
│   │
│   └── Forge UI/                     # WPF dashboard
│       ├── Public/                   # 1 exported function
│       └── Views/                    # MainWindow.xaml
│
├── build/                            # Build scripts (Standard/Extras)
├── tests/                            # Pester test suite
├── docs/                             # Documentation
└── profiles/                         # Legacy profile directory
```

---

## 🔧 Module Reference

### Core Pillars

| Pillar | Module | Exported Functions | Description |
|--------|--------|--------------------|-------------|
| Forge Core | `Forge.Core` | 9 | Logging, registry, system info, Sysprep, elevation |
| Forge Profiles | `Forge.Profiles` | 3 | YAML import, validation, hardware recommendation |
| Forge Snapshots | `Forge.Snapshots` | 4 | Create, restore, list, remove system snapshots |

### Standard Modules

| Module | Functions | Key Commands |
|--------|-----------|--------------|
| `Forge.Bloatware` | 6 | `Remove-ForgeBloatware`, `Remove-ForgeOneDrive`, `Remove-ForgeEdge`, `Remove-ForgeXbox`, `Disable-ForgeAI`, `Get-ForgeBloatwareList` |
| `Forge.Privacy` | 8 | `Set-ForgePrivacy`, `Add-ForgeHostsBlock`, `Disable-ForgeTelemetryTasks`, `Get-ForgeTelemetryDomains` |
| `Forge.Performance` | 7 | `Set-ForgePerformance`, `Enable-ForgeUltimatePower`, `Set-ForgeServices`, `Measure-ForgeSystem` |
| `Forge.Gaming` | 3 | `Set-ForgeGaming`, `Disable-ForgeGameDVR`, `Set-ForgeGPUPriority` |
| `Forge.Network` | 4 | `Set-ForgeDNS`, `Get-ForgeDNSProviders`, `Set-ForgeIPv6`, `Get-ForgeNetworkStatus` |
| `Forge.Security` | 2 | `Disable-ForgeSMBv1`, `Enable-ForgePUAProtection` |
| `Forge.Repair` | 3 | `Repair-ForgeSystem`, `Reset-ForgeNetwork`, `Reset-ForgeUpdate` |
| `Forge.Maintenance` | 2 | `Invoke-ForgeMaintenance`, `Register-ForgeMaintenance` |
| `Forge.Software` | 3 | `Install-ForgeSoftware`, `Install-ForgeEssentials`, `Update-ForgeSoftware` |
| `Forge.Drivers` | 3 | `Get-ForgeGPUInfo`, `Get-ForgeDriverStatus`, `Update-ForgeDrivers` |
| `Forge.Tweaks` | 12 | 7 AI tweaks, 1 settings tweak, 4 UI tweaks |
| `Forge.Features` | 2 | `Set-ForgeOptionalFeatures`, `Remove-ForgeCapabilities` |
| `Forge.Windows11` | 2 | `Get-ForgeWindowsVersion`, `Test-ForgeWindows11` |
| `Forge.Integrations` | 4 | `Invoke-ForgeShutUp10`, `Invoke-ForgeAdwCleaner`, `Update-ForgeSDIO`, `Invoke-ForgeActivation` |
| `Forge.Extras` | 2 | `Invoke-ForgeDefenderRemover`, `Invoke-ForgeActivation` |

### Interface Pillars

| Pillar | Module | Exported Functions | Description |
|--------|--------|--------------------|-------------|
| Forge CLI | `Forge.CLI` | 3 | Interactive TUI menu with TrueColor ANSI output |
| Forge UI | `Forge.UI` | 1 | WPF dashboard with styled action buttons |

---

## 📋 YAML Profiles

```yaml
# balanced.yaml — recommended starting point
bloatware:
  mode: moderate
  exclude: []
privacy:
  disable_telemetry: true
  hosts_blocking: true
performance:
  services_preset: Performance
  power_plan: high
gaming:
  enabled: false
tweaks:
  ai:
    disable_copilot: true
    disable_recall: true
```

**Built-in presets:** `essential`, `balanced`, `aggressive`, `gaming`, `enterprise`

---

## 🔒 Security

| Control | Details |
|---------|---------|
| **ACL Validation** | Registry writes validated against security descriptors |
| **DPAPI Encryption** | Snapshots encrypted with Windows Data Protection API |
| **User Consent** | High-impact operations require explicit confirmation |
| **No External Calls** | Standard edition makes zero network requests |
| **`SupportsShouldProcess`** | All destructive operations support `-WhatIf` |

---

## 🏗 Building

```powershell
.\build\Build-Standard.ps1    # Standard edition
.\build\Build-Extras.ps1      # Extras edition
.\build\Build-Both.ps1        # Both editions
```

---

## 🧪 Testing

```powershell
Invoke-Pester ./tests/ -Output Detailed
```

---

## 📜 License

[MIT License](LICENSE) — Copyright © 2026 WinForge

---

<div align="center">
  <strong>⚒ WinForge — The Windows Forge</strong><br/>
  <em>PowerShell 7.5+ · 20 Modules · 82+ Functions · YAML Profiles · DPAPI Snapshots</em>
</div>
