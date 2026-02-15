<#
.SYNOPSIS
    Applies all Sysprep-compatible tweaks to the Default User hive.

.DESCRIPTION
    Mounts the Default User registry hive and applies all AI, privacy,
    and UI tweaks for OEM image deployment. This is a cross-cutting concern
    that calls into the Tweaks module functions with -ApplyToDefaultUser.

.EXAMPLE
    Invoke-ForgeSysprepDefaults
#>
function Invoke-ForgeSysprepDefaults {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    # Verify we're in Sysprep/Audit mode or user confirmed
    if (-not (Test-ForgeAuditMode)) {
        Write-ForgeLog -Message "Warning: Not in Audit Mode. Tweaks will apply to Default User anyway." -Level Warning
    }

    # Mount Default User hive
    if (-not (Mount-ForgeDefaultHive)) {
        Write-ForgeLog -Message "Failed to mount Default User hive" -Level Error
        return
    }

    try {
        Write-ForgeLog -Message "Applying Sysprep defaults to Default User..." -Level Info

        # Apply all AI tweaks
        Disable-ForgeAIRecall -ApplyToDefaultUser
        Disable-ForgeCopilot -ApplyToDefaultUser
        Disable-ForgeClickToDo -ApplyToDefaultUser
        Disable-ForgeNotepadAI -ApplyToDefaultUser
        Disable-ForgePaintAI -ApplyToDefaultUser

        # Apply privacy tweaks
        Disable-ForgeDesktopSpotlight -ApplyToDefaultUser
        Disable-ForgeSettings365Ads -ApplyToDefaultUser

        Write-ForgeLog -Message "Sysprep defaults applied successfully" -Level Success
    }
    finally {
        Dismount-ForgeDefaultHive
    }
}
