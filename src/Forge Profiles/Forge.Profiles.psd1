@{
    RootModule        = 'Forge.Profiles.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'be158a6f-e55e-4035-bb83-cfaf5868564f'
    Author            = 'WinForge'
    Description       = 'Forge.Profiles — YAML configuration engine for WinForge'
    PowerShellVersion = '7.5'
    RequiredModules   = @()
    FunctionsToExport = @(
            'Get-ForgeRecommendedProfile',
            'Import-ForgeProfile',
            'Test-ForgeProfile'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('WinForge', 'Profiles', 'YAML', 'Configuration')
            ProjectUri = 'https://github.com/yourname/WinForge'
        }
    }
}
