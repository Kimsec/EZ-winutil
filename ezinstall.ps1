Write-Host "_____________________________________________________________"
Write-Host ""
Write-Host "      Welcome to Kimsec.net Easy App Install & Tweaks" -ForegroundColor Cyan
Write-Host "_____________________________________________________________"
Write-Host ""
# Import necessary modules for GUI
Add-Type -AssemblyName PresentationFramework

# Function to download NVIDIA App
function Download_NvidiaApp {
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
        Write-Warning "Could not retrieve NVIDIA App version: $_"
        return $false
    }
}
function Get-RemoteList {
    param(
        [string]$Uri,
        [object[]]$Fallback = @()
    )
    try { return Invoke-RestMethod -Uri $Uri -UseBasicParsing }
    catch { Write-Warning "Failed to load $Uri ($_)"; return $Fallback }
}

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

$installerData = Get-RemoteList -Uri 'https://raw.githubusercontent.com/Kimsec/EZ-Apps/refs/heads/main/installer.json'
$programs  = $installerData.programs
$browsers  = $installerData.browsers
$games     = $installerData.games
$tools     = $installerData.tools
$editing   = $installerData.editing

$tweaksData = Get-RemoteList -Uri 'https://raw.githubusercontent.com/Kimsec/EZ-Apps/refs/heads/main/tweaks.json'
$tweaks = $tweaksData.tweaks
$repair = $tweaksData.repair

# --- 4) Bind data til ListBox-ene ---
$programList.ItemsSource = $programs | Sort-Object Name
$browserList.ItemsSource = $browsers | Sort-Object Name
$gameList.ItemsSource    = $games | Sort-Object Name
$toolsList.ItemsSource   = $tools | Sort-Object Name
$editingList.ItemsSource = $editing | Sort-Object Name

