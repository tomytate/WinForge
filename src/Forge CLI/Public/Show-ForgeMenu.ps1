<#
.SYNOPSIS
    Displays the interactive WinForge TUI menu.
.DESCRIPTION
    Main menu loop for selecting optimization options. Supports
    Standard and Extras editions with different menu items.
#>
function Show-ForgeMenu {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    Show-ForgeHeader

    $hasExtras = Get-Module Forge.Extras -ErrorAction SilentlyContinue

    while ($true) {
        Write-Host ""
        Write-ForgeHost -Text "═══════════════════════════════════════════" -Color "#2196F3"
        Write-ForgeHost -Text "  WinForge — Main Menu" -Color "#FFFFFF"
        Write-ForgeHost -Text "═══════════════════════════════════════════" -Color "#2196F3"
        Write-Host ""
        Write-ForgeHost -Text "  [1] Apply Profile (YAML-based)" -Color "#4CAF50"
        Write-ForgeHost -Text "  [2] Remove Bloatware" -Color "#FF9800"
        Write-ForgeHost -Text "  [3] Privacy Hardening" -Color "#9C27B0"
        Write-ForgeHost -Text "  [4] Performance Optimization" -Color "#00BCD4"
        Write-ForgeHost -Text "  [5] Gaming Mode" -Color "#E91E63"
        Write-ForgeHost -Text "  [6] Network & DNS" -Color "#3F51B5"
        Write-ForgeHost -Text "  [7] AI Nuke (Disable All AI)" -Color "#F44336"
        Write-ForgeHost -Text "  [8] Repair System" -Color "#607D8B"
        Write-ForgeHost -Text "  [9] Create Snapshot" -Color "#795548"
        Write-ForgeHost -Text "  [0] Maintenance Task" -Color "#FFC107"
        Write-Host ""
        Write-ForgeHost -Text "  [K] Security Hardening" -Color "#673AB7"
        Write-ForgeHost -Text "  [I] Install Essentials" -Color "#009688"

        if ($hasExtras) {
            Write-Host ""
            Write-ForgeHost -Text "  --- Extras ---" -Color "#FF5722"
            Write-ForgeHost -Text "  [D] Defender Remover" -Color "#F44336"
            Write-ForgeHost -Text "  [A] Activate Windows" -Color "#FF5722"
            Write-ForgeHost -Text "  [U] Update Drivers" -Color "#795548"
        }

        Write-Host ""
        Write-ForgeHost -Text "  [S] System Info" -Color "#78909C"
        Write-ForgeHost -Text "  [B] Benchmark" -Color "#78909C"
        Write-ForgeHost -Text "  [G] Launch GUI" -Color "#2196F3"
        Write-ForgeHost -Text "  [L] View Log" -Color "#78909C"
        Write-ForgeHost -Text "  [Q] Quit" -Color "#78909C"
        Write-Host ""

        $choice = Read-Host "Select"
        switch ($choice.ToUpper()) {
            "1" {
                $profilePath = Read-Host "Enter profile path (or press Enter for recommended)"
                if ([string]::IsNullOrWhiteSpace($profilePath)) {
                    Get-ForgeRecommendedProfile
                }
                else {
                    Import-ForgeProfile -Path $profilePath | Out-Null
                    Write-ForgeLog -Message "Profile loaded: $profilePath" -Level Info
                }
            }
            "2" { Remove-ForgeBloatware -Mode Moderate }
            "3" { Set-ForgePrivacy -All }
            "4" { Set-ForgePerformance -All }
            "5" { Set-ForgeGaming -All }
            "6" {
                $providers = Get-ForgeDNSProviders
                $providers | Format-Table Name, Primary, Secondary, Description -AutoSize
                $dns = Read-Host "Enter provider name"
                if ($dns) { Set-ForgeDNS -Provider $dns }
            }
            "7" { Disable-ForgeAI }
            "8" { Repair-ForgeSystem }
            "9" {
                $name = Read-Host "Snapshot name"
                if ($name) { New-ForgeSnapshot -Name $name }
            }
            "0" { Invoke-ForgeMaintenance }
            "K" { Set-ForgeSecurity -EnableSMBv1:$false }
            "I" { Install-ForgeSoftware -Essentials }
            "U" { Update-ForgeDrivers }

            "D" { if ($hasExtras) { Invoke-ForgeDefenderRemover } }
            "A" { if ($hasExtras) { Enable-ForgeWindowsActivation } }
            "S" { Get-ForgeSystemInfo | Format-List }
            "B" { Measure-ForgeSystem | Format-List }
            "G" { 
                Write-ForgeLog -Message "Launching GUI..." -Level Info
                Show-ForgeUI 
            }
            "L" {
                $logPath = Get-ForgeLogPath
                if ($logPath -and (Test-Path $logPath)) { Invoke-Item $logPath }
            }
            "Q" { Write-ForgeLog -Message "WinForge session ended" -Level Info; return }
            default { Write-ForgeHost -Text "  Invalid selection" -Color "#F44336" }
        }
    }
}
