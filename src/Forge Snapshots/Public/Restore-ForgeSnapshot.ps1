<#
.SYNOPSIS
    Restores a previously created system snapshot.

.DESCRIPTION
    Loads a snapshot (plain or encrypted CLIXML) and restores services
    and registry keys to their captured state.

.PARAMETER SnapshotId
    The unique ID of the snapshot to restore.

.EXAMPLE
    Restore-ForgeSnapshot -SnapshotId "a1b2c3d4-..."
#>
function Restore-ForgeSnapshot {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$SnapshotId
    )

    $basePath = "$env:ProgramData\WinForge\Snapshots\$SnapshotId"
    $clixmlPath = "$basePath\snapshot.clixml"
    $encryptedPath = "$basePath\snapshot.encrypted"

    # Try to load snapshot
    $snapshot = $null

    if (Test-Path $clixmlPath) {
        try {
            $content = Get-Content $clixmlPath -Raw
            $snapshot = $content | ConvertFrom-CliXml
        }
        catch {
            Write-ForgeLog -Message "Failed to load snapshot: $($_.Exception.Message)" -Level Error
            throw "Snapshot ID not found or corrupted: $SnapshotId"
        }
    }
    elseif (Test-Path $encryptedPath) {
        try {
            $encrypted = [System.IO.File]::ReadAllBytes($encryptedPath)
            $decrypted = [System.Security.Cryptography.ProtectedData]::Unprotect(
                $encrypted, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser
            )
            $clixml = [System.Text.Encoding]::UTF8.GetString($decrypted)
            $snapshot = $clixml | ConvertFrom-CliXml
        }
        catch {
            Write-ForgeLog -Message "Failed to decrypt snapshot: $($_.Exception.Message)" -Level Error
            throw "Snapshot decryption failed for: $SnapshotId"
        }
    }
    else {
        throw "Snapshot ID not found: $SnapshotId"
    }

    Write-ForgeLog -Message "Restoring Snapshot: $($snapshot.Name) ($($snapshot.Timestamp))" -Level Info

    $successCount = 0
    $failCount = 0

    # 1. Restore Services
    foreach ($svc in $snapshot.Services) {
        try {
            $current = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
            if ($current -and $current.StartType -ne $svc.StartType) {
                if ($PSCmdlet.ShouldProcess($svc.Name, "Restore Service to $($svc.StartType)")) {
                    Write-ForgeLog -Message "Restoring Service: $($svc.Name) to $($svc.StartType)" -Level Info
                    Set-Service -Name $svc.Name -StartupType $svc.StartType -ErrorAction Stop
                    $successCount++
                }
            }
        }
        catch {
            Write-ForgeLog -Message "Failed to restore service $($svc.Name): $($_.Exception.Message)" -Level Warning
            $failCount++
        }
    }

    # 2. Restore Registry
    foreach ($regPath in $snapshot.Registry.Keys) {
        $regData = $snapshot.Registry[$regPath]
        if ($regData) {
            foreach ($prop in $regData.PSObject.Properties) {
                if ($prop.Name -notmatch '^PS') {
                    if (Set-ForgeRegistry -Path $regPath -Name $prop.Name -Value $prop.Value) {
                        $successCount++
                    }
                    else {
                        $failCount++
                    }
                }
            }
        }
    }

    Write-ForgeLog -Message "Restore completed: $successCount succeeded, $failCount failed" -Level $(if ($failCount -eq 0) { "Success" } else { "Warning" })
}
