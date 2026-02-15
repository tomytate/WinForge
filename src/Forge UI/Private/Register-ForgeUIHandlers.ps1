<#
.SYNOPSIS
    Registers WPF button event handlers for the WinForge GUI.
.DESCRIPTION
    Finds buttons in the loaded XAML window and attaches Click handlers.
    Automatically hides buttons if their target command is not available.
#>
function Register-ForgeUIHandler {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [System.Windows.Window]$Window
    )

    $buttonMap = @{
        "Remove Bloatware"  = "Remove-ForgeBloatware"
        "Privacy Hardening" = "Set-ForgePrivacy"
        "Performance"       = "Set-ForgePerformance"
        "Gaming Mode"       = "Set-ForgeGaming"
        "Network"           = "Set-ForgeDNS"
        "AI Nuke"           = "Disable-ForgeAI"
        "Repair System"     = "Repair-ForgeSystem"
        "Security"          = "Set-ForgeSecurity"
        "Install Software"  = "Install-ForgeSoftware"
        "Update Drivers"    = "Update-ForgeDrivers"
        "Maintenance"       = "Invoke-ForgeMaintenance"
        "Apply Profile"     = "Get-ForgeRecommendedProfile"
        "Snapshot"          = "New-ForgeSnapshot"
        "System Info"       = "Get-ForgeSystemInfo"
        "Defender Remover"  = "Invoke-ForgeDefenderRemover"
        "Activate Windows"  = "Enable-ForgeWindowsActivation"
        "Benchmark"         = "Measure-ForgeSystem"
        "View Log"          = "Get-ForgeLogPath"
    }

    $clickMap = @{
        "Remove Bloatware"  = { Remove-ForgeBloatware -Mode Moderate }
        "Privacy Hardening" = { Set-ForgePrivacy -All }
        "Performance"       = { Set-ForgePerformance -All }
        "Gaming Mode"       = { Set-ForgeGaming -All }
        "Network"           = { Set-ForgeDNS -Provider Cloudflare }
        "AI Nuke"           = { Disable-ForgeAI }
        "Repair System"     = { Repair-ForgeSystem }
        "Security"          = { Set-ForgeSecurity -EnableSMBv1:$false }
        "Install Software"  = { Install-ForgeSoftware -Essentials }
        "Update Drivers"    = { Update-ForgeDrivers }
        "Maintenance"       = { Invoke-ForgeMaintenance }
        "Apply Profile"     = { Get-ForgeRecommendedProfile }
        "Snapshot"          = { New-ForgeSnapshot -Name "GUI-$(Get-Date -Format 'yyyyMMdd-HHmmss')" }
        "System Info"       = { Get-ForgeSystemInfo | Out-GridView }
        "Defender Remover"  = { Invoke-ForgeDefenderRemover }
        "Activate Windows"  = { Enable-ForgeWindowsActivation }
        "Benchmark"         = { Measure-ForgeSystem | Out-GridView -Title "System Benchmark" }
        "View Log"          = { 
            $log = Get-ForgeLogPath
            if (Test-Path $log) { Invoke-Item $log }
        }
    }

    # Helper function to find buttons
    function Get-Button {
        param($Parent)
        if ($Parent -is [System.Windows.Controls.Button]) { return $Parent }
        if ($Parent.Content) { return Get-Button $Parent.Content }
        if ($Parent.Children) {
            foreach ($child in $Parent.Children) { Get-Button $child }
        }
        if ($Parent.Child) { Get-Button $Parent.Child }
    }

    # Recursive search for buttons since Get-UIElement might not be available yet
    $buttons = @()
    $stack = new-object System.Collections.Stack
    $stack.Push($Window)
    while ($stack.Count -gt 0) {
        $el = $stack.Pop()
        if ($el -is [System.Windows.Controls.Button]) { $buttons += $el }

        if ($el -is [System.Windows.Controls.Decorator]) {
            if ($el.Child) { $stack.Push($el.Child) }
        }
        elseif ($el -is [System.Windows.Controls.ContentControl]) {
            if ($el.Content -is [System.Windows.UIElement]) { $stack.Push($el.Content) }
        }
        elseif ($el -is [System.Windows.Controls.Panel]) {
            foreach ($child in $el.Children) { $stack.Push($child) }
        }
    }

    foreach ($btn in $buttons) {
        $btnText = $btn.Content -replace '^[^\w]+', '' -replace '^\s+', ''

        foreach ($key in $buttonMap.Keys) {
            if ($btnText -like "*$key*") {
                $cmdName = $buttonMap[$key]

                # Check if command exists
                try {
                    if (-not (Get-Command $cmdName -ErrorAction SilentlyContinue)) {
                        $btn.Visibility = "Collapsed"
                    }
                    else {
                        $handler = $clickMap[$key]
                        $btn.Add_Click($handler)
                    }
                }
                catch {
                    # If check fails, assume command unavailable
                    $btn.Visibility = "Collapsed"
                }
                break
            }
        }
    }
}
