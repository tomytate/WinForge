<#
.SYNOPSIS
    Writes a log message to console and file.

.DESCRIPTION
    Outputs a color-coded, timestamped message to the console and appends it
    to the active log file. Handles log file rotation when the file exceeds
    the configured maximum size.

.PARAMETER Message
    The message to log.

.PARAMETER Level
    Log level: Info, Success, Warning, Error, Debug.

.PARAMETER Component
    Optional component name for categorization.

.EXAMPLE
    Write-ForgeLog -Message "Operation completed" -Level Success
    Write-ForgeLog -Message "Check failed" -Level Error -Component "Registry"
#>
function Write-ForgeLog {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Logger outputs to console by design')]
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [ValidateSet("Info", "Success", "Warning", "Error", "Debug")]
        [string]$Level = "Info",

        [string]$Component
    )

    $timestamp = Get-Date -Format "HH:mm:ss"
    
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

    # File Output
    if ($Script:LogFile) {
        # Check file size and rotate if needed (SEC-008 fix)
        if (Test-Path $Script:LogFile) {
            $fileInfo = Get-Item $Script:LogFile
            if ($fileInfo.Length -gt $Script:MaxLogSizeBytes) {
                $basePath = Split-Path $Script:LogFile -Parent
                $ts = Get-Date -Format "yyyyMMdd-HHmmss"
                $Script:LogFile = "$basePath\WinForge-$ts.log"
            }
        }

        try {
            "$timestamp [$Level] $Message" | Out-File -FilePath $Script:LogFile -Append -Encoding utf8
        }
        catch {
            Write-Verbose "Log write failed: $($_.Exception.Message)"
        }
    }
}
