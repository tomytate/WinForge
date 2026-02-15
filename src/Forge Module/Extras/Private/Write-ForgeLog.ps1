<#
.SYNOPSIS
    Writes a log message to console and file.
    [Internal Copy for Standalone Extras]
#>
function Write-ForgeLog {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet("Info", "Success", "Warning", "Error", "Debug")]
        [string]$Level = "Info",

        [string]$Component
    )

    # PS 7.2+ ANSI Styling
    $style = $PSStyle
    $cOps = $style.Foreground
    $cFmt = $style.Formatting
    $reset = $style.Reset

    $levelColor = switch ($Level) {
        'Info' { $cOps.White }
        'Success' { $cOps.Green + $cFmt.Bold }
        'Warning' { $cOps.Yellow }
        'Error' { $cOps.Red + $cFmt.Bold }
        'Debug' { $cOps.DarkGray }
        default { $cOps.Gray }
    }

    # Construct prefix with ANSI codes
    # [Timestamp] [Level] [Component] Message
    $prefix = "$($cOps.DarkGray)[$timestamp] [$levelColor$Level$reset$($cOps.DarkGray)]"
    
    if ($Component) { 
        $prefix += " [$($cOps.Cyan)$Component$($cOps.DarkGray)]" 
    }

    # Reset before message to ensure it has default color unless forced
    $outMsg = "$prefix $reset$Message"

    Write-Host $outMsg

    # Simple file logging if Script:LogFile is defined (by parent module)
    if ($Script:LogFile) {
        try {
            "$timestamp [$Level] $Message" | Out-File -FilePath $Script:LogFile -Append -Encoding utf8 -ErrorAction SilentlyContinue
        }
        catch {}
    }
}
