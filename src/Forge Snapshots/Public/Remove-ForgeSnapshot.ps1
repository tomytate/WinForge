<#
.SYNOPSIS
    Removes a WinForge snapshot by ID.

.PARAMETER SnapshotId
    The unique ID of the snapshot to remove.

.EXAMPLE
    Remove-ForgeSnapshot -SnapshotId "a1b2c3d4-..."
#>
function Remove-ForgeSnapshot {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$SnapshotId
    )

    $basePath = "$env:ProgramData\WinForge\Snapshots\$SnapshotId"

    if (-not (Test-Path $basePath)) {
        Write-ForgeLog -Message "Snapshot not found: $SnapshotId" -Level Warning
        return
    }

    if ($PSCmdlet.ShouldProcess($SnapshotId, "Remove Snapshot")) {
        try {
            Remove-Item -Path $basePath -Recurse -Force -ErrorAction Stop
            Write-ForgeLog -Message "Snapshot removed: $SnapshotId" -Level Success
        }
        catch {
            Write-ForgeLog -Message "Failed to remove snapshot: $($_.Exception.Message)" -Level Error
        }
    }
}
