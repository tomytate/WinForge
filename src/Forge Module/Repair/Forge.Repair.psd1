@{
    RootModule        = 'Forge.Repair.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'cdd0f58f-ebef-4865-982a-491e1142374a'
    Author            = 'WinForge'
    Description       = 'Forge.Repair module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Repair-ForgeSystem',
            'Reset-ForgeNetwork',
            'Reset-ForgeUpdate'
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
