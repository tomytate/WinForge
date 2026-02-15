@{
    RootModule        = 'Forge.Security.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'e7778c72-b3ab-483b-bee8-0806cf1de0d4'
    Author            = 'WinForge'
    Description       = 'Forge.Security module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Disable-ForgeSMBv1',
            'Enable-ForgePUAProtection'
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
