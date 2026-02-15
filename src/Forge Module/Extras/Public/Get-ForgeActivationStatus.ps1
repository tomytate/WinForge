<#
.SYNOPSIS
    Retrieves detailed Windows Activation Status.
    [EXTRAS EDITION ONLY]
.DESCRIPTION
    Queries the SoftwareLicensingProduct WMI class to assess license status.
    Ported from MAS 'Check_Activation_Status.cmd'.
.EXAMPLE
    Get-ForgeActivationStatus
#>
function Get-ForgeActivationStatus {
    [CmdletBinding()]
    param()

    Write-ForgeLog -Message "Checking Activation Status..." -Level Info

    try {
        # AppID for Windows: 55c92734-d682-4d71-983e-d6ec3f16059f
        $wmi = Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' AND PartialProductKey IS NOT NULL" -ErrorAction Stop
        
        if (-not $wmi) {
            Write-Warning "No Product Keys found."
            return
        }

        $results = foreach ($p in $wmi) {
            $status = switch ($p.LicenseStatus) {
                0 { "Unlicensed" }
                1 { "Licensed" }
                2 { "OOB Grace" }
                3 { "OOT Grace" }
                4 { "Non-Genuine Grace" }
                5 { "Notification" }
                6 { "Extended Grace" }
                Default { "Unknown ($($p.LicenseStatus))" }
            }
            
            $grace = $p.GracePeriodRemaining / 1440 # Minutes to Days roughly
            
            # Check for Permanent vs KMS
            $type = "Permanent / Retail / OEM"
            $expiry = $null
            
            if ($p.Description -match "VOLUME_KMSCLIENT") {
                $type = "Volume (KMS)"
                if ($p.GracePeriodRemaining -gt 0) {
                    $expiry = (Get-Date).AddMinutes($p.GracePeriodRemaining)
                }
            }

            [PSCustomObject]@{
                Name            = $p.Name
                Description     = $p.Description
                Status          = $status
                PartialKey      = $p.PartialProductKey
                LicenseType     = $type
                GracePeriodDays = [math]::Round($grace, 1)
                ExpiryDate      = $expiry
            }
        }
        
        return $results
    }
    catch {
        Write-Error "Failed to query activation status: $_"
    }
}
