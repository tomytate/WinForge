$projectRoot = Split-Path $PSScriptRoot -Parent

Describe "Forge.Core Module" {
    BeforeAll {
        $projectRoot = Split-Path $PSScriptRoot -Parent
        Write-Host "DEBUG: projectRoot='$projectRoot'"
    }

    Context "Core Manifest" {
        It "Has correct exported functions" {
            $manifest = Import-PowerShellDataFile "$projectRoot\src\Forge Core\Forge.Core.psd1"
            $manifest.FunctionsToExport | Should -Contain 'Write-ForgeLog'
            $manifest.FunctionsToExport | Should -Contain 'Set-ForgeRegistry'
            $manifest.FunctionsToExport | Should -Contain 'Start-ForgeLogging'
            $manifest.FunctionsToExport | Should -Contain 'Get-ForgeSystemInfo'
        }
    }

    Context "Public Functions Exist" {
        $publicFunctions = @(
            "Start-ForgeLogging", "Write-ForgeLog", "Get-ForgeLogPath",
            "Set-ForgeRegistry", "Get-ForgeRegistry", "Test-ForgeRegistry", "Export-ForgeRegistry",
            "Get-ForgeSystemInfo", "Invoke-ForgeSysprepDefaults"
        )
        $publicCases = $publicFunctions | ForEach-Object { @{ FunctionName = $_ } }

        It "<FunctionName>.ps1 exists" -TestCases $publicCases {
            param($FunctionName)
            $path = "$projectRoot\src\Forge Core\Public\$FunctionName.ps1"
            Test-Path $path | Should -Be $true
        }
    }

    Context "Private Functions Exist" {
        $privateFunctions = @(
            "Test-ForgeAuditMode", "Mount-ForgeDefaultHive", "Dismount-ForgeDefaultHive",
            "Set-ForgeRegistryValue", "Test-ForgeElevation", "Format-ForgeOutput"
        )
        $privateCases = $privateFunctions | ForEach-Object { @{ FunctionName = $_ } }

        It "<FunctionName>.ps1 exists" -TestCases $privateCases {
            param($FunctionName)
            $path = "$projectRoot\src\Forge Core\Private\$FunctionName.ps1"
            Test-Path $path | Should -Be $true
        }
    }
}

