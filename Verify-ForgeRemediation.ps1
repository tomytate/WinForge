$filesToCheckJSON = @(
    "src\Forge Module\Bloatware\Public\Get-ForgeBloatwareList.ps1",
    "src\Forge Module\Extras\Public\Enable-ForgeWindowsActivation.ps1",
    "src\Forge Module\Extras\Public\Invoke-ForgeDefenderRemover.ps1",
    "src\Forge Module\Extras\Public\Set-ForgeWindowsEdition.ps1",
    "src\Forge Module\Network\Public\Get-ForgeDNSProviders.ps1",
    "src\Forge Module\Performance\Public\Set-ForgeServices.ps1",
    "src\Forge Module\Performance\Public\Get-ForgeServicePresets.ps1",
    "src\Forge Module\Performance\Public\Compare-ForgeBenchmarks.ps1"
)

Write-Host "Verifying JSON Robustness..." -ForegroundColor Cyan
foreach ($file in $filesToCheckJSON) {
    if (Test-Path "w:\Documents\WinForge\$file") {
        $content = Get-Content "w:\Documents\WinForge\$file" -Raw
        if ($content -match "-DateKind Json") {
            Write-Host "[PASS] $file" -ForegroundColor Green
        }
        else {
            Write-Host "[FAIL] $file (Missing -DateKind Json)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[FAIL] File not found: $file" -ForegroundColor Red
    }
}

Write-Host "`nVerifying Extensions..." -ForegroundColor Cyan
$logFile = "w:\Documents\WinForge\src\Forge Module\Extras\Private\Write-ForgeLog.ps1"
if (Test-Path $logFile) {
    $content = Get-Content $logFile -Raw
    if ($content -match "PSStyle" -and $content -notmatch "Write-Host.*-ForegroundColor") {
        Write-Host "[PASS] Write-ForgeLog ($PSStyle used)" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] Write-ForgeLog (Legacy colors found or PSStyle missing)" -ForegroundColor Red
    }
}

$benchFile = "w:\Documents\WinForge\src\Forge Module\Performance\Public\Measure-ForgeSystem.ps1"
if (Test-Path $benchFile) {
    $content = Get-Content $benchFile -Raw
    if ($content -match "ForEach-Object -Parallel") {
        Write-Host "[PASS] Measure-ForgeSystem (Parallelized)" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] Measure-ForgeSystem (Parallel missing)" -ForegroundColor Red
    }
}

$sdioFile = "w:\Documents\WinForge\src\Forge Module\Integrations\Public\Update-ForgeSDIO.ps1"
if (Test-Path $sdioFile) {
    $content = Get-Content $sdioFile -Raw
    if ($content -match "Write-Warning.*external batch file") {
        Write-Host "[PASS] Update-ForgeSDIO (Warning added)" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] Update-ForgeSDIO (Warning missing)" -ForegroundColor Red
    }
}

$activationFile = "w:\Documents\WinForge\src\Forge Module\Extras\Public\Get-ForgeActivationStatus.ps1"
if (Test-Path $activationFile) {
    $content = Get-Content $activationFile -Raw
    if ($content -match "PSCustomObject") {
        Write-Host "[PASS] Get-ForgeActivationStatus (Returns Object)" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] Get-ForgeActivationStatus (Object missing)" -ForegroundColor Red
    }
}
