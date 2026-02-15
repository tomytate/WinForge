<#
.SYNOPSIS
    Disables all AI features in Windows (Recall, Copilot, Click-to-Do, Notepad AI, Paint AI, Edge AI).
.DESCRIPTION
    Master function that calls all individual AI disable functions from the Tweaks module.
.EXAMPLE
    Disable-ForgeAI
#>
function Disable-ForgeAI {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param()

    Write-ForgeLog -Message "Disabling all AI features..." -Level Info

    Disable-ForgeAIRecall
    Disable-ForgeCopilot
    Disable-ForgeClickToDo
    Disable-ForgeNotepadAI
    Disable-ForgePaintAI
    Disable-ForgeEdgeAI

    Write-ForgeLog -Message "All AI features disabled" -Level Success
}
