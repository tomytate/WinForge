<#
.SYNOPSIS
    Gets the status of installed drivers, identifying outdated ones.
#>
function Get-ForgeDriverStatus {
    [CmdletBinding()]
    param()

    $drivers = Get-CimInstance Win32_PnPSignedDriver -ErrorAction SilentlyContinue |
        Where-Object { $_.DriverDate } |
        Select-Object DeviceName, DriverVersion, DriverDate, Manufacturer |
        Sort-Object DriverDate

    $cutoff = (Get-Date).AddYears(-2)
    foreach ($drv in $drivers) {
        $drv | Add-Member -NotePropertyName "Outdated" -NotePropertyValue ($drv.DriverDate -lt $cutoff) -Force
    }

    return $drivers
}
