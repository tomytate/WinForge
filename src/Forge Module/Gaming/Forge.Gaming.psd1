@{
    RootModule        = 'Forge.Gaming.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'ef83f342-dbb4-4722-99cd-1969ecaf35e9'
    Author            = 'WinForge'
    Description       = 'Forge.Gaming module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Disable-ForgeGameDVR',
            'Set-ForgeGaming',
            'Set-ForgeGPUPriority'
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
