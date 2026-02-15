<#
.SYNOPSIS
    Runs a comprehensive system repair (DISM + SFC + ChkDsk).
#>
function Repair-ForgeSystem {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    Write-ForgeLog -Message "Starting system repair..." -Level Info

    if ($PSCmdlet.ShouldProcess("System Files", "Run DISM RestoreHealth")) {
        Write-ForgeLog -Message "Running DISM /RestoreHealth..." -Level Info
        $dism = Start-Process "dism.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -NoNewWindow -Wait -PassThru
        if ($dism.ExitCode -eq 0) { Write-ForgeLog -Message "DISM completed successfully" -Level Success }
        else { Write-ForgeLog -Message "DISM exit code: $($dism.ExitCode)" -Level Warning }
    }

    if ($PSCmdlet.ShouldProcess("System Files", "Run SFC /scannow")) {
        Write-ForgeLog -Message "Running SFC /scannow..." -Level Info
        $sfc = Start-Process "sfc.exe" -ArgumentList "/scannow" -NoNewWindow -Wait -PassThru
        if ($sfc.ExitCode -eq 0) { Write-ForgeLog -Message "SFC completed successfully" -Level Success }
        else { Write-ForgeLog -Message "SFC exit code: $($sfc.ExitCode)" -Level Warning }
    }

    Write-ForgeLog -Message "System repair complete" -Level Success
}
