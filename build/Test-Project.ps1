#Requires -Version 7.5

<#
.SYNOPSIS
    Runs the comprehensive WinForge Test Suite (Linting + Unit/Integration Tests).

.DESCRIPTION
    1. Checks for required modules (Pester, PSScriptAnalyzer).
    2. Runs PSScriptAnalyzer on 'src/' (Static Analysis).
    3. Runs Pester on 'tests/' (Unit & Integration Tests).
    4. Returns exit code 0 on success, 1 on failure.

.PARAMETER Scope
    'All' (Default), 'Lint', 'Unit'.

.PARAMETER Fix
    Attempts to fix PSScriptAnalyzer issues where possible.

.EXAMPLE
    .\Test-Project.ps1
    .\Test-Project.ps1 -Scope Lint
#>
[CmdletBinding()]
param(
    [ValidateSet("All", "Lint", "Unit")]
    [string]$Scope = "All",
    
    [switch]$Fix
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
$PSNativeCommandArgumentPassing = 'Standard'
$Root = Resolve-Path "$PSScriptRoot\.."

Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      WinForge Test Suite                                     ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

# 1. Dependency Check
Write-Host "`n🔍 Checking Dependencies..." -ForegroundColor Gray
$deps = @("Pester", "PSScriptAnalyzer")
foreach ($dep in $deps) {
    if (-not (Get-Module -ListAvailable -Name $dep)) {
        Write-Warning "⚠️  Module '$dep' not found."
        if ($PSCmdlet.ShouldProcess("Module '$dep'", "Install from PSGallery")) {
            Install-Module $dep -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
        }
        else {
            Write-Error "Required module '$dep' is missing. Cannot proceed."
            exit 1
        }
    }
}
Import-Module Pester -ErrorAction Stop
Write-Host "✅ Dependencies requirements met." -ForegroundColor Green

# 2. Linting (PSScriptAnalyzer)
if ($Scope -in @("All", "Lint")) {
    Write-Host "`n🧹 Running PSScriptAnalyzer (Linting)..." -ForegroundColor Cyan
    
    $settingsFile = Join-Path $Root "PSScriptAnalyzerSettings.psd1"
    $lintPath = Join-Path $Root "src"
    
    # Import custom rules module for the session
    $customRuleMod = Join-Path $Root "tests\Rules\AvoidImplicitJsonDate.psm1"
    if (Test-Path $customRuleMod) { Import-Module $customRuleMod -Force }

    # Debug path
    Write-Host "Debug: CustomRulePath = '$customRuleMod'" -ForegroundColor DarkGray
    
    $saArgs = @{
        Path           = $lintPath
        Recurse        = $true
        Settings       = $settingsFile
        CustomRulePath = $customRuleMod # Point to file directly
    }
    
    if ($Fix) {
        Invoke-ScriptAnalyzer @saArgs -Fix
        Write-Host "✨ Auto-fix applied." -ForegroundColor Green
    }
    
    $lintResults = Invoke-ScriptAnalyzer @saArgs
    
    if ($lintResults) {
        Write-Host "⚠️  Linting Issues Found:" -ForegroundColor Yellow
        $lintResults | Format-Table -Property RuleName, Severity, ScriptName, Line, Message -AutoSize
        
        # Fail build on Errors?
        if ($lintResults | Where-Object { $_.Severity -eq "Error" }) {
            Write-Host "❌ Linting failed with Errors." -ForegroundColor Red
            if ($Scope -eq "Lint") { exit 1 }
        }
    }
    else {
        Write-Host "✅ Linting Passed: Clean Code naming & style." -ForegroundColor Green
    }
}

# 3. Unit Tests (Pester)
if ($Scope -in @("All", "Unit")) {
    Write-Host "`n🧪 Running Pester Tests..." -ForegroundColor Cyan
    
    $testPath = Join-Path $Root "tests"
    $srcPath = Join-Path $Root "src"
    
    $config = [PesterConfiguration]::Default
    $config.Run.Path = $testPath
    $config.Run.ExcludePath = Join-Path $testPath "Pester-*" # Exclude internal Pester tests
    $config.Run.PassThru = $true
    $config.Output.Verbosity = "Detailed"
    
    # Code Coverage
    $config.CodeCoverage.Enabled = $true
    $config.CodeCoverage.Path = $srcPath
    $config.CodeCoverage.OutputFormat = "JaCoCo"
    $config.CodeCoverage.OutputPath = "$Root\test-coverage.xml"
    $config.CodeCoverage.OutputEncoding = "UTF8"

    # Run
    $result = Invoke-Pester -Configuration $config
    
    Write-Host "`n================================" -ForegroundColor Cyan
    Write-Host "TEST SUMMARY" -ForegroundColor Cyan
    Write-Host "Passed: $($result.PassedCount)" -ForegroundColor Green
    Write-Host "Failed: $($result.FailedCount)" -ForegroundColor $(if ($result.FailedCount -gt 0) { "Red" } else { "Green" })
    Write-Host "Total:  $($result.TotalCount)"
    
    # Calculate coverage manually for display
    # (Pester 5+ object structure needed)
    
    if ($result.FailedCount -gt 0) {
        Write-Host "`n❌ Tests Failed." -ForegroundColor Red
        exit 1
    }
    else {
        Write-Host "`n✅ All Tests Passed." -ForegroundColor Green
    }
}

exit 0
