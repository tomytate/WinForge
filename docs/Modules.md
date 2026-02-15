# Modules

WinForge ships with **20 modules** (15 optimization + 5 infrastructure) containing **82+ public functions**, organized into 6 pillars.

## Pillar Overview

| # | Pillar | Directory | Modules | Functions |
|---|--------|-----------|---------|-----------|
| 1 | Forge Core | `src/Forge Core/` | 1 | 15 (9 pub + 6 priv) |
| 2 | Forge Profiles | `src/Forge Profiles/` | 1 | 4 (3 pub + 1 priv) |
| 3 | Forge Snapshots | `src/Forge Snapshots/` | 1 | 4 |
| 4 | Forge Module | `src/Forge Module/` | 15 | 60 |
| 5 | Forge CLI | `src/Forge CLI/` | 1 | 4 (3 pub + 1 priv) |
| 6 | Forge UI | `src/Forge UI/` | 1 | 3 (1 pub + 2 priv) |

## Module Detail

### Forge Module — Standard Modules

| # | Module | Location | Pub | Key Commands |
|---|--------|----------|-----|-------------|
| 1 | `Forge.Bloatware` | `Forge Module/Bloatware/` | 6 | `Remove-ForgeBloatware`, `Disable-ForgeAI` |
| 2 | `Forge.Privacy` | `Forge Module/Privacy/` | 8 | `Set-ForgePrivacy`, `Add-ForgeHostsBlock` |
| 3 | `Forge.Performance` | `Forge Module/Performance/` | 7 | `Set-ForgePerformance`, `Measure-ForgeSystem` |
| 4 | `Forge.Gaming` | `Forge Module/Gaming/` | 3 | `Set-ForgeGaming`, `Set-ForgeGPUPriority` |
| 5 | `Forge.Network` | `Forge Module/Network/` | 4 | `Set-ForgeDNS`, `Get-ForgeDNSProviders` |
| 6 | `Forge.Security` | `Forge Module/Security/` | 2 | `Disable-ForgeSMBv1` |
| 7 | `Forge.Repair` | `Forge Module/Repair/` | 3 | `Repair-ForgeSystem` |
| 8 | `Forge.Maintenance` | `Forge Module/Maintenance/` | 2 | `Invoke-ForgeMaintenance` |
| 9 | `Forge.Software` | `Forge Module/Software/` | 3 | `Install-ForgeSoftware` |
| 10 | `Forge.Drivers` | `Forge Module/Drivers/` | 3 | `Update-ForgeDrivers` |
| 11 | `Forge.Tweaks` | `Forge Module/Tweaks/` | 12 | AI (7) + privacy (1) + UI (4) |
| 12 | `Forge.Features` | `Forge Module/Features/` | 2 | `Set-ForgeOptionalFeatures` |
| 13 | `Forge.Windows11` | `Forge Module/Windows11/` | 2 | `Get-ForgeWindowsVersion` |
| 14 | `Forge.Integrations` | `Forge Module/Integrations/` | 3 | `Invoke-ForgeShutUp10` |
| 15 | `Forge.Extras` | `Forge Module/Extras/` | 2 | `Invoke-ForgeDefenderRemover` |

## Naming Convention

All functions follow `Verb-ForgeNoun`:

```powershell
Remove-ForgeBloatware
Set-ForgePrivacy
Enable-ForgeUltimatePower
Disable-ForgeAIRecall
Show-ForgeUI
```
