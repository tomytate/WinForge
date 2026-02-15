@{
    RootModule        = 'Forge.Snapshots.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'f91f3c09-5962-47d4-98f2-169c79c1062d'
    Author            = 'WinForge'
    Description       = 'Forge.Snapshots — DPAPI-encrypted system state snapshots for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Get-ForgeSnapshot',
            'New-ForgeSnapshot',
            'Remove-ForgeSnapshot',
            'Restore-ForgeSnapshot'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('WinForge', 'Snapshots', 'DPAPI', 'Backup')
            ProjectUri = 'https://github.com/yourname/WinForge'
        }
    }
}
