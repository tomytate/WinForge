# Contributing to WinForge

Thank you for your interest in contributing! This document provides guidelines and conventions.

## Development Requirements

- **PowerShell 7.5.4+**
- **Windows 10/11** (for testing)
- **Pester 5+** (for tests)

## Project Structure

```
src/
├── Forge Core/          # Foundation: logging, registry, system info
├── Forge Profiles/      # YAML configuration engine
├── Forge Snapshots/     # DPAPI-encrypted state backup
├── Forge Module/        # All optimization modules (15 sub-modules)
├── Forge CLI/           # Interactive TUI menu
└── Forge UI/            # WPF dashboard
```

### Dependency Order (Chronological)

Code is written so each layer only depends on layers above it:

```
1. Forge Core       → depends on: nothing (foundation)
2. Forge Profiles   → depends on: Forge Core
3. Forge Snapshots  → depends on: Forge Core
4. Forge Module     → depends on: Forge Core
5. Forge CLI        → depends on: everything above
6. Forge UI         → depends on: everything above
```

## Coding Conventions

### Naming

| Element | Convention | Example |
|---------|-----------|---------|
| Functions | `Verb-ForgeNoun` | `Set-ForgePrivacy`, `Get-ForgeDriverStatus` |
| Modules | `Forge.ModuleName` | `Forge.Bloatware`, `Forge.Core` |
| Directories | `Forge <Name>` | `Forge Core`, `Forge Module` |
| Parameters | PascalCase | `-ProfilePath`, `-Provider` |

### File Structure

- **One function per file** in `Public/` or `Private/`
- File name matches function name: `Set-ForgePrivacy.ps1`
- Public functions are exported; private functions are module-internal

### Function Template

```powershell
<#
.SYNOPSIS
    Brief description.
.DESCRIPTION
    Detailed description.
.PARAMETER ParamName
    Parameter description.
.EXAMPLE
    Example-Usage
#>
function Verb-ForgeNoun {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string]$ParamName
    )

    Write-ForgeLog -Message "Operation completed" -Level Success
}
```

### Rules

1. Always use `Write-ForgeLog` for output (never raw `Write-Host` except in CLI/UI)
2. Use `SupportsShouldProcess` on any function that modifies system state
3. Use `ConfirmImpact = 'High'` on irreversible operations
4. Validate registry paths via `Set-ForgeRegistry`
5. Include full comment-based help
6. Use `[OutputType()]` attribute on all functions

## Module Architecture

```
src/Forge Module/ModuleName/
├── Forge.ModuleName.psd1    # Module manifest
├── Forge.ModuleName.psm1    # Dot-source loader
├── Public/                  # Exported functions
│   ├── Get-ForgeThing.ps1
│   └── Set-ForgeThing.ps1
├── Private/                 # Internal helpers
│   └── Helper.ps1
└── Data/                    # Static data (JSON)
    └── config.json
```

## Testing

## Testing

```powershell
# Run full suite (Lint + Unit + Integration)
.\build\Test-Project.ps1

# Run specific scope
.\build\Test-Project.ps1 -Scope Lint
.\build\Test-Project.ps1 -Scope Unit
```

## Pull Request Process

1. Create a feature branch from `main`
2. Follow naming conventions (`Verb-ForgeNoun`, `Forge <Name>` dirs)
3. Add/update tests
4. Ensure `Invoke-Pester` passes
5. Update `CHANGELOG.md`
