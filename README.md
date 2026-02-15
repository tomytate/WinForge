<p align="center">
  <h1 align="center">⚒ WinForge</h1>
  <p align="center"><strong>The Windows Forge — Debloat, Harden, Optimize</strong></p>
  <p align="center">
    <img src="https://img.shields.io/badge/PowerShell-7.5%2B-5391FE?logo=powershell&logoColor=white" alt="PowerShell 7.5+"/>
    <img src="https://img.shields.io/badge/Windows-10%20%7C%2011%20(25H2)-0078D6?logo=windows&logoColor=white" alt="Windows 10/11"/>
    <img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License"/>
  </p>
</p>

---

WinForge is a modular PowerShell 7.5+ toolkit for Windows 10/11 that removes bloatware, hardens privacy, optimizes performance, and applies system tweaks through YAML-driven profiles or an interactive menu.

## ✨ Key Features

| Category | What It Does |
|----------|-------------|
| 🗑 **Bloatware** | Remove UWP apps, OneDrive, Edge, Xbox, AI components |
| 🔒 **Privacy** | Disable telemetry, block tracking domains via hosts, kill scheduled spy tasks |
| ⚡ **Performance** | Optimize services, power plans, RAM, benchmarking |
| 🎮 **Gaming** | Disable Nagle, mouse accel, Game DVR; GPU priority tuning |
| 🌐 **Network** | DNS provider switching (Cloudflare, Quad9, etc.), IPv6 toggle |
| 🛡 **Security** | Disable SMBv1, enable PUA protection |
| 🤖 **AI Nuke** | Kill Recall, Copilot, Click-to-Do, Notepad AI, Paint AI, Edge AI |
| 🔧 **Repair** | DISM/SFC healing, network reset, Windows Update reset |
| 📸 **Snapshots** | DPAPI-encrypted system state snapshots with restore |
| 📋 **Profiles** | YAML-based configuration (essential, balanced, aggressive, gaming, enterprise) |

## 🚀 Quick Start

### Requirements

- **PowerShell 7.5+** — [Install](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)
- **Windows 10** (1903+) or **Windows 11** (including 25H2)
- **Administrator** privileges

### Run

```powershell
# Interactive TUI Menu
.\WinForge.ps1

# Apply a YAML profile directly
.\WinForge.ps1 -ProfilePath .\src\Forge Profiles\Presets\balanced.yaml

# GUI Mode
.\WinForge.ps1 -UI

# Maintenance Mode
.\WinForge.ps1 -Maintenance
```

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

## 🏗 Architecture

```
WinForge/
├── WinForge.ps1                     # Entry point
├── WinForge.psd1                    # Master manifest
├── src/
│   ├── Forge Core/                  # Logging, Registry, System Info, Sysprep
│   │   ├── Public/                  # 9 exported functions
│   │   └── Private/                 # 6 internal helpers
│   │
│   ├── Forge Profiles/              # YAML configuration engine
│   │   ├── Public/                  # 3 exported functions
│   │   ├── Private/                 # 1 schema helper
│   │   ├── Presets/                 # essential, balanced, aggressive, gaming, enterprise
│   │   ├── Schema/                  # Profile validation schema
│   │   └── Vendor/                  # powershell-yaml (vendored)
│   │
│   ├── Forge Snapshots/             # DPAPI-encrypted state snapshots
│   │   └── Public/                  # 4 exported functions
│   │
│   ├── Forge Module/                # 15 optimization modules
│   │   ├── Bloatware/               # 6 functions
│   │   ├── Privacy/                 # 8 functions
│   │   ├── Performance/             # 7 functions
│   │   ├── Gaming/                  # 3 functions
│   │   ├── Network/                 # 4 functions
│   │   ├── Security/                # 2 functions
│   │   ├── Repair/                  # 3 functions
│   │   ├── Maintenance/             # 2 functions
│   │   ├── Software/                # 3 functions
│   │   ├── Drivers/                 # 3 functions
│   │   ├── Tweaks/                  # 12 functions
│   │   ├── Features/                # 2 functions
│   │   ├── Windows11/               # 2 functions
│   │   ├── Integrations/            # 3 functions
│   │   └── Extras/                  # 2 functions (Extras edition only)
│   │
│   ├── Forge CLI/                   # Interactive TUI menu
│   │   ├── Public/                  # 3 exported functions
│   │   └── Private/                 # 1 theme helper
│   │
│   └── Forge UI/                    # WPF dashboard
│       ├── Public/                  # 1 exported function
│       ├── Private/                 # 2 helpers
│       └── Views/                   # MainWindow.xaml
│
├── build/                           # Build scripts for Standard/Extras
├── tests/                           # Pester tests
├── docs/                            # Documentation
└── profiles/                        # Legacy profiles
```

