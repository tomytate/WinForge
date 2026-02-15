<#
.SYNOPSIS
    Exports registry keys for backup purposes.

.DESCRIPTION
    Uses reg.exe for reliable registry export. Supports HKLM and HKCU hives
    with both PowerShell drive notation and Registry:: notation.

.PARAMETER Path
    The registry path to export.

.PARAMETER OutputPath
    File path to save the .reg export.

.OUTPUTS
    [bool] True if successful.

.EXAMPLE
    Export-ForgeRegistry -Path "HKCU:\SOFTWARE\MyApp" -OutputPath "C:\Backup\myapp.reg"
#>
function Export-ForgeRegistry {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath
    )

    try {
        if (-not (Test-Path $Path)) {
            Write-ForgeLog -Message "Registry path does not exist: $Path" -Level Warning
            return $false
        }

        if ($PSCmdlet.ShouldProcess($Path, "Export Registry")) {
            # Resolve PowerShell drive mappings to reg.exe format
            $hive = $null
            $subKey = $null

            if ($Path -match "^HKLM:\\?(.*)") {
                $hive = "HKEY_LOCAL_MACHINE"
                $subKey = $matches[1]
            }
            elseif ($Path -match "^HKCU:\\?(.*)") {
                $hive = "HKEY_CURRENT_USER"
                $subKey = $matches[1]
            }
            elseif ($Path -match "^Registry::HKEY_LOCAL_MACHINE\\?(.*)") {
                $hive = "HKEY_LOCAL_MACHINE"
                $subKey = $matches[1]
            }
            elseif ($Path -match "^Registry::HKEY_CURRENT_USER\\?(.*)") {
                $hive = "HKEY_CURRENT_USER"
                $subKey = $matches[1]
            }

            if (-not $hive) {
                Write-ForgeLog -Message "Unsupported registry hive for export: $Path. Only HKLM and HKCU are supported." -Level Error
                return $false
            }

            $regPath = "$hive\$subKey"
            $processArgs = @("export", "`"$regPath`"", "`"$OutputPath`"", "/y")

            # PS 7.5: Start-Process -PassThru ExitCode fix — reliable exit code checking
            $p = Start-Process -FilePath "reg.exe" -ArgumentList $processArgs -NoNewWindow -Wait -PassThru

            if ($p.ExitCode -eq 0) {
                Write-ForgeLog -Message "Exported registry: $Path -> $OutputPath" -Level Success
                return $true
            }
            else {
                Write-ForgeLog -Message "Failed to export registry (Exit Code $($p.ExitCode))" -Level Error
                return $false
            }
        }

        return $false
    }
    catch {
        Write-ForgeLog -Message "Registry export failed: $($_.Exception.Message)" -Level Error
        return $false
    }
}
