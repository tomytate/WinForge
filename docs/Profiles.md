# Profiles

WinForge uses YAML profiles for declarative system configuration. The profile engine lives in `src/Forge Profiles/`.

## Built-in Presets

Located in `src/Forge Profiles/Presets/`:

| Preset | File | Risk Level | Best For |
|--------|------|------------|----------|
| Essential | `essential.yaml` | 🟢 Low | Safe for all systems |
| Balanced | `balanced.yaml` | 🟡 Medium | Good balance of optimization |
| Aggressive | `aggressive.yaml` | 🔴 High | Maximum debloat |
| Gaming | `gaming.yaml` | 🟡 Medium | Gaming performance |
| Enterprise | `enterprise.yaml` | 🟢 Low | Corporate/managed environments |

## Profile Format

```yaml
metadata:
  name: My Profile
  description: Custom configuration
  version: 1.0.0

bloatware:
  mode: moderate          # conservative | moderate | aggressive
  exclude:
    - Microsoft.Paint

privacy:
  disable_telemetry: true
  hosts_blocking: true
  telemetry_tasks: all    # safe | all

performance:
  services_preset: Performance  # Privacy | Performance | Security | Minimal
  power_plan: high              # balanced | high | ultimate

gaming:
  enabled: true

tweaks:
  ai:
    disable_copilot: true
    disable_recall: true
  ui:
    taskbar_alignment: left
    context_menu: classic
```

## Usage

```powershell
# Apply a built-in preset
.\WinForge.ps1 -ProfilePath '.\src\Forge Profiles\Presets\balanced.yaml'

# Get hardware-recommended profile
Get-ForgeRecommendedProfile

# Validate a profile before applying
Test-ForgeProfile -Path .\my-profile.yaml
```

## Schema Validation

Profile schemas live in `src/Forge Profiles/Schema/`. Use `Test-ForgeProfile` to validate any custom profile against the schema before applying.
