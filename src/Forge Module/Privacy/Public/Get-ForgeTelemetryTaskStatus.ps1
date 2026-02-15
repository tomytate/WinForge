<#
.SYNOPSIS
    Gets the status of telemetry-related scheduled tasks.
.OUTPUTS
    [PSCustomObject[]] Task status objects.
#>
function Get-ForgeTelemetryTaskStatus {
    [CmdletBinding()]
    param()

    $taskPaths = @(
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
        "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
    )

    foreach ($taskPath in $taskPaths) {
        try {
            $parent = $taskPath | Split-Path -Parent
            $leaf = $taskPath | Split-Path -Leaf
            $task = Get-ScheduledTask -TaskPath "$parent\" -TaskName $leaf -ErrorAction SilentlyContinue
            if ($task) {
                [PSCustomObject]@{
                    Name   = $leaf
                    Path   = $parent
                    State  = $task.State
                }
            }
        }
        catch { }
    }
}
