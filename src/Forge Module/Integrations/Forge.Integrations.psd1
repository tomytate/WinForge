@{
    RootModule        = 'Forge.Integrations.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '6316614d-53c4-45eb-b2cd-389713a20c2a'
    Author            = 'WinForge'
    Description       = 'Forge.Integrations module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Invoke-ForgeAdwCleaner',
            'Invoke-ForgeShutUp10',
            'Update-ForgeSDIO'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('WinForge', 'Windows', 'Optimization')
            ProjectUri = 'https://github.com/yourname/WinForge'
        }
    }
}
