<#
.SYNOPSIS
    Tests if a registry key/value exists.

.PARAMETER Path
    The full registry path.

.PARAMETER Name
    Optional: The registry value name. If omitted, tests only the path.

.OUTPUTS
    [bool] True if exists, false otherwise.

.EXAMPLE
    Test-ForgeRegistry -Path "HKLM:\SOFTWARE\Test"
    Test-ForgeRegistry -Path "HKCU:\SOFTWARE\Test" -Name "MySetting"
#>
function Test-ForgeRegistry {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [string]$Name
    )

    if (-not (Test-Path $Path)) {
        return $false
    }

    if ([string]::IsNullOrEmpty($Name)) {
        return $true
    }

    try {
        $null = Get-ItemPropertyValue -Path $Path -Name $Name -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}
