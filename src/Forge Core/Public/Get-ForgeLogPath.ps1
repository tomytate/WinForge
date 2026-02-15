<#
.SYNOPSIS
    Gets the current WinForge log file path.

.OUTPUTS
    [string] The absolute path to the active log file, or $null if logging hasn't started.

.EXAMPLE
    $logPath = Get-ForgeLogPath
#>
function Get-ForgeLogPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    return $Script:LogFile
}
