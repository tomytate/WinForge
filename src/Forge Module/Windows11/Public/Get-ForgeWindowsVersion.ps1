<#
.SYNOPSIS
    Gets detailed Windows version information.
.OUTPUTS
    [PSCustomObject] Version details including build number and feature update.
#>
function Get-ForgeWindowsVersion {
    [CmdletBinding()]
    param()

    $os = Get-CimInstance Win32_OperatingSystem
    $build = [System.Environment]::OSVersion.Version.Build
    $ubr = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name UBR -ErrorAction SilentlyContinue).UBR
    $displayVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name DisplayVersion -ErrorAction SilentlyContinue).DisplayVersion

    [PSCustomObject]@{
        OS             = $os.Caption
        Version        = $displayVersion
        Build          = "$build.$ubr"
        Architecture   = $env:PROCESSOR_ARCHITECTURE
        InstallDate    = $os.InstallDate
        LastBoot       = $os.LastBootUpTime
        IsWindows11    = $build -ge 22000
        Is25H2         = $build -ge 26100
    }
}
