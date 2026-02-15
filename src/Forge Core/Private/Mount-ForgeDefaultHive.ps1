<#
.SYNOPSIS
    Mounts the Default User registry hive (NTUSER.DAT).

.DESCRIPTION
    Internal helper — mounts the default user hive to HKLM\WinForge_Default.
    This allows modifying settings for all future users during OEM deployment.
    Uses reg.exe for reliable hive loading.

.OUTPUTS
    [bool] True if mounted successfully or already mounted.
#>
function Mount-ForgeDefaultHive {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $mountPoint = "HKLM\WinForge_Default"
    $defaultUserDat = "$env:SystemDrive\Users\Default\NTUSER.DAT"

    if (-not (Test-Path $defaultUserDat)) {
        Write-ForgeLog -Message "Default User NTUSER.DAT not found at $defaultUserDat" -Level Error
        return $false
    }

    if (Test-Path "Registry::$mountPoint") {
        Write-ForgeLog -Message "Default User hive already mounted." -Level Debug
        return $true
    }

    try {
        Write-ForgeLog -Message "Mounting Default User hive to $mountPoint" -Level Info
        # PS 7.5: Start-Process -PassThru ExitCode fix
        $process = Start-Process -FilePath "reg.exe" -ArgumentList "load ""$mountPoint"" ""$defaultUserDat""" -PassThru -NoNewWindow -Wait

        if ($process.ExitCode -eq 0) {
            return $true
        }
        else {
            Write-ForgeLog -Message "Failed to mount Default User hive. Exit Code: $($process.ExitCode)" -Level Error
            return $false
        }
    }
    catch {
        Write-ForgeLog -Message "Error mounting Default hive: $($_.Exception.Message)" -Level Error
        return $false
    }
}
