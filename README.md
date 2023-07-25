Certainly! Here's the revised GitHub README for the "Win_Bulk_Font_Installer" repository:

# Win Bulk Font Installer - Install Fonts Recursively

![Win Bulk Font Installer](https://github.com/YourGitHubUsername/Win_Bulk_Font_Installer/blob/main/FontInstallerLogo.png)

## Overview

Win Bulk Font Installer is a PowerShell script designed to install fonts contained within multiple directories recursively. The script will scan the specified source directory and its subdirectories for TrueType (.ttf) and OpenType (.otf) font files and then proceed to install each font.

## Features

- Installs fonts contained in multiple directories recursively.
- Supports TrueType (.ttf) and OpenType (.otf) font formats.
- Checks if the font is already installed before proceeding.
- Prompts the user for confirmation before installing each font.
- Registers fonts in the system's font registry.

## Prerequisites

- PowerShell 3.0 or higher.

## How to Use

1. Clone or download the repository to your local machine.

2. Open a PowerShell terminal.

3. Ensure that PowerShell script execution is allowed on your system. If not, you can enable it by running PowerShell as Administrator and executing the following command:

   ```powershell
   Set-ExecutionPolicy RemoteSigned
   ```

   Choose "Y" or "A" when prompted.

4. Change the directory to the location of the script file.

5. Run the script using the following command:

   ```powershell
   .\Win_Bulk_Font_Installer.ps1 -src "C:\Fonts"
   ```

   Replace "C:\Fonts" with the path to the source directory containing the font files you want to install.

6. The script will process all the font files found in the source directory and its subdirectories. It will copy each font file to the Fonts directory (C:\Windows\Fonts) and register it in the system's font registry.

7. Before installing each font, the script will prompt you for confirmation. Type "Y" or "N" to proceed or cancel the installation.

## Example

```powershell
PS C:\Scripts> .\Win_Bulk_Font_Installer.ps1 -src "C:\Fonts"
Font file not found: C:\Fonts\FontExample.ttf
Copying font: FontExample.otf
Are you sure you want to install the font 'FontExample (OpenType)'? (Y/N'): Y
Registering font: FontExample (OpenType)
Font installed successfully: FontExample.otf
Font already installed: AnotherFont.ttf
Font installation cancelled.
```

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Contributions

Contributions to the project are welcome. If you find any issues or have suggestions for improvements, feel free to create a pull request or submit an issue.

## Disclaimer

This script is provided as-is, without any warranty or guarantee of any kind. The author is not responsible for any damage caused by the usage of this script.

## Credits

This script was created by [Cornelis Terblanche](https://github.com/KR34T1V) and inspired by the need for an efficient font installation tool.

---

Thank you for using Win Bulk Font Installer! If you have any questions or feedback, please don't hesitate to reach out. Happy font installing!