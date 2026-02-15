# Troubleshooting

## Common Issues

### PowerShell Version
WinForge requires PowerShell 7.5+. Check your version:
```powershell
$PSVersionTable.PSVersion
```

### Administrator Privileges
Most operations require elevation. Right-click PowerShell and select **Run as Administrator**.

### Module Not Found
If functions are not available, import manually:
```powershell
Import-Module .\WinForge.psd1 -Force
```

### Snapshot Restore Fails
Snapshots in `src/Forge Snapshots/` use DPAPI with `CurrentUser` scope. They can only be restored by the same user account that created them.

### Profile Validation Errors
Validate before applying:
```powershell
Test-ForgeProfile -Path '.\src\Forge Profiles\Presets\balanced.yaml' -Verbose
```

### Paths with Spaces
The `Forge <Name>` directories contain spaces. When using them in shell commands, wrap paths in quotes:
```powershell
Import-Module '.\src\Forge Core\Forge.Core.psd1'
```

## Getting Help

```powershell
# Get help for any function
Get-Help Set-ForgePrivacy -Full

# List all WinForge commands
Get-Command -Module Forge.*

# Preview changes without applying
Set-ForgePrivacy -All -WhatIf
```
