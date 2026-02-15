@{
    RootModule        = 'Forge.Features.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '67e0dc09-bb12-48a2-9795-e2c5303f448f'
    Author            = 'WinForge'
    Description       = 'Forge.Features module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Remove-ForgeCapabilities',
            'Set-ForgeOptionalFeatures'
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
