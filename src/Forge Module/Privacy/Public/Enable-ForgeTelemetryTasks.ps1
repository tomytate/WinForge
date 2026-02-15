<#
.SYNOPSIS
    Re-enables previously disabled telemetry tasks.
#>
function Enable-ForgeTelemetryTasks {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    $tasks = Get-ForgeTelemetryTaskStatus | Where-Object { $_.State -eq 'Disabled' }
    foreach ($task in $tasks) {
        if ($PSCmdlet.ShouldProcess($task.Name, "Enable")) {
            Enable-ScheduledTask -TaskPath "$($task.Path)\" -TaskName $task.Name -ErrorAction SilentlyContinue | Out-Null
        }
    }
    Write-ForgeLog -Message "Re-enabled $($tasks.Count) telemetry tasks" -Level Success
}
