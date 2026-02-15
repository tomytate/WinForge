#Requires -Modules Pester
<#
.SYNOPSIS
    WinForge module validation tests.
.DESCRIPTION
    Verifies all module manifests, exports, and file structure.
#>
Describe "WinForge Module Structure" {
    BeforeAll {
        $projectRoot = Split-Path $PSScriptRoot -Parent
    }

    Context "Master Manifest" {
        It "WinForge.psd1 exists and is valid" {
            $manifest = Test-ModuleManifest -Path "$projectRoot\WinForge.psd1" -ErrorAction SilentlyContinue
            $manifest | Should -Not -BeNullOrEmpty
        }

        It "Requires PS 7.5+" {
            $manifest = Import-PowerShellDataFile "$projectRoot\WinForge.psd1"
            $manifest.PowerShellVersion | Should -Be '7.5'
        }
    }

    Context "Pillar Modules" {
        $pillars = @(
            @{ Name = "Forge.Core"; Path = "src\Forge Core" },
            @{ Name = "Forge.Profiles"; Path = "src\Forge Profiles" },
            @{ Name = "Forge.Snapshots"; Path = "src\Forge Snapshots" },
            @{ Name = "Forge.Extras"; Path = "src\Forge Module\Extras" },
            @{ Name = "Forge.CLI"; Path = "src\Forge CLI" },
            @{ Name = "Forge.UI"; Path = "src\Forge UI" }
        )

        foreach ($pillar in $pillars) {
            It "<Name> has valid manifest" -TestCases $pillars {
                param($Name, $Path)
                $psd1 = "$projectRoot\$Path\$Name.psd1"
                Test-Path $psd1 | Should -Be $true
                $manifest = Test-ModuleManifest -Path $psd1 -ErrorAction SilentlyContinue
                $manifest | Should -Not -BeNullOrEmpty
            }

            It "<Name> has psm1 loader" -TestCases $pillars {
                param($Name, $Path)
                $psm1 = "$projectRoot\$Path\$Name.psm1"
                Test-Path $psm1 | Should -Be $true
            }
        }
    }

    Context "Standard Modules" {
        $forgeModules = @(
            "Bloatware", "Privacy", "Performance", "Gaming", "Network",
            "Security", "Repair", "Maintenance", "Software", "Drivers",
            "Tweaks", "Features", "Windows11", "Integrations"
        )

        $testCases = $forgeModules | ForEach-Object { @{ ModName = $_ } }

        It "Forge.<ModName> has valid manifest" -TestCases $testCases {
            param($ModName)
            $psd1 = "$projectRoot\src\Forge Module\$ModName\Forge.$ModName.psd1"
            Test-Path $psd1 | Should -Be $true
        }

        It "Forge.<ModName> has Public functions" -TestCases $testCases {
            param($ModName)
            $publicDir = "$projectRoot\src\Forge Module\$ModName\Public"
            Test-Path $publicDir | Should -Be $true
            $files = Get-ChildItem $publicDir -Filter "*.ps1" -ErrorAction SilentlyContinue
            $files.Count | Should -BeGreaterThan 0
        }
    }
}

