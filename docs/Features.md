# Features

## Forge Core (`src/Forge Core/`)
Foundation layer — 9 public + 6 private functions for logging, registry manipulation with ACL validation, system information, and Sysprep.

## Forge Profiles (`src/Forge Profiles/`)
YAML-based configuration engine with 5 built-in presets (essential, balanced, aggressive, gaming, enterprise). Includes hardware-aware profile recommendation.

## Forge Snapshots (`src/Forge Snapshots/`)
DPAPI-encrypted system state snapshots. Create, restore, list, and remove snapshots with full registry and service state capture.

## Forge Module (`src/Forge Module/`)

### 🗑 Bloatware Removal (6 functions)
Remove pre-installed UWP apps, OneDrive, Edge, Xbox, and AI components.

### 🔒 Privacy Hardening (8 functions)
Disable telemetry tasks, block tracking domains via hosts file, manage advertising ID and activity history.

### ⚡ Performance Optimization (7 functions)
Optimize Windows services, enable Ultimate Power Plan, benchmark system, compare results.

### 🎮 Gaming Mode (3 functions)
Disable Nagle algorithm, mouse acceleration, Game DVR. Set GPU scheduling priority.

### 🌐 Network & DNS (4 functions)
Switch DNS providers (Cloudflare, Quad9, AdGuard, etc.), toggle IPv6, view network status.

### 🛡 Security (2 functions)
Disable SMBv1, enable PUA protection.

### 🤖 AI Nuke — Tweaks (12 functions)
Disable Recall, Copilot, Click-to-Do, Notepad AI, Paint AI, Edge AI, Desktop Spotlight, Settings 365 ads. Plus UI tweaks for taskbar, explorer, context menu, start menu.

### 🔧 Repair (3 functions)
Run DISM/SFC, reset network stack, reset Windows Update.

### 📦 Software (3 functions)
Install via Winget/Chocolatey, essentials bundles, software catalog.

### 🔄 Drivers (3 functions)
GPU info, driver status, updates.

### 🧹 Maintenance (2 functions)
Scheduled tasks, disk/app maintenance.

### ⚙ Features (2 functions)
Toggle Windows Optional Features, remove legacy capabilities.

### 🔗 Integrations (3 functions)
O&O ShutUp10, AdwCleaner, Snappy Driver Installer Origin.

### 🔥 Extras — Extras edition only (2 functions)
Defender Remover and Microsoft Activation Scripts. Located in `src/Forge Module/Extras/`.

## Forge CLI (`src/Forge CLI/`)
Interactive TUI menu with TrueColor ANSI rendering. Themed color palette for brand consistency.

## Forge UI (`src/Forge UI/`)
WPF dashboard with category-grouped action buttons, modern rounded styling, and dark theme.

## 🏆 Quality Assurance
- **PowerShell 7.5+**: Strict version enforcement for modern features and performance.
- **Perfect Test Suite**: 100% Pass Rate on 600+ tests (Linting + Unit + Integration).
- **Safety First**: Integration tests use mocks to ensure no accidental system modification happens during verification.
- **Static Analysis**: Custom PSScriptAnalyzer rules enforce secure JSON parsing and best practices.
