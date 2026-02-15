<#
.SYNOPSIS
    Recursively finds UI elements in a WPF visual tree.
#>
function Get-UIElement {
    [CmdletBinding()]
    [OutputType([System.Windows.UIElement[]])]
    param(
        [Parameter(ValueFromPipeline)]
        [System.Windows.UIElement]$Element,
        [Type]$Type = [System.Windows.Controls.Button],
        [switch]$Recurse
    )

    process {
        if ($Element -is $Type) { $Element }

        if ($Recurse -and $Element -is [System.Windows.Controls.Panel]) {
            foreach ($child in $Element.Children) {
                Get-UIElement -Element $child -Type $Type -Recurse
            }
        }
        elseif ($Recurse -and $Element -is [System.Windows.Controls.ContentControl]) {
            if ($Element.Content -is [System.Windows.UIElement]) {
                Get-UIElement -Element $Element.Content -Type $Type -Recurse
            }
        }
        elseif ($Recurse -and $Element -is [System.Windows.Controls.Decorator]) {
            if ($Element.Child) {
                Get-UIElement -Element $Element.Child -Type $Type -Recurse
            }
        }
    }
}
