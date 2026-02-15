<#
.SYNOPSIS
    Registers a weekly WinForge maintenance scheduled task.
.PARAMETER Daily
    If specified, registers for daily execution instead of weekly.
#>
function Register-ForgeMaintenance {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param([switch]$Daily)

    $taskName = "WinForge Maintenance"
    $existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    if ($existing) {
        Write-ForgeLog -Message "Maintenance task already registered" -Level Info
        return
    }

    $action = New-ScheduledTaskAction -Execute "pwsh.exe" `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\..\..\..\WinForge.ps1`" -Maintenance"

    $trigger = if ($Daily) {
        New-ScheduledTaskTrigger -Daily -At "3:00AM"
    } else {
        New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At "3:00AM"
    }

    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    if ($PSCmdlet.ShouldProcess($taskName, "Register")) {
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings | Out-Null
        Write-ForgeLog -Message "Maintenance task registered ($(if ($Daily) { 'Daily' } else { 'Weekly' }))" -Level Success
    }
}
