Write-Host "_____________________________________________________________"
Write-Host ""
Write-Host "      Welcome to Kimsec.net Easy Installer & Tweaks" -ForegroundColor Cyan
Write-Host "_____________________________________________________________"
Write-Host ""
# Import necessary modules for GUI
Add-Type -AssemblyName PresentationFramework

# Function to download NVIDIA App
function Download-NvidiaApp {
    try {
        Write-Host "Trying to find latest NVIDIA App version..." -ForegroundColor Yellow
        
        # Try to get the latest version from NVIDIA's API or page
        $response = Invoke-WebRequest -Uri 'https://www.nvidia.com/en-us/software/nvidia-app/' -UseBasicParsing -TimeoutSec 10
        $downloadLinks = $response.Content | Select-String -Pattern 'https://[^"]*\.download\.nvidia\.com/nvapp/client/[^"]*\.exe' -AllMatches
        
        if ($downloadLinks.Matches.Count -gt 0) {
            $latestLink = $downloadLinks.Matches[0].Value
            Write-Host "Found latest version: $latestLink" -ForegroundColor Green
            Invoke-WebRequest -Uri $latestLink -OutFile "$env:USERPROFILE\Downloads\NVIDIA_App.exe"
            return $true
        }
    }
    catch {
        Write-Host "Could not find latest version, using fallback..." -ForegroundColor Yellow
    }
    
    # Fallback to known version
    try {
        Write-Host "Downloading NVIDIA App (fallback version)..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri 'https://uk.download.nvidia.com/nvapp/client/11.0.5.245/NVIDIA_app_v11.0.5.245.exe' -OutFile "$env:USERPROFILE\Downloads\NVIDIA_App.exe"
        return $true
    }
    catch {
        Write-Host "Failed to download NVIDIA App: $_" -ForegroundColor Red
        return $false
    }
}

$programs = @(
    [PSCustomObject]@{ Name = "Plex"; Command = "winget install --id=Plex.Plex" },
    [PSCustomObject]@{ Name = "Discord"; Command = "winget install --id=Discord.Discord" },
    [PSCustomObject]@{ Name = "Auto Accept For CS2"; Command = "Invoke-WebRequest -Uri 'https://github.com/kimsec/AutoAccept-CS2/releases/latest/download/AutoAccept.exe' -OutFile '$env:USERPROFILE\Documents\AutoAccept.exe'" },
    [PSCustomObject]@{ Name = "NVIDIA App"; Command = "Download-NvidiaApp" },
    [PSCustomObject]@{ Name = "Spotify"; Command = "winget install --id=Spotify.Spotify" },
    [PSCustomObject]@{ Name = "OBS Studio"; Command = "winget install --id=OBSProject.OBSStudio" },
    [PSCustomObject]@{ Name = "LM Studio"; Command = "winget install --id=ElementLabs.LMStudio" },
    [PSCustomObject]@{ Name = "VLC Media Player"; Command = "winget install --id=VideoLAN.VLC" },
    [PSCustomObject]@{ Name = "Steelseries GG"; Command = "winget install --id=SteelSeries.GG" },
    [PSCustomObject]@{ Name = "Logitech G Hub"; Command = "winget install --id=Logitech.GHUB" },
    [PSCustomObject]@{ Name = "Razer Synapse"; Command = "winget install --id=RazerInc.RazerInstaller4" },
    [PSCustomObject]@{ Name = "Roccat Swarm"; Command = "winget install --id=TurtleBeach.ROCCATSwarm" },
    [PSCustomObject]@{ Name = "Ookla Speedtest"; Command = "winget install --id=Ookla.Speedtest.Desktop" },
	[PSCustomObject]@{ Name = "LocalSend"; Command = "winget install --id=Ookla.LocalSend.LocalSend" },
    [PSCustomObject]@{ Name = "HWMonitor"; Command = "winget install --id=CPUID.HWMonitor" }
)

$browsers = @(
    [PSCustomObject]@{ Name = "Google Chrome"; Command = "winget install --id=Google.Chrome" },
    [PSCustomObject]@{ Name = "Mozilla Firefox"; Command = "winget install --id=Mozilla.Firefox" },
    [PSCustomObject]@{ Name = "Opera"; Command = "winget install --id=Opera.Opera" },
    [PSCustomObject]@{ Name = "Opera GX"; Command = "winget install --id=Opera.OperaGX" },
    [PSCustomObject]@{ Name = "Safari"; Command = "winget install --id=Apple.Safari" },
    [PSCustomObject]@{ Name = "Brave Browser"; Command = "winget install --id=Brave.Brave" },
    [PSCustomObject]@{ Name = "Vivaldi"; Command = "winget install --id=Vivaldi.Vivaldi" },
    [PSCustomObject]@{ Name = "Zen Browser"; Command = "winget install --id=Zen-Team.Zen-Browser" },
    [PSCustomObject]@{ Name = "Tor Browser"; Command = "winget install --id=TorProject.TorBrowser" }
)

$games = @(
    [PSCustomObject]@{ Name = "Steam"; Command = "winget install --id=Valve.Steam" },
    [PSCustomObject]@{ Name = "Battle.net"; Command = "winget install --id=Blizzard.BattleNet" },
    [PSCustomObject]@{ Name = "Epic Games Launcher"; Command = "winget install --id=EpicGames.EpicGamesLauncher" },
    [PSCustomObject]@{ Name = "Roblox"; Command = "winget install --id=Roblox.Roblox" },
    [PSCustomObject]@{ Name = "Minecraft Launcher"; Command = "winget install --id=Mojang.MinecraftLauncher" },
    [PSCustomObject]@{ Name = "Ubisoft Connect"; Command = "winget install --id=Ubisoft.Connect" },
    [PSCustomObject]@{ Name = "EA App"; Command = "winget install --id=ElectronicArts.EADesktop" },
    [PSCustomObject]@{ Name = "Jagex Launcher"; Command = "winget install --id=Jagex.Runescape" },
    [PSCustomObject]@{ Name = "GOG Galaxy"; Command = "winget install --id=GOG.Galaxy" },
    [PSCustomObject]@{ Name = "Valorant (EU)"; Command = "winget install --id=RiotGames.Valorant.EU" },
    [PSCustomObject]@{ Name = "LoL (EUW)"; Command = "winget install --id=RiotGames.LeagueOfLegends.EUW" },
    [PSCustomObject]@{ Name = "Itch.io"; Command = "winget install --id=ItchIo.Itch" },
    [PSCustomObject]@{ Name = "CurseForge"; Command = "winget install --id=Overwolf.CurseForge" }
)

