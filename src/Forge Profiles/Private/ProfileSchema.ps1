# Profile Schema definition for validation (SEC-004 fix)
<#
.SYNOPSIS
    Defines the validation schema for Forge Profiles.
.DESCRIPTION
    Contains the rules and allowed values for verifying profile integrity.
#>
$Script:ProfileSchema = @{
    Required             = @('metadata')
    MetadataRequired     = @('name', 'version')
    ValidSections        = @('metadata', 'bloatware', 'privacy', 'performance', 'network', 'software')
    ValidTelemetryLevels = @('Security', 'Basic', 'Full')
    ValidPowerPlans      = @('Balanced', 'HighPerformance', 'Ultimate')
    ValidRemovalModes    = @('None', 'Conservative', 'Moderate', 'Aggressive', 'Custom')
}
