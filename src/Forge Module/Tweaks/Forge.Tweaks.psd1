@{
    RootModule        = 'Forge.Tweaks.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '4f0edb08-03bf-4783-804b-d330a18b214a'
    Author            = 'WinForge'
    Description       = 'Forge.Tweaks module for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Disable-ForgeAIRecall',
            'Disable-ForgeClickToDo',
            'Disable-ForgeCopilot',
            'Disable-ForgeDesktopSpotlight',
            'Disable-ForgeEdgeAI',
            'Disable-ForgeNotepadAI',
            'Disable-ForgePaintAI',
            'Disable-ForgeSettings365Ads',
            'Set-ForgeContextMenu',
            'Set-ForgeExplorer',
            'Set-ForgeStartMenu',
            'Set-ForgeTaskbar'
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
