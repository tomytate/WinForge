@{
    RootModule        = 'Forge.Privacy.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '2a1dbbca-a86a-49ff-af06-5d58d689ee83'
    Author            = 'WinForge'
    Description       = 'Forge.Privacy module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Add-ForgeHostsBlock',
            'Disable-ForgeTelemetryTasks',
            'Enable-ForgeTelemetryTasks',
            'Get-ForgeHostsStatus',
            'Get-ForgeTelemetryDomains',
            'Get-ForgeTelemetryTaskStatus',
            'Remove-ForgeHostsBlock',
            'Set-ForgePrivacy'
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
