<#
.SYNOPSIS
    Applies privacy hardening settings.
.DESCRIPTION
    Disables advertising ID, activity history, telemetry, location tracking,
    Copilot, and Recall based on configuration.
.PARAMETER DisableAdvertisingId
    Disable Windows advertising ID.
.PARAMETER DisableTelemetry
    Set telemetry to Security level.
.PARAMETER DisableLocation
    Disable location tracking.
.PARAMETER DisableActivityHistory
    Disable activity history and timeline.
.EXAMPLE
    Set-ForgePrivacy -DisableAdvertisingId -DisableTelemetry
#>
function Set-ForgePrivacy {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [switch]$DisableAdvertisingId,
        [switch]$DisableTelemetry,
        [switch]$DisableLocation,
        [switch]$DisableActivityHistory,
        [switch]$All
    )

    if ($All) {
        $DisableAdvertisingId = $DisableTelemetry = $DisableLocation = $DisableActivityHistory = $true
    }

    if ($DisableAdvertisingId) {
        Set-ForgeRegistry -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0
        Write-ForgeLog -Message "Advertising ID disabled" -Level Success
    }

    if ($DisableTelemetry) {
        Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0
        Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "MaxTelemetryAllowed" -Value 0
        Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0
        Write-ForgeLog -Message "Telemetry set to Security (0)" -Level Success
    }

    if ($DisableLocation) {
        Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny" -Type String
        Write-ForgeLog -Message "Location tracking disabled" -Level Success
    }

    if ($DisableActivityHistory) {
        Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0
        Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 0
        Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Value 0
        Write-ForgeLog -Message "Activity history disabled" -Level Success
    }
}
