<#
.SYNOPSIS
    Checks if the system is currently in Sysprep Audit Mode.

.DESCRIPTION
    Internal helper — checks the AuditBoot registry key and ImageState
    to determine if Windows is in Audit Mode for OEM deployment.

.OUTPUTS
    [bool] True if in Audit Mode.
#>
function Test-ForgeAuditMode {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $auditKey = "HKLM:\SYSTEM\Setup\Status\AuditBoot"
    if (Test-Path $auditKey) {
        return $true
    }

    # Fallback check: ImageState
    $imageState = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State" -Name "ImageState" -ErrorAction SilentlyContinue
    if ($imageState -match "IMAGE_STATE_UNDEPLOYABLE" -or $imageState -match "IMAGE_STATE_GENERALIZE_RESEAL_TO_AUDIT") {
        return $true
    }

    return $false
}