## 🔧 Module Reference

### Core Pillars

| Pillar | Module | Functions | Description |
|--------|--------|-----------|-------------|
| Forge Core | `Forge.Core` | 15 | Logging, registry, system info, Sysprep, elevation |
| Forge Profiles | `Forge.Profiles` | 4 | YAML import, validation, hardware recommendation |
| Forge Snapshots | `Forge.Snapshots` | 4 | Create, restore, list, remove system snapshots |

### Standard Modules (inside Forge Module)

| Module | Functions | Key Commands |
|--------|-----------|-------------|
| `Forge.Bloatware` | 6 | `Remove-ForgeBloatware`, `Remove-ForgeOneDrive`, `Disable-ForgeAI` |
| `Forge.Privacy` | 8 | `Set-ForgePrivacy`, `Add-ForgeHostsBlock`, `Disable-ForgeTelemetryTasks` |
| `Forge.Performance` | 7 | `Set-ForgePerformance`, `Enable-ForgeUltimatePower`, `Measure-ForgeSystem` |
| `Forge.Gaming` | 3 | `Set-ForgeGaming`, `Disable-ForgeGameDVR`, `Set-ForgeGPUPriority` |
| `Forge.Network` | 4 | `Set-ForgeDNS`, `Get-ForgeDNSProviders`, `Get-ForgeNetworkStatus` |
| `Forge.Security` | 2 | `Disable-ForgeSMBv1`, `Enable-ForgePUAProtection` |
| `Forge.Repair` | 3 | `Repair-ForgeSystem`, `Reset-ForgeNetwork`, `Reset-ForgeUpdate` |
| `Forge.Maintenance` | 2 | `Invoke-ForgeMaintenance`, `Register-ForgeMaintenance` |
| `Forge.Software` | 3 | `Install-ForgeSoftware`, `Install-ForgeEssentials`, `Update-ForgeSoftware` |
| `Forge.Drivers` | 3 | `Get-ForgeGPUInfo`, `Get-ForgeDriverStatus`, `Update-ForgeDrivers` |
| `Forge.Tweaks` | 12 | AI tweaks (7), privacy tweaks (1), UI tweaks (4) |
| `Forge.Features` | 2 | `Set-ForgeOptionalFeatures`, `Remove-ForgeCapabilities` |
| `Forge.Windows11` | 2 | `Get-ForgeWindowsVersion`, `Test-ForgeWindows11` |
| `Forge.Integrations` | 3 | `Invoke-ForgeShutUp10`, `Invoke-ForgeAdwCleaner`, `Update-ForgeSDIO` |
| `Forge.Extras` | 2 | `Invoke-ForgeDefenderRemover`, `Invoke-ForgeActivation` |

### Interface Pillars

| Pillar | Module | Functions | Description |
|--------|--------|-----------|-------------|
| Forge CLI | `Forge.CLI` | 3 | Interactive TUI menu with TrueColor ANSI output |
| Forge UI | `Forge.UI` | 1 | WPF dashboard with styled action buttons |

## 📋 YAML Profiles

```yaml
# balanced.yaml
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

## 🔒 Security

- **ACL Validation** — Registry writes validated against security descriptors
- **DPAPI Encryption** — Snapshots encrypted with Windows Data Protection API
- **User Consent** — High-impact operations require explicit confirmation
- **No External Calls** — Standard edition makes zero network requests
- **`SupportsShouldProcess`** — All destructive operations support `-WhatIf`

## 🏗 Building

```powershell
.\build\Build-Standard.ps1    # Standard edition
.\build\Build-Extras.ps1      # Extras edition
.\build\Build-Both.ps1        # Both
```

## 🧪 Testing

```powershell
Invoke-Pester ./tests/ -Output Detailed
```

## 📜 License

[MIT License](LICENSE)

---

<p align="center">
  <strong>⚒ WinForge — The Windows Forge</strong><br/>
  <em>Built with PowerShell 7.5+ | 20 Modules | 82+ Functions</em>
</p>
