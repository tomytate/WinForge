<#
.SYNOPSIS
    Tests if the current session is running with elevated (Administrator) privileges.

.OUTPUTS
    [bool] True if running as Administrator.

.EXAMPLE
    if (-not (Test-ForgeElevation)) {
        Write-ForgeLog -Message "WinForge requires Administrator privileges" -Level Error
        return
    }
#>
function Test-ForgeElevation {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [System.Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}
