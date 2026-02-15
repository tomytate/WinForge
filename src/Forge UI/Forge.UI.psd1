@{
    RootModule        = 'Forge.UI.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'f289b3fb-1199-4a00-bf2d-deb8e44f463f'
    Author            = 'WinForge'
    Description       = 'Forge.UI — WPF graphical interface for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Show-ForgeGUI'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('WinForge', 'GUI', 'WPF', 'UI')
            ProjectUri = 'https://github.com/yourname/WinForge'
        }
    }
}
