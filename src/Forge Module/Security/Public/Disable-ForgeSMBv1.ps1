<#
.SYNOPSIS
    Disables the SMBv1 protocol for security hardening.
#>
function Disable-ForgeSMBv1 {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    try {
        $smb1 = Get-SmbServerConfiguration -ErrorAction Stop
        if ($smb1.EnableSMB1Protocol) {
            if ($PSCmdlet.ShouldProcess("SMBv1", "Disable")) {
                Set-SmbServerConfiguration -EnableSMB1Protocol $false -Confirm:$false -Force
                Write-ForgeLog -Message "SMBv1 disabled" -Level Success
            }
        }
        else {
            Write-ForgeLog -Message "SMBv1 already disabled" -Level Info
        }
    }
    catch {
        # Fallback: registry method
        Set-ForgeRegistry -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Value 0
        Write-ForgeLog -Message "SMBv1 disabled (via registry)" -Level Success
    }
}