$tweaksList.ItemsSource  = $tweaks | Sort-Object Name
$repairList.ItemsSource  = $repair | Sort-Object Name

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

    $wingetItems = @()
    $otherItems  = @()

    foreach ($item in $selectedItems) {
        if ($item.Command -match '^(?i)winget\s+install\b') {
            $wingetItems += $item
        }
        else {
            $otherItems += $item
        }
    }

    foreach ($item in $otherItems) {
        $installingPopup.FindName("MessageText").Text = "Downloading & installing $($item.Name). Please wait..."
        $installingPopup.UpdateLayout()
        $installingPopup.Dispatcher.Invoke([action]{
            $installingPopup.Left = $window.Left + ($window.Width - $installingPopup.ActualWidth) / 2
            $installingPopup.Top = $window.Top + ($window.Height - $installingPopup.ActualHeight) / 2
        }, "Normal")

        if ($item.Command -like "Invoke-WebRequest*" -or $item.Command -eq "Download_NvidiaApp") {
            if ($item.Command -eq "Download_NvidiaApp") {
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

                Start-Process -FilePath "powershell" -Verb RunAs -WindowStyle Hidden -ArgumentList "-NoProfile", "-Command", "winget settings --enable InstallerHashOverride" -Wait
                $modifiedCommand = $item.Command + " -e --accept-source-agreements --accept-package-agreements --ignore-security-hash"
                & powershell -NoProfile -Command $modifiedCommand
            }
        }
    }

    $errorsFound = $false

    if ($wingetItems.Count -gt 0) {
        $installingPopup.FindName("MessageText").Text = "Installing $($wingetItems.Count) app(s). Please wait..."
        $installingPopup.UpdateLayout()
        $installingPopup.Dispatcher.Invoke([action]{
            $installingPopup.Left = $window.Left + ($window.Width - $installingPopup.ActualWidth) / 2
            $installingPopup.Top = $window.Top + ($window.Height - $installingPopup.ActualHeight) / 2
        }, "Normal")

        $cmds = $wingetItems | ForEach-Object { "$($_.Command) -e --accept-source-agreements --accept-package-agreements" }
        $cmdsLiteral = ($cmds | ForEach-Object { "'{0}'" -f ($_ -replace "'", "''") }) -join ', '

        $script = @"
`$ErrorActionPreference = 'Stop'
`$cmds = @($cmdsLiteral)
`$anyFailed = `$false

foreach (`$c in `$cmds) {
    `$out = & powershell -NoProfile -Command `$c 2>&1
    if (`$LASTEXITCODE -ne 0 -and `$out -match 'Installer hash does not match') {
        try { winget settings --enable InstallerHashOverride | Out-Null } catch { }
        `$retry = `$c + ' --ignore-security-hash'
        `$out = & powershell -NoProfile -Command `$retry 2>&1
    }
    if (`$LASTEXITCODE -ne 0) { `$anyFailed = `$true }
}

if (`$anyFailed) { exit 1 } else { exit 0 }
"@

        $proc = Start-Process -Verb RunAs -WindowStyle Hidden -Wait -PassThru -FilePath "powershell" -ArgumentList @(
            "-NoProfile",
            "-Command",
            $script
        )

        if ($proc.ExitCode -ne 0) {
            $errorsFound = $true
        }
    }

    $installingPopup.Close()
    if ($errorsFound) {
        Show-CustomMessageBox -Message "Finished installing with some errors." -Title "Ferdig (med feil)"
    }
    else {
        Show-CustomMessageBox -Message "Installed Successfully." -Title "Suksess"
    }
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
                Start-Process -FilePath "powershell" -Verb RunAs -WindowStyle Hidden -Wait -ArgumentList @("-NoProfile", "-Command", $cmd)
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

    $ids = @(
        $selectedUpdates |
            ForEach-Object { $_.Id } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            Select-Object -Unique
    )
    if ($ids.Count -eq 0) {
        Show-CustomMessageBox -Message "Ingen gyldige oppdateringer valgt." -Title "Info"
        return
    }

    $updatePopup = Show-InstallingPopup -Message "Updating $($ids.Count) app(s). Please wait, it might take a while..."
    $updatePopup.UpdateLayout()
    $updatePopup.Dispatcher.Invoke([action]{
        $updatePopup.Left = $window.Left + ($window.Width - $updatePopup.ActualWidth) / 2
        $updatePopup.Top = $window.Top + ($window.Height - $updatePopup.ActualHeight) / 2
    }, "Normal")

    try {
        $idsLiteral = ($ids | ForEach-Object { "'{0}'" -f ($_ -replace "'", "''") }) -join ", "

        $elevatedScript = @" 
`$ErrorActionPreference = 'Stop'
 
`$ids = @($idsLiteral)
`$anyFailed = `$false

foreach (`$id in `$ids) {
    if ([string]::IsNullOrWhiteSpace(`$id)) { continue }

    `$out = & winget upgrade -e --id `$id --silent --disable-interactivity --accept-source-agreements --accept-package-agreements 2>&1
    if (`$LASTEXITCODE -ne 0) {
        `$anyFailed = `$true
    }
}

if (`$anyFailed) { exit 1 } else { exit 0 }
"@

        $proc = Start-Process -Verb RunAs -WindowStyle Hidden -Wait -PassThru -FilePath "powershell" -ArgumentList @(
            "-NoProfile",
            "-Command",
            "-ExecutionPolicy Bypass",
            $elevatedScript
        )

        $updatePopup.Close()

        if ($proc.ExitCode -eq 0) {
            Show-CustomMessageBox -Message "Program(s) are updated." -Title "Ferdig"
        }
        else {
            Show-CustomMessageBox -Message "Finished updating with some errors.`nNB: Some programs do not allow updating through third party." -Title "Ferdig (med feil)"
        }
    }
    catch {
        try { $updatePopup.Close() } catch { }
        Show-CustomMessageBox -Message "Update aborted or failed: $($_.Exception.Message)" -Title "Error"
    }
    finally {
        $updateList.SelectedItems.Clear()
        $updateList.ItemsSource = Get-WingetUpgrades | Sort-Object Display
    }
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
                Start-Process powershell -Verb RunAs -WindowStyle Hidden -wait -ArgumentList "-Command", "winget uninstall --silent --id='$($item.Id)'"
            }
            'msi' {
                Start-Process msiexec.exe -Verb RunAs -WindowStyle Hidden -wait -ArgumentList "/x $($item.Id) /qn"
            }
            'appx' {
                Start-Process powershell -Verb RunAs -WindowStyle Hidden -wait -ArgumentList "-Command", "Remove-AppxPackage -AllUsers -Package '$($item.Id)'"
            }
            default {
                Start-Process cmd.exe -Verb RunAs -WindowStyle Hidden -wait -ArgumentList "/C "$($item.Id)""
            }
        }
        $i++
    }

    $popup.Close()
    Show-CustomMessageBox -Message "$($selected.Count) program(s) uninstalled." -Title "Ferdig"

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
