@{
    RootModule        = 'Forge.Software.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '41a1367d-6047-45e8-84af-0a9d5313ab23'
    Author            = 'WinForge'
    Description       = 'Forge.Software module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Install-ForgeEssentials',
            'Install-ForgeSoftware',
            'Update-ForgeSoftware'
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
