<p align="center" width="10%">
    <img width="20%" src="Screenshots/ezicon.png"></a>
</p>

# <p align="center">EZ-WinUtil</p>

<br><p align="center" width="100%">
<a href="https://www.buymeacoffee.com/kimsec">
  <img src="https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&amp;emoji=%E2%98%95&amp;slug=kimsec&amp;button_colour=FFDD00&amp;font_colour=000000&amp;font_family=Inter&amp;outline_colour=000000&amp;coffee_colour=ffffff" alt="Buy Me A Coffee"></a></p>


## Description
**ez-util** is a PowerShell-based utility script designed to simplify the installation of popular applications, system tweaks, and repair tasks on Windows. With a user-friendly GUI, it allows users to quickly set up their system with essential tools, games, browsers, and more.

## Features

- **Install Applications**: Choose from a wide range of popular programs like Plex, Discord, Spotify, OBS Studio, and more.
- **Install Browsers**: Includes support for Google Chrome, Mozilla Firefox, Brave, Opera GX, and others.
- **Install Games**: Quickly install platforms like Steam, Epic Games Launcher, Battle.net, and more.
- **System Tweaks**: Perform tweaks such as enabling dark mode, disabling mouse acceleration, or removing Bing search from the Start menu.
- **System Repair**: Run system repair tools like SFC, DISM, and disk cleanup.
- **Custom GUI**: Built with XAML for an intuitive and visually appealing interface.

## How to Use

1. **Run the Script**  
   Open PowerShell and execute the following command:
   ```powershell
   iwr -useb kimsec.net/apps | iex
2. **Select Actions**  
   - Use the GUI to select the programs, browsers, games, tools, tweaks, or repair tasks you want to execute.

3. **Execute**  
   - Click the `Install` or `Run` button to start the process.

4. **Enjoy**  
   - The script will handle the rest, including downloading, installing, and applying tweaks.

## Requirements

- Windows 10 or newer.
- PowerShell 5.1 or higher.
- [Winget](https://learn.microsoft.com/en-us/windows/package-manager/) (Windows Package Manager) must be installed.

## Customization

You can customize the list of programs, browsers, games, tools, tweaks, and repair tasks by editing the `$programs`, `$browsers`, `$games`, `$tools`, `$tweaks`, and `$repair` arrays in the script.

## Example Tweaks

- **Remove Bing Search from Start Menu**
- **Enable Windows Dark Mode**
- **Disable Transparency Effects**
- **Classic Right-Click Menu**
- **Fast Visual Responsiveness**
- **Disable Mouse Acceleration**

## Example Repair Tasks

- **Search for Corrupted Files** (`sfc /scannow`)
- **DISM Restore Health**
- **Scan Drive for Errors**
- **Disk Cleanup**
- **Full Scan & Repair**

## Disclaimer

This script is provided "as is" without any warranty. Use it at your own risk. The author is not responsible for any damage caused by using this script.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Powered by Kimsec.net**
