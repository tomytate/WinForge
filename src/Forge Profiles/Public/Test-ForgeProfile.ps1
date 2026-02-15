<#
.SYNOPSIS
    Validates a configuration object against the WinForge profile schema.

.PARAMETER Config
    The configuration object to validate.

.OUTPUTS
    [bool] True if valid, false otherwise.

.EXAMPLE
    $config = Import-ForgeProfile -Path "profiles/balanced.yaml"
    Test-ForgeProfile -Config $config
#>
function Test-ForgeProfile {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [psobject]$Config
    )

    try {
        if (-not $Config.metadata) { return $false }
        if (-not $Config.metadata.name) { return $false }
        if (-not $Config.metadata.version) { return $false }
        return $true
    }
    catch {
        return $false
    }
}
