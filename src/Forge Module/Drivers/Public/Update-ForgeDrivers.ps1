<#
.SYNOPSIS
    Updates drivers via Windows Update or GPU-specific channels.
.PARAMETER GPU
    Update GPU drivers specifically via Winget.
.PARAMETER WindowsUpdate
    Use Windows Update for driver updates.
#>
function Update-ForgeDrivers {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [switch]$GPU,
        [switch]$WindowsUpdate
    )

    if ($GPU) {
        $gpuInfo = Get-ForgeGPUInfo
        foreach ($gpu in $gpuInfo) {
            if ($gpu.Vendor -eq "NVIDIA") {
                Write-ForgeLog -Message "Checking for NVIDIA driver updates..." -Level Info
                $winget = Get-Command winget -ErrorAction SilentlyContinue
                if ($winget) {
                    Start-Process "winget" -ArgumentList "upgrade --id Nvidia.GeForce.Experience --silent --accept-source-agreements" -NoNewWindow -Wait -ErrorAction SilentlyContinue
                }
            }
            elseif ($gpu.Vendor -eq "AMD") {
                Write-ForgeLog -Message "For AMD drivers, visit: https://www.amd.com/en/support" -Level Info
            }
        }
    }

    if ($WindowsUpdate) {
        Write-ForgeLog -Message "Checking Windows Update for drivers..." -Level Info
        $wuModule = Get-Module -ListAvailable PSWindowsUpdate -ErrorAction SilentlyContinue
        if ($wuModule) {
            Import-Module PSWindowsUpdate -Force
            Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -IgnoreReboot -ErrorAction SilentlyContinue
            Write-ForgeLog -Message "Windows Update drivers installed" -Level Success
        }
        else {
            Write-ForgeLog -Message "PSWindowsUpdate module not found. Install via: Install-PSResource PSWindowsUpdate" -Level Warning
        }
    }
}
