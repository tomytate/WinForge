@{
    RootModule        = 'Forge.Drivers.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'f43bfd80-ec84-4545-9f7e-0cf76ea8cefa'
    Author            = 'WinForge'
    Description       = 'Forge.Drivers module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Get-ForgeDriverStatus',
            'Get-ForgeGPUInfo',
            'Update-ForgeDrivers'
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
