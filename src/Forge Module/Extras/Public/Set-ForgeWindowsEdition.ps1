<#
.SYNOPSIS
    Changes Windows Edition (e.g., Home to Pro).
    [EXTRAS EDITION ONLY]
.DESCRIPTION
    Upgrades Windows Edition using DISM and Generic Keys.
    Supports offline upgrade (no internet required for the switch, but activation needed after).
.PARAMETER Edition
    Target Edition: Professional, Enterprise, Education, etc.
.EXAMPLE
    Set-ForgeWindowsEdition -Edition Professional
#>
function Set-ForgeWindowsEdition {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Professional", "ProfessionalN", "Enterprise", "EnterpriseN", "Education", "EducationN")]
        [string]$Edition
    )

    if ($PSCmdlet.ShouldProcess("Windows", "Change Edition to $Edition")) {
        Write-ForgeLog -Message "Starting Edition Upgrade to $Edition..." -Level Warning

        # 1. Check current edition
        $current = (Get-CimInstance Win32_OperatingSystem).Caption
        Write-ForgeLog -Message "Current Edition: $current" -Level Info

        # 2. Get Upgrade Key
        $jsonPath = Join-Path $PSScriptRoot "..\Data\edition-upgrades.json"
        if (-not (Test-Path $jsonPath)) { throw "Data file missing: $jsonPath" }
        $data = Get-Content $jsonPath -Raw | ConvertFrom-Json -DateKind Json
        $keyObj = $data.GenericKeys | Where-Object { $_.Edition -eq $Edition }
        
        if (-not $keyObj) {
            Write-Error "No upgrade key found for $Edition"
            return
        }

        $key = $keyObj.Key
        Write-ForgeLog -Message "Using Generic Key: $key" -Level Info

        # 3. Use DISM /Set-Edition (Preferred)
        # Check if target is in TargetEditions
        $targets = try { Dism /Online /Get-TargetEditions } catch { @() }
        
        if ($targets -match $Edition) {
            Write-ForgeLog -Message "Using DISM..." -Level Info
            Dism /Online /Set-Edition:$Edition /ProductKey:$key /AcceptEula
        }
        else {
            # Fallback to slmgr /ipk
            Write-ForgeLog -Message "DISM Target not listed. Trying slmgr key install..." -Level Info
            cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /ipk $key
        }
        
        Write-ForgeLog -Message "Edition Change Initiated. Check System Settings." -Level Success
        Write-Warning "A restart is usually required to complete the edition change."
    }
}
