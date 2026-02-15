
Describe "Integration: Safety Systems" {
    BeforeAll {
        $src = "$PSScriptRoot\..\src"
        Import-Module "$src\Forge Core\Forge.Core.psd1" -ErrorAction Stop
        Import-Module "$src\Forge Snapshots\Forge.Snapshots.psd1" -ErrorAction Stop
        
        # Setup Test Environment
        $TestPath = "HKCU:\Software\Forge_Test"
        if (Test-Path $TestPath) { Remove-Item $TestPath -Force -Recurse }
        New-Item -Path $TestPath -Force | Out-Null
        Set-ItemProperty -Path $TestPath -Name "SafetyCheck" -Value 1
    }

    AfterAll {
        # Cleanup ProgramData Snapshots
        $snapDir = "$env:ProgramData\WinForge\Snapshots"
        if (Test-Path $snapDir) { Remove-Item "$snapDir\TestSnapshot_*" -Force }
    }

    InModuleScope "Forge.Snapshots" {
        It "Should create a system snapshot" {
            # Mock heavy system calls
            Mock Checkpoint-Computer { } 
            Mock Enable-ComputerRestore { }
            Mock Get-Service { 
                return @(
                    [PSCustomObject]@{ Name = "DiagTrack"; Status = "Running"; StartType = "Automatic"; DisplayName = "Telemetry" },
                    [PSCustomObject]@{ Name = "Spooler"; Status = "Running"; StartType = "Automatic"; DisplayName = "Print Spooler" }
                ) 
            }

            $snap = New-ForgeSnapshot -Name "TestSnapshot"
            $snap | Should -Not -BeNullOrEmpty
            
            $snapFile = "$env:ProgramData\WinForge\Snapshots\$($snap.Id)\snapshot.clixml" 
            Test-Path $snapFile | Should -Be $true
        }
    }

    InModuleScope "Forge.Snapshots" {
        It "Should restore registry state from snapshot (AdvertisingInfo)" {
            $TestPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
            if (-not (Test-Path $TestPath)) { New-Item $TestPath -Force | Out-Null }
            
            # 0. Ensure known state
            Set-ItemProperty -Path $TestPath -Name "Enabled" -Value 0
            
            # 1. Take Snapshot (Captures Enabled=0)
            Mock Checkpoint-Computer { }
            Mock Enable-ComputerRestore { }
            Mock Get-Service { return @() }
            
            $snap = New-ForgeSnapshot -Name "PreRestoreParams"
            
            # 2. Modify State (Enabled=1)
            Set-ItemProperty -Path $TestPath -Name "Enabled" -Value 1
            (Get-ItemPropertyValue -Path $TestPath -Name "Enabled") | Should -Be 1
            
            # 3. Restore
            Restore-ForgeSnapshot -SnapshotId $snap.Id -Confirm:$false
            
            # 4. Verify Restoration (Should be 0)
            $val = Get-ItemPropertyValue -Path $TestPath -Name "Enabled"
            $val | Should -Be 0
        }
    }
}

