<#
.SYNOPSIS
    Gets a registry key value with error handling.

.PARAMETER Path
    The full registry path.

.PARAMETER Name
    The registry value name.

.PARAMETER DefaultValue
    Value to return if the key doesn't exist.

.OUTPUTS
    The registry value or default value.

.EXAMPLE
    $val = Get-ForgeRegistry -Path "HKCU:\SOFTWARE\Test" -Name "MySetting"
    $val = Get-ForgeRegistry -Path "HKLM:\SOFTWARE\Test" -Name "Missing" -DefaultValue 0
#>
function Get-ForgeRegistry {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        $DefaultValue = $null
    )

    try {
        if (Test-Path $Path) {
            $value = Get-ItemPropertyValue -Path $Path -Name $Name -ErrorAction Stop
            return $value
        }
        return $DefaultValue
    }
    catch {
        return $DefaultValue
    }
}
