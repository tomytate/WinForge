<#
.SYNOPSIS
    Disables telemetry-related scheduled tasks.
.PARAMETER Level
    Aggressiveness: Safe or Aggressive.
.EXAMPLE
    Disable-ForgeTelemetryTasks -Level Safe
#>
function Disable-ForgeTelemetryTasks {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [ValidateSet("Safe", "Aggressive")]
        [string]$Level = "Safe"
    )

    $safeTasks = @(
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
        "\Microsoft\Windows\Autochk\Proxy",
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
        "\Microsoft\Windows\Feedback\Siuf\DmClient",
        "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
        "\Microsoft\Windows\Windows Error Reporting\QueueReporting",
        "\Microsoft\Windows\PI\Sqm-Tasks"
    )

    $aggressiveTasks = @(
        "\Microsoft\Windows\Application Experience\StartupAppTask",
        "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask",
        "\Microsoft\Windows\DiskFootprint\Diagnostics",
        "\Microsoft\Windows\Maintenance\WinSAT",
        "\Microsoft\Windows\Maps\MapsToastTask",
        "\Microsoft\Windows\Maps\MapsUpdateTask",
        "\Microsoft\Windows\Shell\FamilySafetyMonitor",
        "\Microsoft\Windows\Shell\FamilySafetyRefreshTask"
    )

    $tasks = if ($Level -eq "Aggressive") { $safeTasks + $aggressiveTasks } else { $safeTasks }

    $disabled = 0
    foreach ($taskPath in $tasks) {
        try {
            $task = Get-ScheduledTask -TaskPath ($taskPath | Split-Path -Parent) -TaskName ($taskPath | Split-Path -Leaf) -ErrorAction SilentlyContinue
            if ($task -and $task.State -ne 'Disabled') {
                if ($PSCmdlet.ShouldProcess($taskPath, "Disable")) {
                    Disable-ScheduledTask -TaskPath ($taskPath | Split-Path -Parent) -TaskName ($taskPath | Split-Path -Leaf) -ErrorAction Stop | Out-Null
                    $disabled++
                }
            }
        }
        catch {
            Write-ForgeLog -Message "Could not disable task: $taskPath" -Level Debug
        }
    }

    Write-ForgeLog -Message "Disabled $disabled telemetry tasks (Level: $Level)" -Level Success
}
