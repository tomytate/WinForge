@{
    RootModule        = 'WinForge.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'fce55c7e-9f63-4028-806d-bf76809153f5'
    Author            = 'WinForge'
    CompanyName       = 'WinForge'
    Copyright         = '(c) 2026 WinForge. MIT License.'
    Description       = 'WinForge - The Windows Forge. Debloat, Harden, Optimize Windows 10/11.'
    # PowerShell version required for this module
    PowerShellVersion = '7.5'

    NestedModules     = @(
        'src/Forge Core/Forge.Core.psd1',
        'src/Forge Module/Bloatware/Forge.Bloatware.psd1',
        'src/Forge Module/Privacy/Forge.Privacy.psd1',
        'src/Forge Module/Performance/Forge.Performance.psd1',
        'src/Forge Module/Windows11/Forge.Windows11.psd1',
        'src/Forge Module/Software/Forge.Software.psd1',
        'src/Forge Module/Drivers/Forge.Drivers.psd1',
        'src/Forge Module/Network/Forge.Network.psd1',
        'src/Forge Module/Maintenance/Forge.Maintenance.psd1',
        'src/Forge Module/Tweaks/Forge.Tweaks.psd1',
        'src/Forge Module/Repair/Forge.Repair.psd1',
        'src/Forge Module/Features/Forge.Features.psd1',
        'src/Forge Module/Security/Forge.Security.psd1',
        'src/Forge Module/Extras/Forge.Extras.psd1',
        'src/Forge Module/Integrations/Forge.Integrations.psd1',
        'src/Forge Module/Gaming/Forge.Gaming.psd1',
        'src/Forge Profiles/Forge.Profiles.psd1',
        'src/Forge Snapshots/Forge.Snapshots.psd1',
        'src/Forge CLI/Forge.CLI.psd1',
        'src/Forge UI/Forge.UI.psd1'
    )

    FunctionsToExport = @(
        'Export-ForgeRegistry',
        'Get-ForgeLogPath',
        'Get-ForgeRegistry',
        'Get-ForgeSystemInfo',
        'Invoke-ForgeSysprepDefaults',
        'Set-ForgeRegistry',
        'Start-ForgeLogging',
        'Test-ForgeRegistry',
        'Write-ForgeLog',
        'Disable-ForgeAI',
        'Get-ForgeBloatwareList',
        'Remove-ForgeBloatware',
        'Remove-ForgeEdge',
        'Remove-ForgeOneDrive',
        'Remove-ForgeXbox',
        'Add-ForgeHostsBlock',
        'Disable-ForgeTelemetryTasks',
        'Enable-ForgeTelemetryTasks',
        'Get-ForgeHostsStatus',
        'Get-ForgeTelemetryDomains',
        'Get-ForgeTelemetryTaskStatus',
        'Remove-ForgeHostsBlock',
        'Set-ForgePrivacy',
        'Compare-ForgeBenchmarks',
        'Disable-ForgeUltimatePower',
        'Enable-ForgeUltimatePower',
        'Get-ForgeServicePresets',
        'Measure-ForgeSystem',
        'Set-ForgePerformance',
        'Set-ForgeServices',
        'Get-ForgeWindowsVersion',
        'Test-ForgeWindows11',
        'Install-ForgeEssentials',
        'Install-ForgeSoftware',
        'Update-ForgeSoftware',
        'Get-ForgeDriverStatus',
        'Get-ForgeGPUInfo',
        'Update-ForgeDrivers',
        'Get-ForgeDNSProviders',
        'Get-ForgeNetworkStatus',
        'Set-ForgeDNS',
        'Set-ForgeIPv6',
        'Invoke-ForgeMaintenance',
        'Register-ForgeMaintenance',
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
        'Set-ForgeTaskbar',
        'Repair-ForgeSystem',
        'Reset-ForgeNetwork',
        'Reset-ForgeUpdate',
        'Remove-ForgeCapabilities',
        'Set-ForgeOptionalFeatures',
        'Disable-ForgeSMBv1',
        'Enable-ForgePUAProtection',
        'Invoke-ForgeActivation',
        'Invoke-ForgeDefenderRemover',
        'Invoke-ForgeAdwCleaner',
        'Invoke-ForgeShutUp10',
        'Update-ForgeSDIO',
        'Disable-ForgeGameDVR',
        'Set-ForgeGaming',
        'Set-ForgeGPUPriority',
        'Get-ForgeRecommendedProfile',
        'Import-ForgeProfile',
        'Test-ForgeProfile',
        'Get-ForgeSnapshot',
        'New-ForgeSnapshot',
        'Remove-ForgeSnapshot',
        'Restore-ForgeSnapshot',
        'Show-ForgeHeader',
        'Show-ForgeMenu',
        'Write-ForgeHost',
        'Show-ForgeUI'
    )

    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    PrivateData       = @{
        PSData = @{
            Tags         = @('WinForge', 'Windows', 'Debloat', 'Privacy', 'Performance', 'Optimization')
            LicenseUri   = 'https://github.com/tomytate/WinForge/blob/main/LICENSE'
            ProjectUri   = 'https://github.com/tomytate/WinForge'
            ReleaseNotes = 'v1.0.0 - Complete WinForge build. 20 modules, 82+ functions.'
        }
    }
}
