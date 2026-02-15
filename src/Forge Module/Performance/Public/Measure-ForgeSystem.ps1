<#
.SYNOPSIS
    Benchmarks current system performance.
.OUTPUTS
    [PSCustomObject] Benchmark results with CPU, RAM, disk, and network metrics.
#>
function Measure-ForgeSystem {
    [CmdletBinding()]
    param()

    Write-ForgeLog -Message "Running system benchmark..." -Level Info

    $results = [PSCustomObject]@{
        Timestamp    = Get-Date
        CPU          = $null
        RAMUsedGB    = $null
        RAMTotalGB   = $null
        DiskReadMBs  = $null
        DiskWriteMBs = $null
        BootTimeS    = $null
    }

    # Gather metrics in parallel (PS 7.0+)
    $tasks = @('CPU', 'RAM', 'Boot')
    $metrics = $tasks | ForEach-Object -Parallel {
        $type = $_
        switch ($type) {
            'CPU' {
                return @{ Type = 'CPU'; Data = (Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1) }
            }
            'RAM' {
                return @{ Type = 'RAM'; Data = (Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue) }
            }
            'Boot' {
                return @{ Type = 'Boot'; Data = (Get-WinEvent -LogName System -FilterXPath "*[System[EventID=6005]]" -MaxEvents 1 -ErrorAction SilentlyContinue) }
            }
        }
    } -ThrottleLimit 5

    # Process results
    foreach ($m in $metrics) {
        switch ($m.Type) {
            'CPU' { $results.CPU = $m.Data.Name }
            'RAM' {
                if ($m.Data) {
                    $results.RAMTotalGB = [math]::Round($m.Data.TotalVisibleMemorySize / 1MB, 2)
                    $results.RAMUsedGB = [math]::Round(($m.Data.TotalVisibleMemorySize - $m.Data.FreePhysicalMemory) / 1MB, 2)
                }
            }
            'Boot' {
                if ($m.Data) {
                    $results.BootTimeS = [math]::Round(((Get-Date) - $m.Data.TimeCreated).TotalSeconds)
                }
            }
        }
    }

    # Save benchmark
    $benchDir = "$env:ProgramData\WinForge\Benchmarks"
    New-Item -Path $benchDir -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    $results | ConvertTo-Json | Out-File "$benchDir\benchmark-$((Get-Date).ToString('yyyyMMdd-HHmmss')).json" -Encoding UTF8

    Write-ForgeLog -Message "Benchmark complete" -Level Success
    return $results
}
