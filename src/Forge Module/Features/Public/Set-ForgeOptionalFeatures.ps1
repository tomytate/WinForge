<#
.SYNOPSIS
    Disables Windows Optional Features.
.PARAMETER Features
    List of feature names to disable. Defaults to common unneeded features.
#>
function Set-ForgeOptionalFeatures {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [string[]]$Features = @(
            "MicrosoftWindowsPowerShellV2Root",
            "MicrosoftWindowsPowerShellV2",
            "WorkFolders-Client",
            "Printing-Foundation-Features",
            "Printing-PrintToPDFServices-Features"
        )
    )

    foreach ($feature in $Features) {
        try {
            $state = Get-WindowsOptionalFeature -Online -FeatureName $feature -ErrorAction SilentlyContinue
            if ($state -and $state.State -eq "Enabled") {
                if ($PSCmdlet.ShouldProcess($feature, "Disable")) {
                    Disable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart -ErrorAction Stop | Out-Null
                    Write-ForgeLog -Message "Disabled feature: $feature" -Level Success
                }
            }
        }
        catch {
            Write-ForgeLog -Message "Could not disable $feature : $($_.Exception.Message)" -Level Warning
        }
    }
}
