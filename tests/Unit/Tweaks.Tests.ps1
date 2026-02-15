$sut = "$PSScriptRoot/../../src/Forge Module/Tweaks/Forge.Tweaks.psd1"
Import-Module $sut -Force

Describe "Tweaks Module" {
    InModuleScope "Forge.Tweaks" {
        # Stub inside module scope
        function Set-RegistryKey { param($Path, $Name, $Value, $Type) return $true }
        
        Context "Set-ForgeTaskbar" {
            It "Should set alignment to Left (0)" {
                Mock Set-ForgeRegistry { return $true } -Verifiable -ParameterFilter { 
                    $Name -eq "TaskbarAl" -and 
                    $Value -eq 0 
                }
                
                Set-ForgeTaskbar -Alignment Left
                Assert-MockCalled Set-ForgeRegistry
            }
            
            It "Should set alignment to Center (1)" {
                Mock Set-ForgeRegistry { return $true } -Verifiable -ParameterFilter { 
                    $Value -eq 1 
                }
                Set-ForgeTaskbar -Alignment Center
                Assert-MockCalled Set-ForgeRegistry
            }
        }
        
        Context "Set-ForgeStartMenu" {
            It "Should disable recommended section" {
                Mock Set-ForgeRegistry { return $true } -Verifiable -ParameterFilter {
                    $Path -eq "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -and
                    $Name -eq "HideRecommendedSection" -and
                    $Value -eq 1
                }
                
                Set-ForgeStartMenu -DisableRecommended
                Assert-MockCalled Set-ForgeRegistry
            }
        }
    }
}

