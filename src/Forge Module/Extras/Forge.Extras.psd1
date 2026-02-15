@{
    RootModule        = 'Forge.Extras.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '63106d99-efd3-4052-a146-19a64e7fc0c5'
    Author            = 'WinForge'
    Description       = 'Forge.Extras module for WinForge'
    PowerShellVersion = '7.5'
    
    FunctionsToExport = @(
        'Invoke-ForgeDefenderRemover',
        'Enable-ForgeWindowsActivation',
        'Set-ForgeWindowsEdition',
        'Get-ForgeActivationStatus',
        'Repair-ForgeActivation'
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
