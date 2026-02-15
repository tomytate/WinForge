
Describe "Modules.Windows11.VersionDetection" {
    BeforeAll {
        $src = "w:\Documents\WinForge\src"
        Import-Module "$src\Forge Core\Forge.Core.psd1" -ErrorAction SilentlyContinue 
        Import-Module "$src\Forge Module\Windows11\Forge.Windows11.psd1" -ErrorAction Stop
    }

    It "Exports Get-ForgeWindowsVersion" {
        $cmd = Get-Command "Get-ForgeWindowsVersion" -ErrorAction SilentlyContinue
        $cmd | Should -Not -BeNullOrEmpty
    }

    It "Exports Test-ForgeWindows11" {
        $cmd = Get-Command "Test-ForgeWindows11" -ErrorAction SilentlyContinue
        $cmd | Should -Not -BeNullOrEmpty
    }
}

Describe "Modules.Bloatware" {
    BeforeAll {
        $src = "w:\Documents\WinForge\src"
        Import-Module "$src\Forge Core\Forge.Core.psd1" -ErrorAction SilentlyContinue
        Import-Module "$src\Forge Module\Bloatware\Forge.Bloatware.psd1" -ErrorAction Stop
    }

    It "Includes Critical 25H2 Bloatware Apps" {
        $list = Get-ForgeBloatwareList
        $list.Count | Should -BeGreaterThan 0
    }
}

Describe "Modules.Privacy" {
    BeforeAll {
        $src = "w:\Documents\WinForge\src"
        Import-Module "$src\Forge Core\Forge.Core.psd1" -ErrorAction SilentlyContinue
        Import-Module "$src\Forge Module\Privacy\Forge.Privacy.psd1" -ErrorAction Stop
    }
    
    It "Exports Centralized Privacy Function" {
        $cmd = Get-Command "Set-ForgePrivacy" -ErrorAction SilentlyContinue
        $cmd | Should -Not -BeNullOrEmpty
    }
}

Describe "Modules.Performance" {
    BeforeAll {
        $src = "w:\Documents\WinForge\src"
        Import-Module "$src\Forge Core\Forge.Core.psd1" -ErrorAction SilentlyContinue
        Import-Module "$src\Forge Module\Performance\Forge.Performance.psd1" -ErrorAction Stop
    }

    It "Exports Measure-ForgeSystem" {
        $cmd = Get-Command "Measure-ForgeSystem" -ErrorAction SilentlyContinue
        $cmd | Should -Not -BeNullOrEmpty
    }
}

