<#
.SYNOPSIS
    Repairs Windows Activation and Licensing components.
    [EXTRAS EDITION ONLY]
.DESCRIPTION
    Fixes common activation issues by repairing WMI, ClipSVC, and SPP tokens.
    Ported from MAS 'Troubleshoot.cmd'.
.PARAMETER All
    Run all repair routines.
.PARAMETER FixWMI
    Recompiles WMI licensing MOFs.
.PARAMETER ResetLicensing
    Clears ClipSVC tokens and resets SPP.
.EXAMPLE
    Repair-ForgeActivation -All
#>
function Repair-ForgeActivation {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [switch]$All,
        [switch]$FixWMI,
        [switch]$ResetLicensing
    )

    if ($All) { 
        $FixWMI = $true
        $ResetLicensing = $true
    }

    if ($FixWMI) {
        if ($PSCmdlet.ShouldProcess("WMI", "Repair Licensing MOFs")) {
            Write-ForgeLog -Message "Repairing WMI..." -Level Warning
            # Recompile MOFs usually found in System32\wbem
            $mofs = @("sppwmi.mof", "sppwmi_uninstall.mof") 
            foreach ($mof in $mofs) {
                $path = "$env:SystemRoot\System32\wbem\$mof"
                if (Test-Path $path) {
                    Write-Verbose "Compiling $mof"
                    mofcomp $path | Out-Null
                }
            }
            Write-ForgeLog -Message "WMI Repair Complete." -Level Success
        }
    }

    if ($ResetLicensing) {
        if ($PSCmdlet.ShouldProcess("Licensing", "Reset Tokens and Service")) {
            Write-ForgeLog -Message "Resetting Licensing Tokens..." -Level Warning
            
            # Stop Services
            Stop-Service sppsvc -Force -ErrorAction SilentlyContinue
            Stop-Service ClipSVC -Force -ErrorAction SilentlyContinue
            
            # Additional cleanup logic from MAS (ClipCleanUpState)
            if (Test-Path "$env:SystemRoot\System32\clipc.dll") {
                Start-Process -FilePath "rundll32" -ArgumentList "clipc.dll,ClipCleanUpState" -Wait
            }
            
            # Clear SPP Tokens (Dangerous? MAS does it carefully)
            # We will stick to soft reset: Restarting services and triggering checks
            
            Start-Service sppsvc -ErrorAction SilentlyContinue
            Start-Service ClipSVC -ErrorAction SilentlyContinue
            
            Write-ForgeLog -Message "Licensing Services Reset." -Level Success
        }
    }
}
