#Requires -Modules Pester
Describe "WinForge Syntax Validation" {

    $projectRoot = Split-Path $PSScriptRoot -Parent
    $allPs1 = Get-ChildItem -Path "$projectRoot\src" -Recurse -Filter "*.ps1"

    foreach ($item in $allPs1) {
        It "$($item.Name) has valid PowerShell syntax" -TestCases @{ File = $item } {
            param($File)
            $errors = $null
            [System.Management.Automation.Language.Parser]::ParseFile(
                $File.FullName, [ref]$null, [ref]$errors
            )
            if ($errors.Count -gt 0) {
                Write-Host "Parser Errors in $($File.Name):" -ForegroundColor Red
                $errors | ForEach-Object { Write-Host "  - $($_.Message) at Line $($_.Extent.StartLineNumber)" }
            }
            $errors.Count | Should -Be 0
        }
    }
}

