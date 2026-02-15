<#
.SYNOPSIS
    Formats output text with consistent styling for WinForge console output.

.DESCRIPTION
    Internal helper — provides consistent text formatting for section headers,
    separators, and status messages across the CLI and TUI.

.PARAMETER Text
    The text to format.

.PARAMETER Style
    The style to apply: Header, Separator, Status, Result.
#>
function Format-ForgeOutput {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Console formatting by design')]
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string]$Text,

        [ValidateSet("Header", "Separator", "Status", "Result")]
        [string]$Style = "Status"
    )

    switch ($Style) {
        'Header' {
            Write-Host ""
            Write-Host "  $Text" -ForegroundColor Cyan
            Write-Host ("  " + "─" * ($Text.Length + 2)) -ForegroundColor DarkCyan
        }
        'Separator' {
            Write-Host ("  " + "─" * 60) -ForegroundColor DarkGray
        }
        'Status' {
            Write-Host "  ► $Text" -ForegroundColor Gray
        }
        'Result' {
            Write-Host "  ✓ $Text" -ForegroundColor Green
        }
    }
}
