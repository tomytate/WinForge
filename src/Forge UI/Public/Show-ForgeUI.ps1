<#
.SYNOPSIS
    Launches the WinForge WPF graphical user interface.
.DESCRIPTION
    Creates and shows a WPF window with the WinForge dashboard.
    Requires running on Windows with WPF assemblies available.
#>
function Show-ForgeUI {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase -ErrorAction Stop

    $xamlPath = "$PSScriptRoot\..\Views\MainWindow.xaml"
    if (Test-Path $xamlPath) {
        $xaml = Get-Content $xamlPath -Raw
        $reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xaml))
        $window = [System.Windows.Markup.XamlReader]::Load($reader)
        Register-ForgeUIHandler -Window $window
        $window.ShowDialog() | Out-Null
    }
    else {
        # Inline minimal XAML if view file missing
        [xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="WinForge v1.0.0" Width="1024" Height="720"
        WindowStartupLocation="CenterScreen"
        Background="#1E1E2E" Foreground="White"
        FontFamily="Segoe UI">
    <Grid Margin="20">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <TextBlock Grid.Row="0" Text="⚒ WinForge" FontSize="28" FontWeight="Bold"
                   Foreground="#2196F3" Margin="0,0,0,20"/>

        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
            <WrapPanel>
                <Button Content="🗑 Remove Bloatware" Width="200" Height="60" Margin="5"
                        Background="#FF9800" Foreground="White" FontSize="14"/>
                <Button Content="🔒 Privacy Hardening" Width="200" Height="60" Margin="5"
                        Background="#9C27B0" Foreground="White" FontSize="14"/>
                <Button Content="⚡ Performance" Width="200" Height="60" Margin="5"
                        Background="#00BCD4" Foreground="White" FontSize="14"/>
                <Button Content="🎮 Gaming Mode" Width="200" Height="60" Margin="5"
                        Background="#E91E63" Foreground="White" FontSize="14"/>
                <Button Content="🌐 Network/DNS" Width="200" Height="60" Margin="5"
                        Background="#3F51B5" Foreground="White" FontSize="14"/>
                <Button Content="🤖 AI Nuke" Width="200" Height="60" Margin="5"
                        Background="#F44336" Foreground="White" FontSize="14"/>
                <Button Content="🔧 Repair System" Width="200" Height="60" Margin="5"
                        Background="#607D8B" Foreground="White" FontSize="14"/>
                <Button Content="📸 Create Snapshot" Width="200" Height="60" Margin="5"
                        Background="#795548" Foreground="White" FontSize="14"/>
                <Button Content="📊 Benchmark" Width="200" Height="60" Margin="5"
                        Background="#673AB7" Foreground="White" FontSize="14"/>
                <Button Content="📄 View Log" Width="200" Height="60" Margin="5"
                        Background="#607D8B" Foreground="White" FontSize="14"/>        
            </WrapPanel>
        </ScrollViewer>

        <TextBlock Grid.Row="2" Text="WinForge v1.0.0 — The Windows Forge"
                   Foreground="#78909C" FontSize="11" Margin="0,10,0,0"/>
    </Grid>
</Window>
"@

        $reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xaml.OuterXml))
        $window = [System.Windows.Markup.XamlReader]::Load($reader)
        Register-ForgeUIHandler -Window $window
        $window.ShowDialog() | Out-Null
    }
}

