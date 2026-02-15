<#
.SYNOPSIS
    Sets a registry value, creating the key path if it doesn't exist.

.DESCRIPTION
    Internal helper — lightweight registry setter used by Tweaks module functions
    for batch registry modifications. Unlike Set-ForgeRegistry (the public function),
    this skips ACL validation for speed during bulk operations.

.PARAMETER Path
    The full registry path.

.PARAMETER Name
    The registry value name.

.PARAMETER Type
    The registry value type.

.PARAMETER Value
    The value to set.
#>
function Set-ForgeRegistryValue {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Type,

        [Parameter(Mandatory)]
        $Value
    )

    if (-not $PSCmdlet.ShouldProcess("$Path\$Name", "Set value to $Value")) {
        return
    }

    try {
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
        Write-Verbose "Set $Path\$Name = $Value"
    }
    catch {
        Write-ForgeLog -Message "Failed to set registry: $Path\$Name - $($_.Exception.Message)" -Level Warning
    }
}
