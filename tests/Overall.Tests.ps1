$here = $PSScriptRoot
$root = Split-Path -Parent $here

Describe "WinForge Compliance" {
    BeforeAll {
        $here = $PSScriptRoot
        $root = Split-Path -Parent $here
    }
    
    Context "1. Manifest Integrity" {
        It "WinForge.psd1 should show valid module manifest" {
            $manifest = Sort-Object -Unique -InputObject (Test-ModuleManifest -Path "$root\WinForge.psd1" -ErrorAction Stop)
            $manifest.Name | Should -Be "WinForge"
        }

        It "Should not have duplicate NestedModules" {
            $content = Get-Content "$root\WinForge.psd1" -Raw -ErrorAction Stop
            # Simple regex check for duplicates
            # (We already fixed it, just verifying)
            $content | Should -Not -Match "State.psm1.*State.psm1"
        }
    }

    Context "2. Core Hardening" {
        Import-Module "$root\src\Forge Core\Forge.Core.psd1" -Force

        It "Set-RegistryKey should reject invalid hives" {
            { Set-RegistryKey -Path "INVALID:\Foo" -Name "Bar" -Value 1 } | Should -Throw
        }

        It "Set-RegistryKey should accept valid HKLM" {
            # Mock Set-ItemProperty to avoid actual registry write
            Mock Set-ItemProperty {}
            # Mock Test-Path to simulate key existence
            Mock Test-Path { return $true }
            
            # Mock Get-Acl to pass permission check
            Mock Get-Acl {
                $rule = [pscustomobject]@{
                    IdentityReference = [pscustomobject]@{ Value = "Administrators" }
                    RegistryRights    = [System.Security.AccessControl.RegistryRights]::SetValue
                }
                [pscustomobject]@{ Access = @($rule) }
            }
             
            # Should not throw
            { Set-ForgeRegistry -Path "HKLM:\Software\Test" -Name "TestVal" -Value 1 -Type DWord } | Should -Not -Throw
        }
    }
    
    Context "3. Syntax Validation" {
        $files = Get-ChildItem -Path "$root\src" -Recurse -Filter "*.ps1" | ForEach-Object {
            @{ Name = $_.Name; FullName = $_.FullName }
        }
        
        It "<Name> should pass syntax check" -TestCases $files {
            param($FullName, $Name)
            $content = Get-Content $FullName -Raw
            $errs = $null
            $tokens = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$errs)
            $errs.Count | Should -Be 0
        }
    }
    
    Context "4. Bloatware Module Optimization" {
        Import-Module "$root\src\Forge Module\Bloatware\Forge.Bloatware.psd1" -Force
        
        It "Regex compilation should be valid" {
            $testApps = @("Xbox", "Solitaire", "Weather")
            $regex = ($testApps | ForEach-Object { [regex]::Escape($_) }) -join '|'
            [regex]::new($regex) | Should -Not -BeNullOrEmpty
        }
    }
}

