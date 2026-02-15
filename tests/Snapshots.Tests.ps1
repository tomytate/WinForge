Describe "Forge.Snapshots Module" {
    BeforeAll {
        $projectRoot = Split-Path $PSScriptRoot -Parent
    }

    Context "Snapshots Functions Exist" {
        $functions = @("New-ForgeSnapshot", "Restore-ForgeSnapshot", "Get-ForgeSnapshot", "Remove-ForgeSnapshot")
        $cases = $functions | ForEach-Object { @{ FunctionName = $_ } }

        It "<FunctionName>.ps1 exists" -TestCases $cases {
            param($FunctionName)
            Test-Path "$projectRoot\src\Forge Snapshots\Public\$FunctionName.ps1" | Should -Be $true
        }
    }
}