$tools = @(
    [PSCustomObject]@{ Name = "PowerShell 7"; Command = "winget install --id=Microsoft.PowerShell" },    
    [PSCustomObject]@{ Name = "Wireguard VPN"; Command = "winget install --id=WireGuard.WireGuard" },
    [PSCustomObject]@{ Name = "Cinebench R23"; Command = "winget install --id=Maxon.CinebenchR23" },
    [PSCustomObject]@{ Name = "Heaven Benchmark"; Command = "winget install --id=Unigine.HeavenBenchmark" },
    [PSCustomObject]@{ Name = "Raspberry Pi Imager"; Command = "winget install --id=RaspberryPiFoundation.RaspberryPiImager" },
    [PSCustomObject]@{ Name = "Dolby Digital Codecs"; Command = "winget install --id=9NVJQJBDKN97" },
    [PSCustomObject]@{ Name = "Balena Etcher"; Command = "winget install --id=Balena.Etcher" },
    [PSCustomObject]@{ Name = "Ultimaker Cura"; Command = "winget install --id=Ultimaker.Cura" },
	[PSCustomObject]@{ Name = "Tailscale"; Command = "winget install --id=Tailscale.Tailscale" },
    [PSCustomObject]@{ Name = "Handbrake"; Command = "winget install --id=HandBrake.HandBrake" },
    [PSCustomObject]@{ Name = "Maltego"; Command = "winget install --id=Maltego.Maltego" },
    [PSCustomObject]@{ Name = "MS PowerToys"; Command = "winget install --id=Microsoft.PowerToys" },
    [PSCustomObject]@{ Name = "WinRAR"; Command = "winget install --id=RARLab.WinRAR" },
    [PSCustomObject]@{ Name = "Alt Drag/Snap"; Command = "winget install --id=AltSnap.AltSnap" },
	[PSCustomObject]@{ Name = "Revo Uninstaller"; Command = "winget install --id=RevoUninstaller.RevoUninstaller" }
)

$editing = @(
    [PSCustomObject]@{ Name = "Blender 3D"; Command = "winget install --id=BlenderFoundation.Blender" },
    [PSCustomObject]@{ Name = "Notepad++"; Command = "winget install --id=Notepad++.Notepad++" },
    [PSCustomObject]@{ Name = "Microsoft VSCode"; Command = "winget install --id=Microsoft.VisualStudioCode" },
    [PSCustomObject]@{ Name = "Gimp (Photoshop)"; Command = "winget install --id=GIMP.GIMP.Nightly" },
    [PSCustomObject]@{ Name = "CapCut"; Command = "winget install --id=ByteDance.CapCut" },
    [PSCustomObject]@{ Name = "LibreOffice"; Command = "winget install --id=TheDocumentFoundation.LibreOffice" },
    [PSCustomObject]@{ Name = "Google Drive"; Command = "winget install --id=Google.GoogleDrive" },
    [PSCustomObject]@{ Name = "InkScape"; Command = "winget install --id=Inkscape.Inkscape" }
)

$tweaks = @(
    [PSCustomObject]@{
        Name = "Remove Bing Search from Menu"
        Command = "reg add 'HKCU\Software\Policies\Microsoft\Windows\Explorer' /v 'DisableSearchBoxSuggestions' /t REG_DWORD /d 1 /f; " +
                  "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Search' /v 'BingSearchEnabled' /t REG_DWORD /d 0 /f; " +
                  "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Search' /v 'CortanaConsent' /t REG_DWORD /d 0 /f"
    },
    [PSCustomObject]@{
        Name = "Windows Dark Mode"
        Command = 'Start-Process -FilePath "$env:SystemRoot\Resources\Themes\dark.theme"'
    },
    [PSCustomObject]@{
        Name = "Rename Your PC"
        Command = 'Start-Process ms-settings:about; Start-Process "C:\WINDOWS\system32\SystemSettingsAdminFlows.exe" RenamePC'
    },
    [PSCustomObject]@{
        Name = "Disable Transparency Effects"
        Command = "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' /v 'EnableTransparency' /t REG_DWORD /d 0 /f"
    },
    [PSCustomObject]@{
        Name = "Delete Temporary Files/Folders"
        Command = 'Get-ChildItem -Path "C:\Windows\Temp" -Filter *.* -Recurse | Remove-Item -Force; Get-ChildItem -Path $env:TEMP -Filter *.* -Recurse | Remove-Item -Force'
    },
    [PSCustomObject]@{
        Name = "Classic Right-Click Menu"
        Command = @"
reg add 'HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}' /f;
reg add 'HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' /f;
Stop-Process -Name explorer -Force
"@
    },
    [PSCustomObject]@{
        Name = "Standard Right-Click Menu"
        Command = @'
Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Recurse -Confirm:$false -Force;
Stop-Process -Name explorer -Force
'@
    },
    [PSCustomObject]@{
        Name = "Fast Visual Responsiveness"
        Command = @"
reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' /v 'VisualFXSetting' /t REG_DWORD /d 3 /f

# bitmasken for user preferences (brukerdefinert oppsett):
reg add 'HKCU\Control Panel\Desktop' /v 'UserPreferencesMask' /t REG_BINARY /d '90120000' /f

# Ikke animere ved minimering / maksimering
reg add 'HKCU\Control Panel\Desktop\WindowMetrics' /v 'MinAnimate' /t REG_SZ /d '0' /f

# Slå av skygger under ikonetiketter
reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v 'ListviewShadow' /t REG_DWORD /d 0 /f

# Slå av vindus-skygger
reg add 'HKCU\Software\Microsoft\Windows\DWM' /v 'EnableWindowShadow' /t REG_DWORD /d 0 /f

# Slå av skygge under musepekeren
reg add 'HKCU\Control Panel\Cursors' /v 'EnablePointerShadow' /t REG_DWORD /d 0 /f

# Hindre Windows i å beholde thumbnails i minnet
reg add 'HKCU\Software\Microsoft\Windows\DWM' /v 'AlwaysHibernateThumbnails' /t REG_DWORD /d 1 /f

# Slå av fade-effekt ved markeringsboks
reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' /v 'SelectionFade' /t REG_SZ /d '0' /f

# Slå av understrek for ikoner
reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' /v 'IconUnderline' /t REG_SZ /d '0' /f

# UserPreferencesMask - generelt 'slå av' en rekke effekter
reg add 'HKCU\Control Panel\Desktop' /v 'UserPreferencesMask' /t REG_BINARY /d '9812000010000000' /f

# Vis menyer umiddelbart
reg add 'HKCU\Control Panel\Desktop' /v 'MenuShowDelay' /t REG_SZ /d '0' /f

# Start Explorer på nytt (valgfritt for rask effekt):
taskkill /F /IM explorer.exe
start explorer.exe
"@
    },
    [PSCustomObject]@{ 
        Name = "AutoLogin" 
        Command = "Invoke-WebRequest -Uri 'https://live.sysinternals.com/Autologon.exe' -OutFile '$env:temp\autologin.exe'; Start-Process -FilePath '$env:temp\autologin.exe' /accepteula -Wait"
    },
    [PSCustomObject]@{ 
        Name = "Disable Mouse Acceleration"
        Command = "reg add 'HKCU\Control Panel\Mouse' /v 'MouseSpeed' /t REG_SZ /d '0' /f; " +
                  "reg add 'HKCU\Control Panel\Mouse' /v 'MouseThreshold1' /t REG_SZ /d '0' /f; " +
                  "reg add 'HKCU\Control Panel\Mouse' /v 'MouseThreshold2' /t REG_SZ /d '0' /f"
    }
)

