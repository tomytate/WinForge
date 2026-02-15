function AvoidImplicitJsonDate {
    <#
    .SYNOPSIS
        Checks for ConvertFrom-Json usage without the -DateKind parameter.
    
    .DESCRIPTION
        PowerShell 7.5 introduced the -DateKind parameter for ConvertFrom-Json to control how dates are parsed.
        Omitting this parameter can lead to automatic date conversion, which may be undesirable (legacy behavior).
        This rule enforces explicit usage of -DateKind (Json or Strings) to ensure predictable behavior.

    .notes
        Name: AvoidImplicitJsonDate
        Severity: Warning
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.Language.ScriptBlockAst])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.Language.ScriptBlockAst] $Ast
    )

    Process {
        # Find all CommandAsts calling ConvertFrom-Json
        $commands = $Ast.FindAll(
            {
                param($ast)
                $ast -is [System.Management.Automation.Language.CommandAst] -and
                $ast.GetCommandName() -eq 'ConvertFrom-Json'
            },
            $true
        )

        foreach ($cmd in $commands) {
            # Check if DateKind parameter is present
            $hasDateKind = $false
            foreach ($element in $cmd.CommandElements) {
                if ($element -is [System.Management.Automation.Language.CommandParameterAst]) {
                    if ($element.ParameterName -eq 'DateKind') {
                        $hasDateKind = $true
                        break
                    }
                }
            }

            if (-not $hasDateKind) {
                $ext = $cmd.Extent
                [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "ConvertFrom-Json is missing the '-DateKind' parameter. Specify '-DateKind Json' (recommended) or '-DateKind Strings' to prevent ambiguous date parsing in PowerShell 7.5+."
                    Extent   = $ext
                    RuleName = "AvoidImplicitJsonDate"
                    Severity = "Warning"
                }
            }
        }
    }
}
