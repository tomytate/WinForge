# WinForge Main Module Loader

# Initialize Logging (Core must be loaded via NestedModules)
if (Get-Command Start-ForgeLogging -ErrorAction SilentlyContinue) {
    Start-ForgeLogging
    Write-ForgeLog -Message "WinForge Module Initialized" -Level Debug
}
else {
    Write-Warning "WinForge: Core module not loaded. Logging unavailable."
}
