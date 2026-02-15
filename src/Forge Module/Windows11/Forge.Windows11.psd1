@{
    RootModule        = 'Forge.Windows11.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '6ee3b8ab-ecb7-4227-a2a9-92719ef78a47'
    Author            = 'WinForge'
    Description       = 'Forge.Windows11 module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Get-ForgeWindowsVersion',
            'Test-ForgeWindows11'
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
