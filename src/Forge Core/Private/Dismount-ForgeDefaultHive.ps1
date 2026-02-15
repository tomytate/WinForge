<#
.SYNOPSIS
    Dismounts the Default User registry hive.

.DESCRIPTION
    Internal helper — unloads the HKLM\WinForge_Default hive.
    Forces garbage collection before unloading to release file handles.
#>
function Dismount-ForgeDefaultHive {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    $mountPoint = "HKLM\WinForge_Default"

    if (-not (Test-Path "Registry::$mountPoint")) {
        return
    }

    try {
        Write-ForgeLog -Message "Dismounting Default User hive..." -Level Info
        [GC]::Collect()  # Force garbage collection to release file handles

        # PS 7.5: Start-Process -PassThru ExitCode fix
        $process = Start-Process -FilePath "reg.exe" -ArgumentList "unload ""$mountPoint""" -PassThru -NoNewWindow -Wait

        if ($process.ExitCode -ne 0) {
            Write-ForgeLog -Message "Failed to unload Default User hive. Cleanup required." -Level Warning
        }
    }
    catch {
        Write-ForgeLog -Message "Error dismounting hive: $($_.Exception.Message)" -Level Error
    }
}