$repair = @(
    [PSCustomObject]@{
        Name = "Search for Corrupted Files"
        Command = 'Start-Transcript -Path "$env:USERPROFILE\Desktop\SFC_Scan_Report.txt" -Append; sfc /scannow; Stop-Transcript'
    },
    [PSCustomObject]@{
        Name = "DISM Restore Health"
        Command = 'Start-Transcript -Path "$env:USERPROFILE\Desktop\DISM_Report.txt" -Append; DISM.exe /Online /Cleanup-Image /RestoreHealth; Stop-Transcript'
    },
    [PSCustomObject]@{
        Name = "Scan Drive For Errors"
        Command = 'Start-Transcript -Path "$env:USERPROFILE\Desktop\Drive_Error_Report.txt" -Append; chkdsk C: /scan; Stop-Transcript'
    },
    [PSCustomObject]@{
        Name = "Troubleshooter"
        Command = 'Start-Process "ms-settings:troubleshoot"'
    },
    [PSCustomObject]@{
        Name = "Disk Cleanup"
        Command = 'cleanmgr.exe /d C: /VERYLOWDISK; Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase'
    },
    [PSCustomObject]@{
        Name = "Full Scan & Repair (RECOMMENDED)"
        Command = @"
Write-Host '(1/4) Chkdsk' -ForegroundColor Green; Chkdsk  /scan;
Write-Host '`n(2/4) SFC' -ForegroundColor Green; sfc /scannow;
Write-Host '`n(3/4) DISM' -ForegroundColor Green; DISM /Online /Cleanup-Image /Restorehealth;
Write-Host '`n(4/4) SFC' -ForegroundColor Green; sfc /scannow;
Read-Host '`nPress Enter to Continue'"
"@
    },
    [PSCustomObject]@{
        Name = "Display Driver Uninstaller (DDU)"
        Command = "winget install --id=Wagnardsoft.DisplayDriverUninstaller"
    }
)


# --- 2) Opprett XAML for vinduet med 4 kolonner ---

[xml]$MsgXAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="CustomMessageBox" 
        SizeToContent="WidthAndHeight"
        WindowStartupLocation="CenterOwner"
        WindowStyle="None" 
        AllowsTransparency="True"
        Background="Transparent">
    <Border Background="#1E1E1E" 
            CornerRadius="10" 
            BorderBrush="#333333" 
            BorderThickness="2" 
            Padding="20">
        <StackPanel>
            <TextBlock x:Name="MessageText" 
                       TextWrapping="Wrap" 
                       Foreground="#cccccc" 
                       Margin="0,0,0,0" 
                       FontSize="14"
                       HorizontalAlignment="Center"/>
            <Button x:Name="OkButton" 
                    Content="OK" 
                    Width="100" 
                    Height="30" 
                    Background="#161616" 
                    Foreground="#cccccc" 
                    HorizontalAlignment="Center"
                    Margin="0,30,0,10">
                <Button.Template>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" 
                                CornerRadius="5" 
                                BorderThickness="0">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Button.Template>
            </Button>
        </StackPanel>
    </Border>
</Window>
"@

