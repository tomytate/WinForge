<#
.SYNOPSIS
    Initializes the WinForge logging system.

.DESCRIPTION
    Creates the log directory structure and initializes a timestamped log file.
    Includes log rotation: old logs beyond MaxFiles are cleaned up, and log
    files exceeding MaxSizeBytes trigger a new log file (SEC-008 fix).

.PARAMETER Path
    Directory path for log files. Default: $env:ProgramData\WinForge\Logs

.PARAMETER MaxSizeBytes
    Maximum log file size before rotation. Default: 10MB.

.PARAMETER MaxFiles
    Maximum number of rotated log files to keep. Default: 5.

.EXAMPLE
    Start-ForgeLogging
    Start-ForgeLogging -Path "C:\Logs\WinForge" -MaxFiles 10
#>
function Start-ForgeLogging {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Path = "$env:ProgramData\WinForge\Logs",

        [int]$MaxSizeBytes = 10MB,

        [int]$MaxFiles = 5
    )

    $Script:MaxLogSizeBytes = $MaxSizeBytes
    $Script:MaxLogFiles = $MaxFiles

    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
    }

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $Script:LogFile = "$Path\WinForge-$timestamp.log"

    # Clean old logs (SEC-008 fix: Log rotation)
    try {
        $existingLogs = Get-ChildItem -Path $Path -Filter "WinForge-*.log" -ErrorAction Stop |
        Sort-Object CreationTime -Descending

        if ($existingLogs.Count -gt $Script:MaxLogFiles) {
            $existingLogs | Select-Object -Skip $Script:MaxLogFiles | Remove-Item -Force -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Verbose "Log cleanup skipped: $($_.Exception.Message)"
    }

    Write-ForgeLog -Message "Logging started: $Script:LogFile" -Level Info
}
