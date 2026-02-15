<#
.SYNOPSIS
    Analyzes hardware to recommend an optimization profile.

.DESCRIPTION
    Checks RAM and GPU to suggest 'gaming', 'aggressive', or 'balanced'.

.OUTPUTS
    [string] The recommended profile name.

.EXAMPLE
    $recommended = Get-ForgeRecommendedProfile
    Import-ForgeProfile -Path "profiles/$recommended.yaml"
#>
function Get-ForgeRecommendedProfile {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        # Check RAM (GB)
        $ramObj = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
        $totalRamGB = if ($ramObj) { [math]::Round($ramObj.TotalPhysicalMemory / 1GB) } else { 8 }

        # Check GPU
        $gpus = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue
        $hasHighEndGpu = $false
        if ($gpus) {
            foreach ($gpu in $gpus) {
                if ($gpu.Name -match 'NVIDIA|AMD|Radeon|GeForce|RTX|GTX') {
                    $hasHighEndGpu = $true
                    break
                }
            }
        }

        # Logic — maps to new profile names
        if ($totalRamGB -lt 8) {
            return "aggressive"
        }
        elseif ($totalRamGB -ge 16 -and $hasHighEndGpu) {
            return "gaming"
        }
        else {
            return "balanced"
        }
    }
    catch {
        Write-ForgeLog -Message "Failed to detect hardware for recommendation: $($_.Exception.Message)" -Level Warning
        return "balanced"  # Fallback
    }
}
