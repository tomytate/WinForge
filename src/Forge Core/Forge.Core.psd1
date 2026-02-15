@{
    RootModule        = 'Forge.Core.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'efaad5e2-c72b-4e4c-b92d-e1aff241f1bc'
    Author            = 'WinForge'
    Description       = 'Forge.Core — Logging, Registry, System Info, Sysprep for WinForge'
    PowerShellVersion = '7.5'
    FunctionsToExport = @(
            'Export-ForgeRegistry',
            'Get-ForgeLogPath',
            'Get-ForgeRegistry',
            'Get-ForgeSystemInfo',
            'Invoke-ForgeSysprepDefaults',
            'Set-ForgeRegistry',
            'Start-ForgeLogging',
            'Test-ForgeRegistry',
            'Write-ForgeLog'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('WinForge', 'Core', 'Logging', 'Registry')
            ProjectUri = 'https://github.com/yourname/WinForge'
        }
    }
}
