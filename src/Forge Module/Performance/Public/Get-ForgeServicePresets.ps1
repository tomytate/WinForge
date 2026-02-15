<#
.SYNOPSIS
    Lists available service presets and their contents.
#>
function Get-ForgeServicePresets {
    [CmdletBinding()]
    param()

    $dataFile = "$PSScriptRoot\..\Data\services.json"
    if (Test-Path $dataFile) {
        $presets = Get-Content $dataFile -Raw | ConvertFrom-Json -DateKind Json
        return $presets
    }
    Write-ForgeLog -Message "services.json not found" -Level Warning
}
