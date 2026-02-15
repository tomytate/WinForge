<#
.SYNOPSIS
    Updates all installed packages via Winget.
#>
function Update-ForgeSoftware {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) { Write-ForgeLog -Message "Winget not found" -Level Error; return }

    if ($PSCmdlet.ShouldProcess("All packages", "Update via Winget")) {
        Start-Process "winget" -ArgumentList "upgrade --all --accept-source-agreements --accept-package-agreements --silent" -NoNewWindow -Wait
        Write-ForgeLog -Message "Software updates complete" -Level Success
    }
}
