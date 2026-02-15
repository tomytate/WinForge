$repair = "$PSScriptRoot/../../src/Forge Module/Repair/Forge.Repair.psd1"
$features = "$PSScriptRoot/../../src/Forge Module/Features/Forge.Features.psd1"
$security = "$PSScriptRoot/../../src/Forge Module/Security/Forge.Security.psd1"

# Mock Logs
function Write-Log { param($Message, $Level) }

Import-Module $repair -Force
Import-Module $features -Force
Import-Module $security -Force

# Stub missing cmdlets for test environment if needed
if (-not (Get-Command Set-MpPreference -ErrorAction SilentlyContinue)) { function global:Set-MpPreference { } }
if (-not (Get-Command Get-WindowsOptionalFeature -ErrorAction SilentlyContinue)) { function global:Get-WindowsOptionalFeature { } }
if (-not (Get-Command Disable-WindowsOptionalFeature -ErrorAction SilentlyContinue)) { function global:Disable-WindowsOptionalFeature { } }
if (-not (Get-Command Enable-WindowsOptionalFeature -ErrorAction SilentlyContinue)) { function global:Enable-WindowsOptionalFeature { } }

Describe "System Integration Tests" {
    
    Context "Repair Module" {
        InModuleScope "Forge.Repair" {
            It "Reset-ForgeNetwork should invoke netsh commands" {
                Mock netsh {}
                Mock ipconfig {}
                Reset-ForgeNetwork
                Assert-MockCalled netsh -Times 3
                Assert-MockCalled ipconfig -Times 3
            }
        }
    }

    Context "Features Module" {
        InModuleScope "Forge.Features" {
            It "Set-ForgeOptionalFeatures should disable features" {
                Mock Get-WindowsOptionalFeature { return [PSCustomObject]@{ State = "Enabled"; FeatureName = $FeatureName } }
                Mock Disable-WindowsOptionalFeature { } -Verifiable
                
                Set-ForgeOptionalFeatures -Features @("FaxServicesClientPackage") -Confirm:$false
                
                Assert-MockCalled Disable-WindowsOptionalFeature
            }
        }
    }
    
    Context "Security Module" {
        InModuleScope "Forge.Security" {
            It "Enable-ForgePUAProtection should call Set-MpPreference" {
                Mock Set-MpPreference { } -Verifiable
            
                Enable-ForgePUAProtection -Confirm:$false
            
                Assert-MockCalled Set-MpPreference
            }
        }
    }
}
