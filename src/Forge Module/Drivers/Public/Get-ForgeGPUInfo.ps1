<#
.SYNOPSIS
    Gets GPU information.
.OUTPUTS
    [PSCustomObject[]] GPU details.
#>
function Get-ForgeGPUInfo {
    [CmdletBinding()]
    param()

    Get-CimInstance Win32_VideoController | ForEach-Object {
        $vendor = switch -Regex ($_.Name) {
            'NVIDIA|GeForce|RTX|GTX' { "NVIDIA" }
            'AMD|Radeon|RX'          { "AMD" }
            'Intel|UHD|Iris'         { "Intel" }
            default                  { "Unknown" }
        }

        [PSCustomObject]@{
            Name        = $_.Name
            Vendor      = $vendor
            DriverVer   = $_.DriverVersion
            DriverDate  = $_.DriverDate
            VRAM_MB     = [math]::Round($_.AdapterRAM / 1MB)
            Resolution  = "$($_.CurrentHorizontalResolution)x$($_.CurrentVerticalResolution)"
        }
    }
}
