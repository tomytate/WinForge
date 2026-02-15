@{
    RootModule        = 'Forge.Bloatware.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'd9eade80-7a34-4979-a530-61ff6fb73b97'
    Author            = 'WinForge'
    Description       = 'Forge.Bloatware module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Disable-ForgeAI',
            'Get-ForgeBloatwareList',
            'Remove-ForgeBloatware',
            'Remove-ForgeEdge',
            'Remove-ForgeOneDrive',
            'Remove-ForgeXbox'
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
