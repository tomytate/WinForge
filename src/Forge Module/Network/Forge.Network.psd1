@{
    RootModule        = 'Forge.Network.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '42271687-47a4-469e-9f0a-c485c6dedc36'
    Author            = 'WinForge'
    Description       = 'Forge.Network module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Get-ForgeDNSProviders',
            'Get-ForgeNetworkStatus',
            'Set-ForgeDNS',
            'Set-ForgeIPv6'
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
