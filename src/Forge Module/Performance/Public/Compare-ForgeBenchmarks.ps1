<#
.SYNOPSIS
    Compares before/after benchmarks.
#>
function Compare-ForgeBenchmarks {
    [CmdletBinding()]
    param()

    $benchDir = "$env:ProgramData\WinForge\Benchmarks"
    if (-not (Test-Path $benchDir)) { Write-ForgeLog -Message "No benchmarks found" -Level Warning; return }

    $files = Get-ChildItem $benchDir -Filter "benchmark-*.json" | Sort-Object Name
    if ($files.Count -lt 2) { Write-ForgeLog -Message "Need at least 2 benchmarks to compare" -Level Warning; return }

    $first = Get-Content $files[0].FullName -Raw | ConvertFrom-Json -DateKind Json
    $last = Get-Content $files[-1].FullName -Raw | ConvertFrom-Json -DateKind Json

    [PSCustomObject]@{
        Before_RAM_Used = $first.RAMUsedGB
        After_RAM_Used  = $last.RAMUsedGB
        RAM_Saved_GB    = [math]::Round($first.RAMUsedGB - $last.RAMUsedGB, 2)
    }
}
