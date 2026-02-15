<#
.SYNOPSIS
    Returns the curated list of Microsoft telemetry domains.
.OUTPUTS
    [string[]] Array of domain names.
#>
function Get-ForgeTelemetryDomains {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    return @(
        "vortex.data.microsoft.com", "vortex-win.data.microsoft.com",
        "telecommand.telemetry.microsoft.com", "telecommand.telemetry.microsoft.com.nsatc.net",
        "oca.telemetry.microsoft.com", "oca.telemetry.microsoft.com.nsatc.net",
        "sqm.telemetry.microsoft.com", "sqm.telemetry.microsoft.com.nsatc.net",
        "watson.telemetry.microsoft.com", "watson.telemetry.microsoft.com.nsatc.net",
        "redir.metaservices.microsoft.com", "choice.microsoft.com",
        "choice.microsoft.com.nsatc.net", "df.telemetry.microsoft.com",
        "reports.wes.df.telemetry.microsoft.com", "wes.df.telemetry.microsoft.com",
        "services.wes.df.telemetry.microsoft.com", "sqm.df.telemetry.microsoft.com",
        "telemetry.microsoft.com", "watson.ppe.telemetry.microsoft.com",
        "telemetry.appex.bing.net", "telemetry.urs.microsoft.com",
        "settings-sandbox.data.microsoft.com", "vsgallery.com",
        "watson.live.com", "watson.microsoft.com",
        "statsfe2.ws.microsoft.com", "corpext.msitadfs.glbdns2.microsoft.com",
        "compatexchange.cloudapp.net", "cs1.wpc.v0cdn.net",
        "a-0001.a-msedge.net", "statsfe2.update.microsoft.com.akadns.net",
        "diagnostics.support.microsoft.com", "corp.sts.microsoft.com",
        "statsfe1.ws.microsoft.com", "pre.footprintpredict.com",
        "i1.services.social.microsoft.com", "feedback.windows.com",
        "feedback.microsoft-hohm.com", "feedback.search.microsoft.com"
    )
}
