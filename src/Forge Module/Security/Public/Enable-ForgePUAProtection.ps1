<#
.SYNOPSIS
    Enables Windows Defender PUA (Potentially Unwanted Application) Protection.
#>
function Enable-ForgePUAProtection {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    try {
        if ($PSCmdlet.ShouldProcess("Defender PUA Protection", "Enable")) {
            Set-MpPreference -PUAProtection 1 -ErrorAction Stop
            Write-ForgeLog -Message "PUA Protection enabled" -Level Success
        }
    }
    catch {
        Set-ForgeRegistry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "PUAProtection" -Value 1
        Write-ForgeLog -Message "PUA Protection enabled (via registry)" -Level Success
    }
}
