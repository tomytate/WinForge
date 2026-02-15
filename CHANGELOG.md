# Changelog

All notable changes to WinForge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-02-15

### 🚀 Release Highlights
WinForge 1.0.0 is a production-ready, strictly modernized PowerShell 7.5 toolkit. It combines a robust architecture with a "Perfect Test" suite (100% pass rate) and deep system optimizations.

### 🏗 Architecture & Core
- **6-Pillar structure** under `src/`: Core, Profiles, Snapshots, Module, CLI, UI.
- **PowerShell 7.5 Enforcement**: All modules strictly require PS 7.5+.
- **JSON Robustness**: Applied `-DateKind Json` to all parsers.
- **Parallel Performance**: `Measure-ForgeSystem` usages `ForEach-Object -Parallel`.
- **Modern Logging**: `Write-ForgeLog` uses `$PSStyle` for TrueColor ANSI.

### ✨ Features
- **20 Modules** (15 Optimization + 5 Infrastructure) with **82+ functions**.
- **12 AI Tweaks**: Recall, Copilot, Click-to-Do, Notepad/Paint AI, etc.
- **Smart Profiles**: YAML-based engine (Essential, Balanced, Gaming, Enterprise).
- **Snapshot System**: DPAPI-encrypted system state backup/restore.
- **Dual-Edition**: Standard (Clean) and Extras (Defender Remover + MAS).
- **Interactive CLI**: TrueColor TUI with menu-based navigation.
- **WPF Dashboard**: Modern UI with category-grouped action buttons.
- **Auto-Install**: Self-healing launcher installs PowerShell 7.5.4 via Winget if missing.
- **DNS Switcher**: Cloudflare, Google, Quad9, AdGuard, OpenDNS, NextDNS.

### 🛠 Quality Assurance ("Perfect Test")
- **100% Pass Rate**: 600+ tests (Linting, Unit, Integration).
- **Code Coverage**: Enabled for `src/`.
- **Static Analysis**: Custom PSScriptAnalyzer rules (e.g., `AvoidImplicitJsonDate`).
- **Safety**: Integration tests use mocks to prevent system modification.
- **Documentation**: All public functions enforced to have `.SYNOPSIS`.
