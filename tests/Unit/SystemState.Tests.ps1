$sut = "$PSScriptRoot/../../src/Forge Core/Forge.Core.psd1"

# Mock Get-RegistryKey since it's used internally
function Get-RegistryKey { param($Path, $Name) return 1 }

Import-Module $sut -Force

Describe "SystemState Module" {
    InModuleScope "Forge.Core" {
        # Define stub inside module scope so it's visible
        function Get-ForgeRegistry { param($Path, $Name) return 1 }
        function Get-NetTCPConnection { return @(@{Count = 0 }) }
        
        Context "Get-ForgeSystemInfo" {
            
            It "Should return a state object with all expected properties" {
                # Mock internal dependency
                Mock Get-ForgeRegistry { return 1 }
                
                # Mock .NET/Cmdlet call
                Mock Get-NetTCPConnection { return @(1, 2, 3) }
                
                $state = Get-ForgeSystemInfo
                
                $state.Telemetry | Should -Not -BeNullOrEmpty
                $state.Copilot | Should -Not -BeNullOrEmpty
                $state.ActiveConnections | Should -Be 3
            }
        }
    }
}

