@{
    RootModule        = 'Forge.CLI.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '24d3fc2f-d626-4d52-bf44-fc8b9d7e3b41'
    Author            = 'WinForge'
    Description       = 'Forge.CLI module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Show-ForgeHeader',
            'Show-ForgeMenu',
            'Write-ForgeHost'
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
