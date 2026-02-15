param(
    [string]$SourceFile,
    [string]$OutputFile,
    [string]$Resource = "",
    [string]$Icon = ""
)

try {
    Write-Host "Compiling $SourceFile to $OutputFile..." -ForegroundColor Cyan
    if ($Resource) { Write-Host "   Embedding Resource: $Resource" -ForegroundColor Gray }
    
    if (-not (Test-Path $SourceFile)) { throw "Source file not found: $SourceFile" }
    
    # Locate CSC.exe (Classic .NET Framework)
    # This is usually robust on Windows
    $csc = Join-Path ([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()) "csc.exe"
    
    if (-not (Test-Path $csc)) {
        $csc = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
    }

    if (-not (Test-Path $csc)) {
        throw "C# Compiler (csc.exe) not found at $csc"
    }

    # /target:exe = Console App
    # /nologo = Quiet
    $compilerArgs = @("/target:exe", "/nologo", "/out:`"$OutputFile`"", "`"$SourceFile`"")
    
    if ($Resource) {
        $compilerArgs += "/resource:`"$Resource`""
    }
    
    # Add Compression Reference
    $compilerArgs += "/reference:System.IO.Compression.FileSystem.dll"
    $compilerArgs += "/reference:System.IO.Compression.dll"
    
    if ($Icon -and (Test-Path $Icon)) {
        Write-Host "   Adding Icon: $Icon" -ForegroundColor Gray
        $compilerArgs += "/win32icon:`"$Icon`""
    }
    
    $p = Start-Process -FilePath $csc -ArgumentList $compilerArgs -PassThru -Wait -NoNewWindow
    
    if ($p.ExitCode -ne 0) {
        throw "CSC Compilation failed with exit code $($p.ExitCode)."
    }
    
    if (Test-Path $OutputFile) {
        Write-Host "SUCCESS: Executable created." -ForegroundColor Green
    }
    else {
        throw "CSC finished but file is missing."
    }
}
catch {
    Write-Error "Compilation Failed: $($_.Exception.Message)"
    exit 1
}
