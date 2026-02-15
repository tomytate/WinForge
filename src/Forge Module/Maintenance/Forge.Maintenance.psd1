@{
    RootModule        = 'Forge.Maintenance.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '1719c4c2-b350-4294-ad74-f0e5cebfc622'
    Author            = 'WinForge'
    Description       = 'Forge.Maintenance module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Invoke-ForgeMaintenance',
            'Register-ForgeMaintenance'
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
