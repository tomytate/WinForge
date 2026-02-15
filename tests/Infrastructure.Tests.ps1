$projectRoot = Resolve-Path "$PSScriptRoot\.."

Describe "Infrastructure & Quality" {
    
    Context "Module Manifests" {
        $manifests = Get-ChildItem -Path "$projectRoot\src" -Recurse -Filter "*.psd1" | Where-Object { $_.FullName -notmatch "Vendor" }

        It "Should require PowerShell 7.5" -TestCases ($manifests | ForEach-Object { @{ File = $_.FullName } }) {
            param($File)
            $m = Import-PowerShellDataFile $File
            $m.PowerShellVersion | Should -Be "7.5"
        }

        It "Should have a description" -TestCases ($manifests | ForEach-Object { @{ File = $_.FullName } }) {
            param($File)
            $m = Import-PowerShellDataFile $File
            $m.Description | Should -Not -BeNullOrEmpty
        }
    }

    Context "Function Documentation" {
        $functions = Get-ChildItem -Path "$projectRoot\src" -Recurse -Filter "*.ps1" | 
        Where-Object { $_.FullName -notmatch "Tests" -and $_.FullName -notmatch "Vendor" }

        It "Should have .SYNOPSIS" -TestCases ($functions | ForEach-Object { @{ File = $_.FullName } }) {
            param($File)
            $content = Get-Content $File -Raw
            $content | Should -Match "\.SYNOPSIS"
        }
    }
}
