# Security Policy

## Reporting a Vulnerability

1. **DO NOT** create a public GitHub issue
2. Email the maintainer directly or use GitHub's private vulnerability reporting
3. Include a detailed description and steps to reproduce

## Security Model

### Registry Operations (SEC-001)
All registry writes go through `Forge Core` → `Set-ForgeRegistry` / `Set-ForgeRegistryValue` which validate ACLs before modification. Operations that fail ACL checks are logged and skipped.

### Snapshot Encryption (SEC-002)
`Forge Snapshots` encrypts system state via Windows DPAPI (`ProtectedData`) using `CurrentUser` scope — only the creating user can restore.

### User Consent (SEC-003)
- `Forge Module/Extras/` operations (Defender Remover, MAS) require explicit `YES` confirmation
- All destructive operations support `-WhatIf` and `-Confirm` via `SupportsShouldProcess`
- High-impact functions use `ConfirmImpact = 'High'`

### Network Isolation (SEC-004)
- **Standard edition**: Makes zero outbound network requests
- **Extras edition**: Only connects to GitHub for Defender Remover and MAS
- `Forge Module/Integrations/` tools require explicit invocation

### Logging (SEC-005)
All operations logged by `Forge Core` → `Write-ForgeLog` to `$env:ProgramData\WinForge\*.log`. Log rotation at 10MB. No sensitive data is ever logged.

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.0.x   | ✅ Active |

## Dependencies

| Dependency | Version | Location | Purpose |
|------------|---------|----------|---------|
| PowerShell | 7.5+ | Runtime | Core runtime |
| powershell-yaml | 0.4.12 | `src/Forge Profiles/Vendor/` | YAML parsing (vendored) |
