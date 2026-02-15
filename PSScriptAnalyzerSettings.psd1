@{
    # PSScriptAnalyzer Settings for WinForge
    # Enforces PowerShell 7.5 compatibility and custom robustness rules.

    # 1. Custom Rules
    # CustomRulePath is passed via Invoke-ScriptAnalyzer arguments to support dynamic paths.


    # 2. Included Rules (Allowlist)
    # We choose specific rules to enforce quality without noise.
    IncludeRules = @(
        'PSUseCompatibleCmdlets',         # Enforce PS Version compatibility
        'AvoidImplicitJsonDate',          # Custom: Enforce -DateKind Json
        'PSAvoidUsingWriteHost',          # Use $PSStyle or Write-Output (except TUI)
        'PSUseDeclaredVarsMoreThanAssignments', # Detect unused variables
        'PSAvoidImplicitObjectCreation',  # Detect accidental pipeline output
        'PSUseConsistentWhitespace',      # Enforce formatting
        'PSAvoidUsingInvokeExpression',   # Security: Avoid Invoke-Expression
        'PSAvoidUsingPlainTextForPassword' # Security: Passwords
    )

    # 3. Rule Configuration
    Rules        = @{
        # Enforce PowerShell Core 7.5 compatibility
        PSUseCompatibleCmdlets = @{
            Compatibility = @("core-7.5.0")
        }
    }

    # 4. Exclusions (Suppression)
    # File-specific suppressions should ideally be inline, but global ones go here.
    # We exclude Write-Host check for the CLI/TUI components where it's intentional.
    ExcludeRules = @()
}