[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Made By Kimsec.net" 
        Height="500" Width="900" 
        WindowStartupLocation="CenterScreen"
        Background="Transparent" Foreground="#cccccc"
        WindowStyle="None" AllowsTransparency="True">

    <Border Background="#1E1E1E" CornerRadius="10" Padding="10" BorderBrush="#333333" BorderThickness="2">
      <TabControl Name="MainTabControl" Background="Transparent" BorderThickness="0">
        <TabControl.Resources>
            <!-- Stil for TabItems med runde kanter -->
            <Style TargetType="TabItem">
                <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
                <Setter Property="Foreground" Value="#cccccc"/>
                <Setter Property="Padding" Value="10,5"/>
                <Setter Property="Margin" Value="2"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="TabItem">
                            <Border x:Name="Bd" Background="#2E2E2E" CornerRadius="10,10,0,0" BorderThickness="1" BorderBrush="#333333" Padding="{TemplateBinding Padding}">
                                <ContentPresenter x:Name="Content" ContentSource="Header" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            </Border>
                            <ControlTemplate.Triggers>
                                <Trigger Property="IsSelected" Value="True">
                                    <Setter TargetName="Bd" Property="Background" Value="#1E1E1E"/>
                                    <Setter Property="Foreground" Value="#cccccc"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter TargetName="Bd" Property="Background" Value="#1E1E1E"/>
                                </Trigger>
                            </ControlTemplate.Triggers>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
        </TabControl.Resources>
        <!-- Installer Tab (backup red color: #b50000 -->
        <TabItem Header="Installer">
            <Grid Margin="10">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <!-- Programmer -->
                <StackPanel Grid.Column="0" Margin="0,10,10,0">
                    <TextBlock Text="Programs" FontSize="18" Margin="0,0,0,10" FontWeight="Bold"/>
                    <ListBox Name="ProgramList" SelectionMode="Multiple" Height="330" Background="#161616" Foreground="White" FocusVisualStyle="{x:Null}">
                        <ListBox.ItemTemplate>
                            <DataTemplate>
                                <CheckBox Content="{Binding Name}" 
                                          IsChecked="{Binding RelativeSource={RelativeSource AncestorType=ListBoxItem}, Path=IsSelected, Mode=TwoWay}" 
                                          Foreground="#cccccc"
                                          Margin="0,1"/>
                            </DataTemplate>
                        </ListBox.ItemTemplate>
                    </ListBox>
                </StackPanel>
                <!-- Nettlesere -->
                <StackPanel Grid.Column="1" Margin="10">
                    <TextBlock Text="Web Browsers" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                    <ListBox Name="BrowserList" SelectionMode="Multiple" Height="330" Background="#161616" Foreground="White">
                        <ListBox.ItemTemplate>
                            <DataTemplate>
                                <CheckBox Content="{Binding Name}" 
                                          IsChecked="{Binding RelativeSource={RelativeSource AncestorType=ListBoxItem}, Path=IsSelected, Mode=TwoWay}" 
                                          Foreground="#cccccc"
                                          Margin="0,1"/>
                            </DataTemplate>
                        </ListBox.ItemTemplate>
                    </ListBox>
                </StackPanel>
                <!-- Spill -->
                <StackPanel Grid.Column="2" Margin="10">
                    <TextBlock Text="Games" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                    <ListBox Name="GameList" SelectionMode="Multiple" Height="330" Background="#161616" Foreground="White">
                        <ListBox.ItemTemplate>
                            <DataTemplate>
                                <CheckBox Content="{Binding Name}" 
                                          IsChecked="{Binding RelativeSource={RelativeSource AncestorType=ListBoxItem}, Path=IsSelected, Mode=TwoWay}" 
                                          Foreground="#cccccc"
                                          Margin="0,1"/>
                            </DataTemplate>
                        </ListBox.ItemTemplate>
                    </ListBox>
                </StackPanel>
                <!-- Tools -->
                <StackPanel Grid.Column="3" Margin="10">
                    <TextBlock Text="Tools" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                    <ListBox Name="ToolsList" SelectionMode="Multiple" Height="330" Background="#161616" Foreground="White">
                        <ListBox.ItemTemplate>
                            <DataTemplate>
                                <CheckBox Content="{Binding Name}" 
                                          IsChecked="{Binding RelativeSource={RelativeSource AncestorType=ListBoxItem}, Path=IsSelected, Mode=TwoWay}" 
                                          Foreground="#cccccc"
                                          Margin="0,1"/>
                            </DataTemplate>
                        </ListBox.ItemTemplate>
                    </ListBox>
                </StackPanel>
                <!-- Editing -->
                <StackPanel Grid.Column="4" Margin="10,10,0,0">
                    <TextBlock Text="Editing" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                    <ListBox Name="EditingList" SelectionMode="Multiple" Height="330" Background="#161616" Foreground="White">
                        <ListBox.ItemTemplate>
                            <DataTemplate>
                                <CheckBox Content="{Binding Name}" 
                                          IsChecked="{Binding RelativeSource={RelativeSource AncestorType=ListBoxItem}, Path=IsSelected, Mode=TwoWay}" 
                                          Foreground="#cccccc"
                                          Margin="0,1"/>
                            </DataTemplate>
                        </ListBox.ItemTemplate>
                    </ListBox>
                </StackPanel>

                <!-- Installer-knapper -->
                <StackPanel Grid.ColumnSpan="5" Orientation="Horizontal" HorizontalAlignment="Center" VerticalAlignment="Bottom" Margin="0,0,0,0">
                    <Button Content="Install" Width="150" Height="35" Background="#161616" Foreground="#cccccc" FontSize="16" HorizontalAlignment="Left" Margin="0,0,20,0" Name="InstallButton">
                        <Button.Template>
                            <ControlTemplate TargetType="Button">
                                <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="5">
                                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                </Border>
                            </ControlTemplate>
                        </Button.Template>
                    </Button>
                    <Button Content="Close" Width="150" Height="35" Background="#161616" Foreground="#cccccc" FontSize="16" HorizontalAlignment="Right" Name="ExitButton">
                        <Button.Template>
                            <ControlTemplate TargetType="Button">
                                <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="5">
                                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                </Border>
                            </ControlTemplate>
                        </Button.Template>
                    </Button>
                </StackPanel>
                <!-- Powered by -->
                <TextBlock Text="Powered by Kimsec.net"
                           Grid.ColumnSpan="5"
                           HorizontalAlignment="Right"
                           VerticalAlignment="Bottom"
                           Margin="0,0,10,10"
                           FontSize="10"
                           Foreground="Gray"
                           Opacity="0.7"/>
            </Grid>
         </TabItem>
         
         <!-- Tweaks And Repair Tab -->
        <TabItem Header="Tweaks &amp; Repair">
            <Grid Margin="10">
                <!-- Definerer 2 kolonner -->
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <!-- Legger til 3 rader:
                     • Rad 0: Innhold (Tweaks og Repair ListBox)
                     • Rad 1: Knapper (Run! og Exit)
                     • Rad 2: "Powered by" tekst -->
                <Grid.RowDefinitions>
                    <!-- content (fixed ListBox heights keep content size) -->
                    <RowDefinition Height="Auto"/>
                    <!-- flexible spacer that pushes buttons lower -->
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>
                
                <!-- Tweaks (backup red color: #b50000 -->
                <StackPanel Grid.Column="0" Margin="0,0,10,0">
                    <TextBlock Text="Tweaks" FontSize="18" Margin="0,10,0,10" FontWeight="Bold"/>
                    <ListBox Name="TweaksList" SelectionMode="Multiple" Height="330" Background="#161616" Foreground="White">
                        <ListBox.ItemTemplate>
                            <DataTemplate>
                                <CheckBox Content="{Binding Name}" 
                                          IsChecked="{Binding RelativeSource={RelativeSource AncestorType=ListBoxItem}, Path=IsSelected, Mode=TwoWay}"
                                          Foreground="#cccccc"
                                          Margin="0,1"/>
                            </DataTemplate>
                        </ListBox.ItemTemplate>
                    </ListBox>
                </StackPanel>
                
                <!-- Repair -->
                <StackPanel Grid.Column="1" Margin="10,0,0,0">
                    <TextBlock Text="Repair" FontSize="18" FontWeight="Bold" Margin="0,10,0,10"/>
                    <ListBox Name="RepairList" SelectionMode="Multiple" Height="330" Background="#161616" Foreground="White">
                        <ListBox.ItemTemplate>
                            <DataTemplate>
                                <CheckBox Content="{Binding Name}" 
                                          IsChecked="{Binding RelativeSource={RelativeSource AncestorType=ListBoxItem}, Path=IsSelected, Mode=TwoWay}"
                                          Foreground="#cccccc"
                                          Margin="0,1"/>
                            </DataTemplate>
                        </ListBox.ItemTemplate>
                    </ListBox>
                </StackPanel>

                <!-- Knapper (plassering: rad 1, spenner over begge kolonner) -->
                <StackPanel Grid.ColumnSpan="2" Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Center" VerticalAlignment="Bottom" Margin="0,0,0,0">
                    <Button Content="Run" Name="InstallTweaks" Width="150" Height="35" Background="#161616" Foreground="#cccccc" FontSize="16" Margin="0,0,20,0">
                        <Button.Template>
                            <ControlTemplate TargetType="Button">
                                <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="5">
                                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                </Border>
                            </ControlTemplate>
                        </Button.Template>
                    </Button>
                    <Button Content="Close" Name="ExitButton_tweaks" Width="150" Height="35" Background="#161616" Foreground="#cccccc" FontSize="16">
                        <Button.Template>
                            <ControlTemplate TargetType="Button">
                                <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="5">
                                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                </Border>
                            </ControlTemplate>
                        </Button.Template>
                    </Button>
                </StackPanel>


                <!-- "Powered by" (plassering: rad 2, spenner over begge kolonner) -->
                <TextBlock Grid.Row="2" Grid.ColumnSpan="2"
                           Text="Powered by Kimsec.net"
                           HorizontalAlignment="Right"
                           VerticalAlignment="Bottom"
                           Margin="0,0,10,10"
                           FontSize="10"
                           Foreground="Gray"
                           Opacity="0.7"/>
            </Grid>
                </TabItem>

                <!-- Update Tab -->
                <TabItem Header="Update">
                    <Grid Margin="10">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>

                        <StackPanel Margin="0,0,0,10" Grid.Row="0">
                            <TextBlock Text="Available updates:" FontSize="18" FontWeight="Bold" Foreground="#cccccc" Margin="0,0,0,0" HorizontalAlignment="Center"/>
                            <CheckBox Name="SelectAllUpdatesCheckbox" Content="Select all" Margin="7,0,0,4" Foreground="#cccccc" FontWeight="Bold" HorizontalAlignment="Left" FocusVisualStyle="{x:Null}"/>
                            <ListBox Name="UpdateList" SelectionMode="Multiple" Height="330" Background="#161616" Foreground="White">
                                <ListBox.ItemTemplate>
                                    <DataTemplate>
                                        <CheckBox Content="{Binding Display}" 
                                                IsChecked="{Binding RelativeSource={RelativeSource AncestorType=ListBoxItem}, Path=IsSelected, Mode=TwoWay}" 
                                                Foreground="#cccccc"
                                                Margin="0,1"/>
                                    </DataTemplate>
                                </ListBox.ItemTemplate>
                            </ListBox>
                        </StackPanel>


                        <!-- Knapper -->
                        <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,0,0,0">
                            <Button Content="Update" Name="UpdateNowButton" Width="150" Height="35" Background="#161616" Foreground="#cccccc" FontSize="16" Margin="0,0,20,0">
                                <Button.Template>
                                    <ControlTemplate TargetType="Button">
                                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="5">
                                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        </Border>   
                                    </ControlTemplate>
                                </Button.Template>
                            </Button>
                            <Button Content="Close" Name="ExitButton_Update" Width="150" Height="35" Background="#161616" Foreground="#cccccc" FontSize="16">
                                <Button.Template>
                                    <ControlTemplate TargetType="Button">
                                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="5">
                                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        </Border>
                                    </ControlTemplate>
                                </Button.Template>
                            </Button>
                        </StackPanel>
                            <TextBlock Grid.Row="2"
                                    Text="Powered by Kimsec.net"
                                    HorizontalAlignment="Right"
                                    VerticalAlignment="Bottom"
                                    Margin="0,0,10,10"
                                    FontSize="10"
                                    Foreground="Gray"
                                    Opacity="0.7"/>
                    </Grid>
                </TabItem>

                <TabItem Header="Uninstall">
                    <Grid Margin="10">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/> <!-- Søkefelt -->
                            <RowDefinition Height="*"/>   <!-- Listbokser -->
                            <RowDefinition Height="Auto"/> <!-- Knapper -->
                        </Grid.RowDefinitions>
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" Grid.Row="0" Margin="0,0,0,0">
                            <TextBlock Text="Advanced" Foreground="#cccccc" VerticalAlignment="Center" Margin="0,0,5,0"/>
                            <ToggleButton Name="AdvancedToggle" Width="40" Height="20" ToolTip="Show system and Microsoft applications" FocusVisualStyle="{x:Null}">
                                <ToggleButton.Template>
                                    <ControlTemplate TargetType="ToggleButton">
                                        <Border x:Name="ToggleBorder" 
                                                Width="40" 
                                                Height="20" 
                                                CornerRadius="10" 
                                                Background="#b3b3b3"
                                                BorderThickness="0">
                                            
                                            <Ellipse x:Name="ToggleThumb"
                                                    Width="16"
                                                    Height="16"
                                                    HorizontalAlignment="Left"
                                                    VerticalAlignment="Center"
                                                    Margin="2,0,0,0"
                                                    Fill="White">
                                                <Ellipse.RenderTransform>
                                                    <TranslateTransform X="0"/>
                                                </Ellipse.RenderTransform>
                                            </Ellipse>
                                        </Border>
                                        <ControlTemplate.Triggers>
                                            <Trigger Property="IsChecked" Value="True">
                                                <Setter TargetName="ToggleBorder" Property="Background" Value="#4CAF50"/>
                                                <Setter TargetName="ToggleThumb" Property="RenderTransform">
                                                    <Setter.Value>
                                                        <TranslateTransform X="20"/>
                                                    </Setter.Value>
                                                </Setter>
                                            </Trigger>
                                            <Trigger Property="IsMouseOver" Value="True">
                                                <Setter TargetName="ToggleBorder" Property="Background" Value="#2E2E2E"/>
                                                <Setter TargetName="ToggleThumb" Property="Fill" Value="#EEEEEE"/>
                                            </Trigger>
                                        </ControlTemplate.Triggers>
                                    </ControlTemplate>
                                </ToggleButton.Template>
                            </ToggleButton>
                        </StackPanel>

                        <!-- Søkefelt -->
                        <StackPanel Grid.Row="0" Orientation="Horizontal" HorizontalAlignment="Left" Margin="0,0,0,0">
                            <TextBox Name="UninstallSearchBox"
                                    Width="300"
                                    ToolTip="Search for program"
                                    VerticalAlignment="Center"
                                    Background="#161616"
                                    Foreground="White"
                                    BorderBrush="#ccc"
                                    Padding="5"/>
                        </StackPanel>

                        <!-- Listevisning -->
                        <Grid Grid.Row="1">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>

                            <!-- Venstre liste -->
                            <ListBox Name="UninstallList"
                                    Grid.Column="0"
                                    SelectionMode="Multiple"
                                    Background="#161616"
                                    Foreground="#cccccc"
                                    Margin="0,0,0,0"
                                    Height="330">
                                <ListBox.ItemTemplate>
                                    <DataTemplate>
                                        <CheckBox Content="{Binding Display}"
                                                Tag="{Binding}"
                                                IsChecked="{Binding RelativeSource={RelativeSource AncestorType=ListBoxItem}, Path=IsSelected, Mode=TwoWay}"
                                                Foreground="#cccccc"
                                                Margin="0,1"/>
                                    </DataTemplate>
                                </ListBox.ItemTemplate>
                            </ListBox>

                            <!-- Pil -->
                            <TextBlock Grid.Column="1"
                                    Text="-->"
                                    FontSize="18"
                                    Foreground="#cccccc"
                                    Margin="10"
                                    VerticalAlignment="Center"/>

                            <!-- Høyre liste -->
                            <ListBox Name="SelectedForUninstallList"
                                    Grid.Column="2"
                                    Background="#161616"
                                    Foreground="#cccccc"
                                    Margin="0,0,0,0"
                                    Height="330">
                                <ListBox.ItemTemplate>
                                    <DataTemplate>
                                        <CheckBox Content="{Binding Display}"
                                                Tag="{Binding}"
                                                IsChecked="True"
                                                Foreground="#cccccc"
                                                Margin="0,1"/>
                                    </DataTemplate>
                                </ListBox.ItemTemplate>
                            </ListBox>
                        </Grid>
                        <!-- Knapper nederst -->
                        <StackPanel Grid.Row="2"
                                    Orientation="Horizontal"
                                    HorizontalAlignment="Center"
                                    Margin="0,0,0,0">
                            <Button Content="Uninstall"
                                    Name="UninstallNowButton"
                                    Width="150"
                                    Height="35"
                                    FontSize="16"
                                    Margin="0,0,20,0"
                                    Background="#161616"
                                    Foreground="#cccccc">
                                <Button.Template>
                                    <ControlTemplate TargetType="Button">
                                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="5">
                                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        </Border>
                                    </ControlTemplate>
                                </Button.Template>
                            </Button>

                            <Button Content="Close"
                                    Name="ExitButton_Uninstall"
                                    Width="150"
                                    Height="35"
                                    FontSize="16"
                                    Background="#161616"
                                    Foreground="#cccccc">
                                <Button.Template>
                                    <ControlTemplate TargetType="Button">
                                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="5">
                                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        </Border>
                                    </ControlTemplate>
                                </Button.Template>
                            </Button>
                        </StackPanel>

                        <!-- Powered by -->
                        <TextBlock Text="Powered by Kimsec.net"
                                Grid.Row="2"
                                HorizontalAlignment="Right"
                                VerticalAlignment="Bottom"
                                Margin="0,0,10,10"
                                FontSize="10"
                                Foreground="Gray"
                                Opacity="0.7"/>
                    </Grid>
                </TabItem>
      </TabControl>
    </Border>
</Window>
"@

# --- 3) Les inn XAML og hent ut kontroller ---
$reader = New-Object System.Xml.XmlNodeReader $XAML
$window = [Windows.Markup.XamlReader]::Load($reader)

# Installer Tab
$programList   = $window.FindName("ProgramList")
$browserList   = $window.FindName("BrowserList")
$gameList      = $window.FindName("GameList")
$toolsList     = $window.FindName("ToolsList")
$editingList   = $window.FindName("EditingList")
$installButton = $window.FindName("InstallButton")
$exitButton    = $window.FindName("ExitButton")

# Tweaks And Repair Tab
$installTweaks     = $window.FindName("InstallTweaks")
$exitButton_tweaks = $window.FindName("ExitButton_tweaks")
$tweaksList        = $window.FindName("TweaksList")
$repairList        = $window.FindName("RepairList")

# Update Tab
$suppressCheckboxEvent = $false
$updateList       = $window.FindName("UpdateList")
$updateNowButton  = $window.FindName("UpdateNowButton")
$exitButtonUpdate = $window.FindName("ExitButton_Update")
$selectAllUpdatesCheckbox = $window.FindName("SelectAllUpdatesCheckbox")


# Uninstall Tab
$uninstallList               = $window.FindName("UninstallList")
$uninstallNowButton          = $window.FindName("UninstallNowButton")
$exitButtonUninstall         = $window.FindName("ExitButton_Uninstall")
$UninstallSearchBox          = $window.FindName("UninstallSearchBox")
$AdvancedToggle              = $window.FindName("AdvancedToggle")
$mainTabControl              = $window.FindName("MainTabControl")

# --- Placeholder (watermark) for uninstall search box ---
$uninstallSearchPlaceholder = "Search for program"
$UninstallSearchBox.Tag = $uninstallSearchPlaceholder
$UninstallSearchBox.Text = $uninstallSearchPlaceholder
$UninstallSearchBox.Foreground = 'Gray'

$UninstallSearchBox.Add_GotFocus({
    if ($UninstallSearchBox.Text -eq $UninstallSearchBox.Tag) {
        $UninstallSearchBox.Text = ''
        $UninstallSearchBox.Foreground = 'White'
    }
})

$UninstallSearchBox.Add_LostFocus({
    if ([string]::IsNullOrWhiteSpace($UninstallSearchBox.Text)) {
        $UninstallSearchBox.Text = $UninstallSearchBox.Tag
        $UninstallSearchBox.Foreground = 'Gray'
    }
})

# --- 4) Bind data til ListBox-ene ---
$programList.ItemsSource = $programs | Sort-Object Name
$browserList.ItemsSource = $browsers | Sort-Object Name
$gameList.ItemsSource    = $games | Sort-Object Name
$tweaksList.ItemsSource  = $tweaks | Sort-Object Name
$repairList.ItemsSource  = $repair | Sort-Object Name
$toolsList.ItemsSource   = $tools | Sort-Object Name
$editingList.ItemsSource = $editing | Sort-Object Name

# Hent liste over oppdaterbare programmer med winget
function Get-WingetUpgrades {
    $output = winget upgrade --source winget | ForEach-Object { $_.Trim() } | Where-Object { $_ -and ($_ -notmatch '^-+') -and ($_ -notmatch '^\s*Name\s+') }
    $cleanList = @()
    foreach ($line in $output) {
        # Prøv å splitte med minst to mellomrom som separator
        $parts = $line -split '\s{2,}'
        if ($parts.Count -ge 3) {
            $name = $parts[0].Trim()
            $id = $parts[1].Trim()
            if ($id -ne '') {
                $cleanList += [PSCustomObject]@{
                    Display = "$name"
                    Id = $id
                }
            }
        }
    }
    return $cleanList
}

function Get-UninstallItems {
    param([bool]$ShowAdvanced = $false)

    # Winget
    $wingetItems = @()
    $wingetRaw = winget list --source winget | ForEach-Object { $_.Trim() }

    foreach ($line in $wingetRaw) {
        if ($line -match '^\s*Name\s+Id\s+Version') { continue }
        if ($line -match '^-{5,}') { continue }

        $parts = $line -split '\s{2,}'
        if ($parts.Count -ge 2) {
            $name = $parts[0].Trim()
            $id   = $parts[1].Trim()

            if ($name -and $id -and $id -notmatch '[\\\s]') {
                $wingetItems += [PSCustomObject]@{
                    Display = $name
                    Id      = $id
                    Source  = 'winget'
                }
            }
        }
    }

    # Registry uninstall
    $registryPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\*"
    )

    $registryItems = Get-ItemProperty -Path $registryPaths -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -and $_.UninstallString } |
        ForEach-Object {
            [PSCustomObject]@{
                Display = $_.DisplayName.Trim()
                Id      = $_.UninstallString
                Source  = 'registry'
            }
        }

    # Appx/Store/MSIX (Speedtest, etc.)
    $appxPackages = @()

    # All users (hvis det er systeminstallasjon)
    $appxPackages += Get-AppxPackage | Where-Object { $_.Name -and $_.PackageFullName }

    # Konverter til uninstall-objekter
    $appxItems = $appxPackages |
        Sort-Object -Property Name -Unique |
        ForEach-Object {
            [PSCustomObject]@{
                Display = $_.Name
                Id      = $_.PackageFullName
                Source  = 'appx'
            }
        }

    # Unike basert på Display-navn (prioriterer winget > registry > appx)
    $finalItems = @{}
    foreach ($item in $wingetItems + $registryItems + $appxItems) {
        $key = $item.Display.ToLower()
        if (-not $finalItems.ContainsKey($key)) {
            $finalItems[$key] = $item
        }
    }

    $allItems = $finalItems.Values

    # 🔍 Filtrer ut system/Microsoft-ting om AdvancedToggle er AV
    if (-not $ShowAdvanced) {
        $allItems = $allItems | Where-Object {
            $name = $_.Display

            # Ekskluder GUID-lignende navn
            if ($name -match '^[a-fA-F0-9\-]{10,}$') { return $false }

            # Ekskluder IP-adresser
            if ($name -match '^\d{1,3}(\.\d{1,3}){3}$') { return $false }

            # Ekskluder tekniske og systemnære navn
            if ($name -match 'Microsoft\.|Runtime|Framework|Visual C\+\+|Redistributable|Driver|System|Shared|Shell|Store|UWP|VCLibs|Package|.NET|SDK|WinRT') { return $false }

            # Ekskluder ting uten mellomrom og som ser maskinlagde ut
            if ($name -notmatch '\s' -and $name -match '[A-Z]' -and $name -match '\d') { return $false }

            return $true
        }
    }


    return $allItems | Sort-Object Display
}



$tabDataLoaded = @{
    Update = $false
    Uninstall = $false
}

$mainTabControl.Add_SelectionChanged({
    $selectedTab = $mainTabControl.SelectedItem.Header

    if ($selectedTab -eq "Update" -and -not $tabDataLoaded.Update) {
        $updateList.ItemsSource = Get-WingetUpgrades | Sort-Object Display
        $tabDataLoaded.Update = $true
    }

    elseif ($selectedTab -eq "Uninstall" -and -not $tabDataLoaded.Uninstall) {
        $uninstallList.ItemsSource = Get-UninstallItems
        $tabDataLoaded.Uninstall = $true
    }
})
function UninstallCheck_Checked {
    param($s, $e)
    $item = $s.Tag
    if (-not $selectedUninstallItems.Contains($item)) {
        $selectedUninstallItems.Add($item)
    }
}

function UninstallCheck_Unchecked {
    param($s, $e)
    $item = $s.Tag
    if ($selectedUninstallItems.Contains($item)) {
        $selectedUninstallItems.Remove($item)
    }
}

$AdvancedToggle.Add_Checked({
    $script:AllUninstallItems = Get-UninstallItems -ShowAdvanced:$true
    $uninstallList.ItemsSource = $script:AllUninstallItems
})

$AdvancedToggle.Add_Unchecked({
    $script:AllUninstallItems = Get-UninstallItems -ShowAdvanced:$false
    $uninstallList.ItemsSource = $script:AllUninstallItems
})

function Show-CustomMessageBox {
    param(
        [string]$Message,
        [string]$Title,
        [string]$ButtonText = "OK"
    )

    # Load the custom message window XAML
    $msgReader = New-Object System.Xml.XmlNodeReader $MsgXAML
    $msgWindow = [Windows.Markup.XamlReader]::Load($msgReader)
    
    # Set window properties
    $msgWindow.Title = $Title
    $msgWindow.FindName("MessageText").Text = $Message
    $msgWindow.FindName("OkButton").Content = $ButtonText
    $msgWindow.Owner = $window  # Viktig for eierskap
    
    # Handle button click
    $msgWindow.FindName("OkButton").Add_Click({
        # Først aktiver hovedvinduet
        $window.Activate()
        $window.Focus()
        
        # Lukk meldingsvinduet
        $msgWindow.DialogResult = $true
    })
    
    # Vis dialog og returner resultat
    $null = $msgWindow.ShowDialog()
    
    # Ekstra sikkerhet for fokus
    $window.Activate()
    $window.Focus()
}

function Show-InstallingPopup {
    param(
        [string]$Message
    )

    # Last inn XAML for meldingsvinduet
    $msgReader = New-Object System.Xml.XmlNodeReader $MsgXAML
    $msgWindow = [Windows.Markup.XamlReader]::Load($msgReader)
    
    # Sett egenskaper
    $msgWindow.Title = "Installing"
    $msgWindow.FindName("MessageText").Text = $Message
    $msgWindow.FindName("OkButton").Visibility = "Collapsed"
    $msgWindow.Owner = $window

    # Legg til denne koden for dynamisk posisjonering
    $msgWindow.Add_ContentRendered({
        $this.WindowStartupLocation = "CenterOwner"
        $this.UpdateLayout()
    })

    # Vis vinduet og returner referanse
    $msgWindow.Show()
    return $msgWindow
}

# --- 5) Når "Install"-knappen trykkes ---
$installButton.Add_Click({
    $selectedPrograms = $programList.SelectedItems
    $selectedBrowsers = $browserList.SelectedItems
    $selectedGames = $gameList.SelectedItems
    $selectedTools = $toolsList.SelectedItems
    $selectedEditing = $editingList.SelectedItems

    if (-not $selectedPrograms -and -not $selectedBrowsers -and -not $selectedGames -and -not $selectedTools -and -not $selectedEditing) {
        Show-CustomMessageBox -Message "Ingen programmer er valgt." -Title "Feil"
        return
    }

    $selectedItems = @($selectedPrograms) + @($selectedBrowsers) + @($selectedGames) + @($selectedTools) + @($selectedEditing)
    $installingPopup = Show-InstallingPopup -Message "Initialising install..."

    foreach ($item in $selectedItems) {
        $installingPopup.FindName("MessageText").Text = "Downloading & installing $($item.Name). Please wait..."
        $installingPopup.UpdateLayout()
        $installingPopup.Dispatcher.Invoke([action]{
            $installingPopup.Left = $window.Left + ($window.Width - $installingPopup.ActualWidth) / 2
            $installingPopup.Top = $window.Top + ($window.Height - $installingPopup.ActualHeight) / 2
        }, "Normal")

        if ($item.Command -like "Invoke-WebRequest*" -or $item.Command -eq "Download-NvidiaApp") {
            if ($item.Command -eq "Download-NvidiaApp") {
                $success = & $item.Command
                if ($success) {
                    Show-CustomMessageBox -Message "NVIDIA App installer is saved in \Downloads folder." -Title "Information"
                } else {
                    Show-CustomMessageBox -Message "Failed to download NVIDIA App. Please try again or download manually." -Title "Error"
                }
            } else {
                Invoke-Expression $item.Command
                if ($item.Name -eq "Auto Accept For CS2") {
                    Show-CustomMessageBox -Message "Auto Accept For CS2 is saved in \Documents." -Title "Information"
                }
            }
        }
        else {
            $baseCommand = $item.Command + " -e --accept-source-agreements --accept-package-agreements"

            $output = & powershell -NoProfile -Command $baseCommand 2>&1
            
            if ($output -match "Installer hash does not match") {
                # Vis status for hash-fiks
                $installingPopup.FindName("MessageText").Text = "Fixing hash mismatch with $($item.Name). Please wait..."
                $installingPopup.UpdateLayout()
                $installingPopup.Dispatcher.Invoke([action]{
                    $installingPopup.Left = $window.Left + ($window.Width - $installingPopup.ActualWidth) / 2
                    $installingPopup.Top = $window.Top + ($window.Height - $installingPopup.ActualHeight) / 2
                }, "Normal")

                Start-Process -FilePath "powershell" -Verb RunAs -WindowStyle Minimized -ArgumentList "-NoProfile", "-Command", "winget settings --enable InstallerHashOverride" -Wait
                $modifiedCommand = $item.Command + " -e --accept-source-agreements --accept-package-agreements --ignore-security-hash"
                & powershell -NoProfile -Command $modifiedCommand
            }
        }
    }

    $installingPopup.Close()
    Show-CustomMessageBox -Message "Installed Successfully." -Title "Suksess"
    $programList.SelectedItems.Clear()
    $browserList.SelectedItems.Clear()
    $gameList.SelectedItems.Clear()
    $toolsList.SelectedItems.Clear()
    $editingList.SelectedItems.Clear()
})

$installTweaks.Add_Click({
    $selectedTweaks = $tweaksList.SelectedItems
    $selectedRepair = $repairList.SelectedItems

    # Sjekk om ingenting er valgt
    if (-not $selectedTweaks -and -not $selectedRepair) {
        Show-CustomMessageBox -Message "Ingen handlinger valgt!" -Title "Feil"
        return
    }

    $selectedItems = @($selectedTweaks) + @($selectedRepair)
    $installingPopup = Show-InstallingPopup -Message "Initialising tweaks/repairs..."

    $total = $selectedItems.Count
    $i = 1
    $errors = @()

    foreach ($item in $selectedItems) {
        $installingPopup.FindName("MessageText").Text = "($i/$total) Running: $($item.Name). Please wait..."
        $installingPopup.UpdateLayout()
        $installingPopup.Dispatcher.Invoke([action]{
            $installingPopup.Left = $window.Left + ($window.Width - $installingPopup.ActualWidth) / 2
            $installingPopup.Top = $window.Top + ($window.Height - $installingPopup.ActualHeight) / 2
        }, "Normal")

        try {
            $cmd = $item.Command
            if ([string]::IsNullOrWhiteSpace($cmd)) { throw "Empty command" }

            # Oppdag kommandoer som vanligvis krever admin
            $needsAdmin = $false
            $trimCmd = ($cmd.TrimStart())
            if ($cmd -match '(?i)\b(sfc|dism(\.exe)?|chkdsk)\b' -or
                $trimCmd -match '(?i)HKLM:' -or
                $trimCmd -match "(?i)reg\s+add\s+'?HKLM\\" -or
                $cmd -match '(?i)/RestoreHealth|/StartComponentCleanup' ) {
                $needsAdmin = $true
            }

            if ($needsAdmin) {
                # Kjør forhøyet PowerShell og vent til ferdig
                Start-Process -FilePath "powershell" -Verb RunAs -WindowStyle Minimized -Wait -ArgumentList @("-NoProfile", "-Command", $cmd)
            }
            else {
                # Sørg for at Start-Process-kommandoer venter når de kjøres i samme sesjon
                if ($trimCmd -match '^(?i)start-process\b' -and $cmd -notmatch '(?i)\-wait\b') {
                    $cmd = $cmd + ' -Wait'
                }

                if ($cmd -match "\r?\n") {
                    Invoke-Expression $cmd
                } else {
                    & powershell -NoProfile -Command $cmd
                }
            }
        }
        catch {
            $errors += "[$($item.Name)] $_"
        }

        $i++
    }
    $installingPopup.Close()
    if ($errors.Count -gt 0) {
        Show-CustomMessageBox -Message ("Some actions failed:`n" + ($errors -join "`n")) -Title "Ferdig (med feil)"
    } else {
        Show-CustomMessageBox -Message "Success!" -Title "Suksess"
    }
    $tweaksList.SelectedItems.Clear()
    $repairList.SelectedItems.Clear()
})

$exitButton.Add_Click({
    $window.Close()
})

$exitButton_tweaks.Add_Click({
    $window.Close()
})

$updateNowButton.Add_Click({
    $selectedUpdates = $updateList.SelectedItems
    if (-not $selectedUpdates -or $selectedUpdates.Count -eq 0) {
        Show-CustomMessageBox -Message "Ingen programmer valgt for oppdatering." -Title "Info"
        return
    }

    $updatePopup = Show-InstallingPopup -Message "Initialising updates..."

    $total = $selectedUpdates.Count
    $index = 1

    foreach ($app in $selectedUpdates) {
        $updatePopup.FindName("MessageText").Text = "Updating ($index/$total): $($app.Display). Please wait..."
        $updatePopup.UpdateLayout()
        $updatePopup.Dispatcher.Invoke([action]{
            $updatePopup.Left = $window.Left + ($window.Width - $updatePopup.ActualWidth) / 2
            $updatePopup.Top = $window.Top + ($window.Height - $updatePopup.ActualHeight) / 2
        }, "Normal")

        $cmd = "winget upgrade --id='$($app.Id)' --accept-source-agreements --accept-package-agreements"
        Start-Process -Verb RunAs -WindowStyle Minimized -Wait -FilePath "powershell" -ArgumentList "-NoProfile", "-Command", $cmd

        $index++
    }

    $updatePopup.Close()
    Show-CustomMessageBox -Message "Program(s) are updated.`nNB: Some programs do not allow updating through third party." -Title "Ferdig"
    $updateList.SelectedItems.Clear()
    $updateList.ItemsSource = Get-WingetUpgrades | Sort-Object Display
})
$selectAllUpdatesCheckbox.Add_Checked({
    if ($suppressCheckboxEvent) { return }
    $suppressCheckboxEvent = $true
    $updateList.SelectAll()
    $suppressCheckboxEvent = $false
})

$selectAllUpdatesCheckbox.Add_Unchecked({
    if ($suppressCheckboxEvent) { return }
    $suppressCheckboxEvent = $true
    $updateList.UnselectAll()
    $suppressCheckboxEvent = $false
})

$updateList.Add_SelectionChanged({
    if ($suppressCheckboxEvent) { return }

    $totalItems = $updateList.Items.Count
    $selectedCount = $updateList.SelectedItems.Count

    $suppressCheckboxEvent = $true
    if ($selectedCount -eq $totalItems -and $totalItems -gt 0) {
        $selectAllUpdatesCheckbox.IsChecked = $true
    }
    else {
        $selectAllUpdatesCheckbox.IsChecked = $false
    }
    $suppressCheckboxEvent = $false
})

$exitButtonUpdate.Add_Click({
    $window.Close()
})



# Initialiser valgte liste
$SelectedForUninstallList = $window.FindName("SelectedForUninstallList")
$selectedUninstallItems = New-Object System.Collections.ObjectModel.ObservableCollection[object]
$SelectedForUninstallList.ItemsSource = $selectedUninstallItems
$SelectedForUninstallList.AddHandler(
    [System.Windows.Controls.Primitives.ButtonBase]::ClickEvent,
    [System.Windows.RoutedEventHandler]{
        param ($s, $e)
        $cb = $e.OriginalSource
        if ($cb -is [System.Windows.Controls.CheckBox] -and $cb.Tag) {
            $item = $cb.Tag
            if (-not $cb.IsChecked) {
                $selectedUninstallItems.Remove($item)

                # Fjern markering i venstre liste (dersom den er synlig og matcher objektet)
                foreach ($listItem in $uninstallList.Items) {
                    if ($listItem -eq $item) {
                        $uninstallList.SelectedItems.Remove($listItem) | Out-Null
                        break
                    }
                }
            }
        }
    })



# Klikk på avinstalleringsknapp
$uninstallNowButton.Add_Click({
    $selected = $selectedUninstallItems
    if (-not $selected.Count) {
        Show-CustomMessageBox -Message "No programs chosen." -Title "Info"
        return
    }

    $popup = Show-InstallingPopup -Message "Initialiserer avinstallering..."
    $total = $selected.Count
    $i = 1

    foreach ($item in @($selected)) {
        $popup.FindName("MessageText").Text = "Uninstalling ($i/$total): $($item.Display)..."
        $popup.UpdateLayout()
        $popup.Dispatcher.Invoke([action]{
            $popup.Left = $window.Left + ($window.Width - $popup.ActualWidth) / 2
            $popup.Top = $window.Top + ($window.Height - $popup.ActualHeight) / 2
        }, "Normal")

        switch ($item.Source) {
            'winget' {
                Start-Process powershell -Verb RunAs -WindowStyle Hidden -ArgumentList "-Command", "winget uninstall --silent --id='$($item.Id)'"
            }
            'msi' {
                Start-Process msiexec.exe -Verb RunAs -WindowStyle Hidden -ArgumentList "/x $($item.Id) /qn"
            }
            'appx' {
                Start-Process powershell -Verb RunAs -WindowStyle Hidden -ArgumentList "-Command", "Remove-AppxPackage -AllUsers -Package '$($item.Id)'"
            }
            default {
                Start-Process cmd.exe -Verb RunAs -WindowStyle Hidden -ArgumentList "/C "$($item.Id)""
            }
        }
        $i++
    }

    $popup.Close()
    Show-CustomMessageBox -Message "Chosen programs uninstalled." -Title "Ferdig"

    # Oppdater liste og nullstill valg
    $UninstallSearchBox.Text = ""
    $selectedUninstallItems.Clear()
    $script:AllUninstallItems = Get-UninstallItems
    $uninstallList.ItemsSource = $AllUninstallItems
})


# Last inn listen første gang
$script:AllUninstallItems = Get-UninstallItems
$uninstallList.ItemsSource = $AllUninstallItems
$uninstallList.AddHandler([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent,
    [System.Windows.RoutedEventHandler]{
        param ($s, $e)
        $cb = $e.OriginalSource
        if ($cb -is [System.Windows.Controls.CheckBox] -and $cb.Tag) {
            if ($cb.IsChecked) {
                if (-not $selectedUninstallItems.Contains($cb.Tag)) {
                    $selectedUninstallItems.Add($cb.Tag)
                }
            } else {
                if ($selectedUninstallItems.Contains($cb.Tag)) {
                    $selectedUninstallItems.Remove($cb.Tag)
                }
            }
        }
    })

$uninstallList.Add_SelectionChanged({
    foreach ($item in $uninstallList.Items) {
        if ($uninstallList.SelectedItems.Contains($item)) {
            if (-not $selectedUninstallItems.Contains($item)) {
                $selectedUninstallItems.Add($item)
            }
        } else {
            if ($selectedUninstallItems.Contains($item)) {
                $selectedUninstallItems.Remove($item)
            }
        }
    }
})

# Søking som bevarer hukede elementer
$UninstallSearchBox.Add_TextChanged({
    if ($UninstallSearchBox.Text -eq $UninstallSearchBox.Tag) {
        # Ignore placeholder text
        $uninstallList.ItemsSource = $AllUninstallItems
        return
    }
    $query = $UninstallSearchBox.Text.Trim().ToLower()
    if (-not $query) {
        $uninstallList.ItemsSource = $AllUninstallItems
    } else {
        $filtered = @($AllUninstallItems | Where-Object { $_.Display.ToLower() -like "*$query*" })
        $uninstallList.ItemsSource = $filtered -as [System.Collections.IEnumerable]
    }

    # Reselect tidligere valgte elementer etter søk
    foreach ($item in $uninstallList.Items) {
        if ($selectedUninstallItems -contains $item) {
            $uninstallList.SelectedItems.Add($item) | Out-Null
        }
    }
})


$exitButtonUninstall.Add_Click({ $window.Close() })

# Show vindu
$window.ShowDialog() | Out-Null
