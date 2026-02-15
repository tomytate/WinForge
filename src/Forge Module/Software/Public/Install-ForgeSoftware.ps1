<#
.SYNOPSIS
    Installs software packages via Winget or Chocolatey.
.PARAMETER Packages
    Array of package IDs to install.
.PARAMETER Manager
    Package manager: Winget or Chocolatey.
#>
function Install-ForgeSoftware {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string[]]$Packages,

        [ValidateSet("Winget", "Chocolatey")]
        [string]$Manager = "Winget"
    )

    foreach ($pkg in $Packages) {
        if ($PSCmdlet.ShouldProcess($pkg, "Install via $Manager")) {
            try {
                if ($Manager -eq "Winget") {
                    $result = Start-Process "winget" -ArgumentList "install --id $pkg --accept-source-agreements --accept-package-agreements --silent" -NoNewWindow -Wait -PassThru
                }
                else {
                    $result = Start-Process "choco" -ArgumentList "install $pkg -y" -NoNewWindow -Wait -PassThru
                }

                if ($result.ExitCode -eq 0) {
                    Write-ForgeLog -Message "Installed: $pkg" -Level Success
                }
                else {
                    Write-ForgeLog -Message "Failed to install $pkg (exit: $($result.ExitCode))" -Level Warning
                }
            }
            catch {
                Write-ForgeLog -Message "Install error for $pkg : $($_.Exception.Message)" -Level Error
            }
        }
    }
}
