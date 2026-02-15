<#
.SYNOPSIS
    Reads current system configuration to determine the state of various tweaks.

.DESCRIPTION
    Inspects registry keys and system settings to build a state object reflecting
    the current configuration. Used by the GUI to synchronize checkboxes with
    actual system state and by the CLI for status reports.

.OUTPUTS
    [psobject] Object with boolean/value properties for each tracked setting.

.EXAMPLE
    $state = Get-ForgeSystemInfo
    if ($state.Copilot) { Write-Host "Copilot is still enabled" }
#>
function Get-ForgeSystemInfo {
    [CmdletBinding()]
    [OutputType([psobject])]
    param()

    $state = [pscustomobject]@{
        # Customization
        DarkTheme         = (Get-ForgeRegistry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme") -eq 0
        ActivityHistory   = (Get-ForgeRegistry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "PublishUserActivities") -ne 0
        BackgroundApps    = (Get-ForgeRegistry "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled") -ne 1
        ClipboardHistory  = (Get-ForgeRegistry "HKCU:\Software\Microsoft\Clipboard" "EnableClipboardHistory") -eq 1
        Hibernate         = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -ErrorAction SilentlyContinue).HibernateEnabled -eq 1

        # Privacy
        Telemetry         = (Get-ForgeRegistry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry") -ne 0
        Location          = (Get-ForgeRegistry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value") -ne "Deny"
        Copilot           = ((Get-ForgeRegistry "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" "TurnOffWindowsCopilot") -ne 1) -and
        ((Get-ForgeRegistry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" "TurnOffWindowsCopilot") -ne 1)
        Recall            = ((Get-ForgeRegistry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" "DisableAIDataAnalysis") -ne 1) -or
        ((Get-Service "AIFabric*" -ErrorAction SilentlyContinue).Status -eq 'Running')

        # Performance / Gaming
        GameMode          = (Get-ForgeRegistry "HKCU:\Software\Microsoft\GameBar" "AllowAutoGameMode") -ne 0
        GameBar           = (Get-ForgeRegistry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" "AppCaptureEnabled") -ne 0

        # Gaming Optimizations
        GamingNetwork     = (Get-ForgeRegistry "HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters" "TCPNoDelay") -eq 1
        GamingInput       = (Get-ForgeRegistry "HKCU:\Control Panel\Mouse" "MouseSpeed") -eq "0"
        GamingMMCSS       = (Get-ForgeRegistry "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness") -eq 0
        UltimatePlan      = (powercfg /getactivescheme) -match "e9a42b02-d5df-448d-aa00-03f14749eb61"

        # Updates
        WindowsUpdate     = (Get-ForgeRegistry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate") -ne 1
        IPv6              = (Get-ForgeRegistry "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" "DisabledComponents") -ne 255

        # Real-time Stats
        ActiveConnections = (Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue).Count
    }

    return $state
}
