<#
.SYNOPSIS
    WinForge Extras Module
.DESCRIPTION
    Advanced tools: Defender Remover, Microsoft Activation Scripts (MAS).
    These are risky/AV-flagged tools exclusive to the Extras edition.
.NOTES
    Module: Forge.Extras
    Version: 1.0.0
#>
#Requires -Version 7.5

$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue)
$Public = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"  -ErrorAction SilentlyContinue)
foreach ($file in @($Private + $Public)) {
    try { . $file.FullName } catch { Write-Error "Failed to load $($file.FullName): $_" }
}
Export-ModuleMember -Function $Public.BaseName
