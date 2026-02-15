using System;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Reflection;

namespace WinForgeLauncher
{
    class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            string tempPath = Path.Combine(Path.GetTempPath(), "WinForge_" + Guid.NewGuid().ToString().Substring(0, 8));
            string zipPath = Path.Combine(tempPath, "payload.zip");

            try
            {
                // Create Temp Directory
                Directory.CreateDirectory(tempPath);

                // Extract Embedded Resource
                var assembly = Assembly.GetExecutingAssembly();
                using (Stream stream = assembly.GetManifestResourceStream("payload.zip")) // Resource name is just filename in csc
                {
                    if (stream == null)
                    {
                        // Fallback: try finding any resource ending in .zip
                        foreach (string name in assembly.GetManifestResourceNames())
                        {
                            if (name.EndsWith(".zip", StringComparison.OrdinalIgnoreCase))
                            {
                                using (Stream s2 = assembly.GetManifestResourceStream(name))
                                {
                                    using (FileStream fileStream = new FileStream(zipPath, FileMode.Create, FileAccess.Write))
                                    {
                                        s2.CopyTo(fileStream);
                                    }
                                }
                                break;
                            }
                        }
                    }
                    else
                    {
                        using (FileStream fileStream = new FileStream(zipPath, FileMode.Create, FileAccess.Write))
                        {
                            stream.CopyTo(fileStream);
                        }
                    }
                }

                if (!File.Exists(zipPath))
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("Critical Error: Payload not found in executable.");
                    Console.ResetColor();
                    Console.ReadKey();
                    return;
                }

                // Unzip
                Console.WriteLine("Extracting WinForge...");
                ZipFile.ExtractToDirectory(zipPath, tempPath);

                // Launch PowerShell
                string scriptPath = Path.Combine(tempPath, "WinForge.ps1");
                if (!File.Exists(scriptPath)) 
                {
                    // Maybe it's in a subdirectory "Stage_Standard" or similar?
                    // Search for it
                    string[] found = Directory.GetFiles(tempPath, "WinForge.ps1", SearchOption.AllDirectories);
                    if (found.Length > 0) scriptPath = found[0];
                }

                if (!File.Exists(scriptPath))
                {
                     Console.ForegroundColor = ConsoleColor.Red;
                     Console.WriteLine("Error: WinForge.ps1 not found in payload.");
                     Console.ResetColor();
                     Console.ReadKey();
                     return;
                }

                // Check for PowerShell Core (pwsh) and Version
                string pwshPath = "pwsh"; // Assume in PATH
                bool pwshValid = false;
                Version minVersion = new Version(7, 5, 4);

                try 
                {
                    ProcessStartInfo vPsi = new ProcessStartInfo(pwshPath, "-Version");
                    vPsi.UseShellExecute = false;
                    vPsi.RedirectStandardOutput = true;
                    vPsi.CreateNoWindow = true;

                    Process vP = Process.Start(vPsi);
                    string output = vP.StandardOutput.ReadToEnd();
                    vP.WaitForExit();

                    // Output format: "PowerShell 7.5.4"
                    if (output.StartsWith("PowerShell"))
                    {
                        string versionStr = output.Replace("PowerShell", "").Trim();
                        // Remove potential prerelease tags like "-preview.3" for simple parsing
                        if (versionStr.Contains("-")) versionStr = versionStr.Split('-')[0];
                        
                        Version currentVersion = new Version(versionStr);
                        if (currentVersion >= minVersion)
                        {
                            pwshValid = true;
                        }
                    }
                }
                catch 
                {
                    // PATH check failed, try standard location
                    string standardPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "PowerShell", "7", "pwsh.exe");
                    if (File.Exists(standardPath))
                    {
                        try
                        {
                            ProcessStartInfo vPsi = new ProcessStartInfo(standardPath, "-Version");
                            vPsi.UseShellExecute = false;
                            vPsi.RedirectStandardOutput = true;
                            vPsi.CreateNoWindow = true;

                            Process vP = Process.Start(vPsi);
                            string output = vP.StandardOutput.ReadToEnd();
                            vP.WaitForExit();

                            if (output.StartsWith("PowerShell"))
                            {
                                string versionStr = output.Replace("PowerShell", "").Trim();
                                if (versionStr.Contains("-")) versionStr = versionStr.Split('-')[0];
                                Version currentVersion = new Version(versionStr);
                                if (currentVersion >= minVersion)
                                {
                                    pwshPath = standardPath;
                                    pwshValid = true;
                                }
                            }
                        }
                        catch { /* Ignore invalid executable at standard path */ }
                    }
                }

                if (!pwshValid)
                {
                    Console.ForegroundColor = ConsoleColor.Yellow;
                    Console.WriteLine("PowerShell 7.5.4+ is required but not found (or too old).");
                    Console.WriteLine("Installing via Winget...");
                    Console.ResetColor();

                    // Run the install command via Winget
                    // We use cmd /c to ensure PATH resolution works for winget
                    var installPsi = new ProcessStartInfo
                    {
                        FileName = "cmd.exe",
                        Arguments = "/c winget install --id Microsoft.PowerShell --version 7.5.4 --accept-package-agreements --accept-source-agreements",
                        UseShellExecute = false
                    };
                    
                    try 
                    {
                        Process pInstall = Process.Start(installPsi);
                        pInstall.WaitForExit();
                    }
                    catch (Exception ex)
                    {
                        // Fallback to MSI if Winget fails?
                        // For now, report error as per user request flow
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine("Winget installation failed: " + ex.Message);
                        Console.WriteLine("Please install manually: winget install --id Microsoft.PowerShell --version 7.5.4");
                        Console.ReadKey();
                        return;
                    }

                    // Re-check after install (Blind trust or simple check)
                    try 
                    {
                         // We assume the installer put it in standard path or PATH
                         string standardPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "PowerShell", "7", "pwsh.exe");
                         if (File.Exists(standardPath)) 
                         {
                             pwshPath = standardPath;
                             pwshValid = true;
                         }
                         else
                         {
                             // Try PATH one last time
                             Process.Start(new ProcessStartInfo("pwsh", "-Version") { UseShellExecute = false, CreateNoWindow = true }).WaitForExit();
                             pwshPath = "pwsh";
                             pwshValid = true;
                         }
                    }
                    catch 
                    {
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine("Failed to detect PowerShell 7.5.4 after installation. Please restart the app.");
                        Console.ReadKey();
                        return;
                    }
                }

                ProcessStartInfo psi = new ProcessStartInfo();
                psi.FileName = pwshPath;
                psi.Arguments = string.Format("-NoProfile -ExecutionPolicy Bypass -File \"{0}\"", scriptPath);
                psi.UseShellExecute = false;
                
                Process p = Process.Start(psi);
                p.WaitForExit();

            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("Launcher Error: " + ex.Message);
                Console.WriteLine(ex.StackTrace);
                Console.ResetColor();
                Console.WriteLine("Press any key to exit...");
                Console.ReadKey();
            }
            finally
            {
                // Cleanup
                try 
                { 
                    if (Directory.Exists(tempPath)) 
                        Directory.Delete(tempPath, true); 
                } 
                catch { /* Best effort */ }
            }
        }
    }
}
