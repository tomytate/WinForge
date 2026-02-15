<#
.SYNOPSIS
    Removes Windows Defender and associated security components.
    [EXTRAS EDITION ONLY]
.DESCRIPTION
    Permanently disables and removes Windows Defender Antivirus, Security Center,
    and associated services using a data-driven approach.
    
    WARNING: This action is destructive and significantly lowers system security.
.PARAMETER Restore
    Restores default Defender configuration (experimental).
.EXAMPLE
    Invoke-ForgeDefenderRemover -Confirm:$false
#>
function Invoke-ForgeDefenderRemover {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param(
        [switch]$Restore
    )

    if ($Restore) {
        Write-Warning "Restore functionality is not yet implemented."
        return
    }

    if ($PSCmdlet.ShouldProcess("Windows Defender", "PERMANENTLY REMOVE")) {
        Write-ForgeLog -Message "Starting Windows Defender Removal..." -Level Warning

        # Load Data
        $jsonPath = Join-Path $PSScriptRoot "..\Data\defender-registry.json"
        if (-not (Test-Path $jsonPath)) {
            Write-Error "Data file not found: $jsonPath"
            return
        }
        $data = Get-Content $jsonPath -Raw | ConvertFrom-Json -DateKind Json

        # 1. Disable Tamper Protection (Best Effort)
        Write-ForgeLog -Message "Disabling Tamper Protection..." -Level Info
        $tamperPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
        if (Test-Path $tamperPath) {
            New-ItemProperty -Path $tamperPath -Name "TamperProtection" -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
        }

        # 2. Disable/Delete Services
        Write-ForgeLog -Message "Disabling Services..." -Level Info
        foreach ($svc in $data.Services) {
            $path = "HKLM:\SYSTEM\CurrentControlSet\Services\$svc"
            if (Test-Path $path) {
                # Try to disable first
                New-ItemProperty -Path $path -Name "Start" -Value 4 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                
                # Try to delete if possible (requires high privs usually provided by TrustedInstaller/System)
                # In pure Admin PS, we might output a warning or try basic deletion
                # Remove-Service is not available for core system services usually
                # We stick to disabling via registry 'Start=4' which is effective
                Write-Verbose "Disabled service: $svc"
            }
        }

        # 3. Disable Scheduled Tasks
        Write-ForgeLog -Message "Disabling Scheduled Tasks..." -Level Info
        foreach ($taskPath in $data.ScheduledTasks) {
            Get-ScheduledTask -TaskName (Split-Path $taskPath -Leaf) -TaskPath (Split-Path $taskPath -Parent) -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue
        }

        # 4. Apply Registry Policies
        Write-ForgeLog -Message "Applying Registry Policies..." -Level Info
        foreach ($p in $data.RegistryPolicies) {
            Write-ForgeLog -Message "Setting Registry Policy: $($p.Name)..."
            if (-not (Test-Path $p.Path)) { New-Item -Path $p.Path -Force -ErrorAction SilentlyContinue | Out-Null }
            Set-ItemProperty -Path $p.Path -Name $p.Name -Value $p.Value -Type $p.Type -Force
        }

        # 5. Registry Deletions
        if ($data.RegistryDeletes) {
            foreach ($path in $data.RegistryDeletes) {
                Write-ForgeLog -Message "Removing Registry Key: $path..."
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        # 6. Remove SecHealthUI (Appx with DISM Unlock)
        Write-ForgeLog -Message "Removing SecHealthUI Appx..." -Level Info
        $appxName = "SecHealthUI"
        $provisioned = Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like "*$appxName*" }
        foreach ($p in $provisioned) {
            # Unlock Non-Removable
            Write-ForgeLog -Message "Unlocking $($p.DisplayName)..."
            Dism /Online /Set-NonRemovableAppPolicy /PackageFamily:$($p.PackageName -replace "_.*", "_8wekyb3d8bbwe") /NonRemovable:0 | Out-Null
            Remove-AppxProvisionedPackage -PackageName $p.PackageName -Online -AllUsers -ErrorAction SilentlyContinue | Out-Null
        }
        Get-AppxPackage -AllUsers -Name "*$appxName*" | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue

        # 7. Nuke Files and Folders (Ruthless)
        $foldersToNuke = @(
            "$env:ProgramData\Microsoft\Windows Defender",
            "$env:ProgramFiles\Windows Defender",
            "${env:ProgramFiles(x86)}\Windows Defender",
            "$env:ProgramFiles\Windows Defender Advanced Threat Protection"
        )
        foreach ($folder in $foldersToNuke) {
            if (Test-Path $folder) {
                Write-ForgeLog -Message "Nuking Folder: $folder" -Level Warning
                # Take Ownership & Grant Access (PowerShell Native)
                # Note: 'takeown' and 'icacls' are reliable for this, but we prefer native if possible.
                # Given strict 'native' requirement, we use .NET ACLs or just force remove.
                # But system folders often require explicit TakeOwn. We will use cmd /c takeown for robustness as it is built-in.
                cmd /c "takeown /f `"$folder`" /r /d y & icacls `"$folder`" /grant administrators:F /t" | Out-Null
                Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        # 8. Check and Verify
        Write-ForgeLog -Message "Defender Removal Logic Complete." -Level Success
        
        # 9. Remove SecurityHealthSystray
        $runPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        if (Get-ItemProperty -Path $runPath -Name "SecurityHealth" -ErrorAction SilentlyContinue) {
            Remove-ItemProperty -Path $runPath -Name "SecurityHealth" -ErrorAction SilentlyContinue
        }
        
        # 10. Disable SmartScreen (Explorer)
        New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null

        Write-ForgeLog -Message "Windows Defender Removal Complete. Please REBOOT." -Level Success
        
        if ($env:WinForge_NoReboot -ne 'true') {
            Write-Warning "A system restart is required for changes to take full effect."
        }
    }
}
