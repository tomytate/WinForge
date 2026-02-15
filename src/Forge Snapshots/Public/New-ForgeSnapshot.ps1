<#
.SYNOPSIS
    Creates a new system snapshot for restoration purposes.

.DESCRIPTION
    Captures current system state including services and registry keys.
    Uses PS 7.5 ConvertTo-CliXml cmdlet for robust serialization.
    Optionally encrypts using DPAPI for security (SEC-005 fix).
    Also creates a Windows System Restore point.

.PARAMETER Name
    A friendly name for the snapshot.

.PARAMETER Description
    Optional description of the snapshot.

.PARAMETER Encrypt
    If specified, encrypts the snapshot using DPAPI.

.OUTPUTS
    [ForgeSnapshot] The created snapshot object.

.EXAMPLE
    New-ForgeSnapshot -Name "Pre-Optimization"
    New-ForgeSnapshot -Name "Before Gaming Tweaks" -Encrypt
#>
function New-ForgeSnapshot {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Name = "Auto-Snapshot",

        [string]$Description,

        [switch]$Encrypt
    )

    Write-ForgeLog -Message "Creating system snapshot: $Name" -Level Info

    $snapshot = [PSCustomObject]@{
        PSTypeName  = 'ForgeSnapshot'
        Id          = [guid]::NewGuid().ToString()
        Timestamp   = Get-Date
        Name        = $Name
        Description = $Description
        Registry    = @{}
        Services    = @()
        Version     = "1.0.0"
    }

    # Bypass 24-hour restore point creation limit
    $rpKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore"
    try {
        if (Test-Path $rpKey) {
            Write-ForgeLog -Message "Bypassing Restore Point frequency limit..." -Level Debug
            Set-ItemProperty -Path $rpKey -Name "SystemRestorePointCreationFrequency" -Value 0 -Type DWord -ErrorAction SilentlyContinue
        }
        Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction SilentlyContinue

        Checkpoint-Computer -Description "$Name ($Description)" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-ForgeLog -Message "Restore point created successfully." -Level Success
    }
    catch {
        Write-ForgeLog -Message "Restore point creation failed (Non-critical): $($_.Exception.Message)" -Level Warning
    }

    # 1. Capture Services (PERF-002 fix: Filter to relevant services)
    $relevantServicePatterns = @(
        'DiagTrack', 'Telemetry', 'BITS', 'wuauserv', 'UsoSvc',
        'Xbox*', 'Copilot', 'Connected*', 'dmwappushservice'
    )

    $serviceFilter = {
        $svc = $_.Name
        $relevantServicePatterns | Where-Object { $svc -like $_ }
    }

    try {
        $snapshot.Services = @(
            Get-Service -ErrorAction SilentlyContinue | Where-Object $serviceFilter |
            Select-Object Name, Status, StartType, DisplayName
        )
        Write-ForgeLog -Message "Captured $($snapshot.Services.Count) relevant services" -Level Debug
    }
    catch {
        Write-ForgeLog -Message "Failed to capture services: $($_.Exception.Message)" -Level Warning
        $snapshot.Services = @()
    }

    # 2. Capture Critical Registry Keys
    $criticalRegistryPaths = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo",
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"
    )

    foreach ($regPath in $criticalRegistryPaths) {
        if (Test-Path $regPath) {
            try {
                $props = Get-ItemProperty -Path $regPath -ErrorAction Stop
                $snapshot.Registry[$regPath] = $props
            }
            catch {
                Write-ForgeLog -Message "Could not capture registry: $regPath" -Level Debug
            }
        }
    }

    # Save to disk
    $basePath = "$env:ProgramData\WinForge\Snapshots\$($snapshot.Id)"

    try {
        if ($PSCmdlet.ShouldProcess($basePath, "Create Snapshot")) {
            New-Item -Path $basePath -ItemType Directory -Force | Out-Null

            # PS 7.5: ConvertTo-CliXml cmdlet (no more pipeline hack)
            $cliXml = $snapshot | ConvertTo-CliXml

            if ($Encrypt) {
                # SEC-005 fix: Encrypt snapshot using DPAPI
                $bytes = [System.Text.Encoding]::UTF8.GetBytes($cliXml)
                $encrypted = [System.Security.Cryptography.ProtectedData]::Protect(
                    $bytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser
                )
                [System.IO.File]::WriteAllBytes("$basePath\snapshot.encrypted", $encrypted)
                Write-ForgeLog -Message "Snapshot saved (encrypted): $($snapshot.Id)" -Level Success
            }
            else {
                $cliXml | Out-File -FilePath "$basePath\snapshot.clixml" -Encoding UTF8
                Write-ForgeLog -Message "Snapshot saved: $($snapshot.Id)" -Level Success
            }
        }
    }
    catch {
        Write-ForgeLog -Message "Failed to save snapshot: $($_.Exception.Message)" -Level Error
        throw
    }

    return $snapshot
}
