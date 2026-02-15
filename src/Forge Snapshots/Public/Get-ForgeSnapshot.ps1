<#
.SYNOPSIS
    Lists all available WinForge snapshots.

.OUTPUTS
    [PSCustomObject[]] Array of snapshot objects.

.EXAMPLE
    Get-ForgeSnapshot | Format-Table Id, Name, Timestamp
#>
function Get-ForgeSnapshot {
    [CmdletBinding()]
    param()

    $basePath = "$env:ProgramData\WinForge\Snapshots"

    if (-not (Test-Path $basePath)) {
        return @()
    }

    $snapshots = @(
        Get-ChildItem $basePath -Directory | ForEach-Object {
            $clixmlPath = Join-Path $_.FullName "snapshot.clixml"
            $encryptedPath = Join-Path $_.FullName "snapshot.encrypted"

            if (Test-Path $clixmlPath) {
                try {
                    $content = Get-Content $clixmlPath -Raw
                    $content | ConvertFrom-CliXml
                }
                catch {
                    Write-ForgeLog -Message "Could not read snapshot: $($_.FullName)" -Level Debug
                }
            }
            elseif (Test-Path $encryptedPath) {
                [PSCustomObject]@{
                    Id        = $_.Name
                    Name      = "(Encrypted)"
                    Timestamp = $_.CreationTime
                    Encrypted = $true
                }
            }
        }
    )

    return $snapshots
}
