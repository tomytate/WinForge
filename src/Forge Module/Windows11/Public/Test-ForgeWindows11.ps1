<#
.SYNOPSIS
    Tests if the current system is Windows 11.
.OUTPUTS
    [bool]
#>
function Test-ForgeWindows11 {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    return [System.Environment]::OSVersion.Version.Build -ge 22000
}
