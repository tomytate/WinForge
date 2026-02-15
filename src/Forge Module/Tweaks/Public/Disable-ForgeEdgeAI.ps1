<#
.SYNOPSIS
    Auto-generated synopsis for Disable-ForgeEdgeAI.
.DESCRIPTION
    This function was identified as missing documentation during the audit.
#>
function Disable-ForgeEdgeAI {
    [CmdletBinding()]
    param()

    $edgePolicies = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    Set-ForgeRegistryValue -Path $edgePolicies -Name "CopilotCDPPageContext" -Type "DWord" -Value 0
    Set-ForgeRegistryValue -Path $edgePolicies -Name "DiscoverPageContextEnabled" -Type "DWord" -Value 0
    Set-ForgeRegistryValue -Path $edgePolicies -Name "HubsSidebarEnabled" -Type "DWord" -Value 0
    Write-ForgeLog -Message "Edge AI features disabled" -Level Success
}

