$sut = "$PSScriptRoot/../../src/Forge Profiles/Forge.Profiles.psd1"
Import-Module $sut -Force

Describe "Config Module" {
    
    InModuleScope "Forge.Profiles" {
    
        Context "Get-ForgeRecommendedProfile" {
            
            It "Should recommend Performance for < 8GB RAM" {
                # Mock calls specifically
                Mock Get-CimInstance -ParameterFilter { $ClassName -eq 'Win32_ComputerSystem' } -MockWith { 
                    [pscustomobject]@{ TotalPhysicalMemory = 4GB } 
                }
                Mock Get-CimInstance -ParameterFilter { $ClassName -eq 'Win32_VideoController' } -MockWith { $null }
                
                $result = Get-ForgeRecommendedProfile
                $result | Should -Be "aggressive"
            }
            
            It "Should recommend Gaming for >= 16GB RAM + High End GPU" {
                Mock Get-CimInstance -ParameterFilter { $ClassName -eq 'Win32_ComputerSystem' } -MockWith { 
                    [pscustomobject]@{ TotalPhysicalMemory = 32GB } 
                }
                Mock Get-CimInstance -ParameterFilter { $ClassName -eq 'Win32_VideoController' } -MockWith { 
                    @([pscustomobject]@{ Name = "NVIDIA GeForce RTX 4090" }) 
                }
                
                $result = Get-ForgeRecommendedProfile
                $result | Should -Be "gaming"
            }
            
            It "Should recommend Moderate for >= 8GB RAM but no dedicated GPU" {
                Mock Get-CimInstance -ParameterFilter { $ClassName -eq 'Win32_ComputerSystem' } -MockWith { 
                    [pscustomobject]@{ TotalPhysicalMemory = 16GB } 
                }
                Mock Get-CimInstance -ParameterFilter { $ClassName -eq 'Win32_VideoController' } -MockWith { 
                    @([pscustomobject]@{ Name = "Intel UHD Graphics" }) 
                }
                
                $result = Get-ForgeRecommendedProfile
                $result | Should -Be "balanced"
            }
        }
    }
}

