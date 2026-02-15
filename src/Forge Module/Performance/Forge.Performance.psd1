@{
    RootModule        = 'Forge.Performance.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'b85c9b88-897b-4cd4-9956-5f03d05cb39e'
    Author            = 'WinForge'
    Description       = 'Forge.Performance module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Compare-ForgeBenchmarks',
            'Disable-ForgeUltimatePower',
            'Enable-ForgeUltimatePower',
            'Get-ForgeServicePresets',
            'Measure-ForgeSystem',
            'Set-ForgePerformance',
            'Set-ForgeServices'
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
