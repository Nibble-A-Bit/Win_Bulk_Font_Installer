param (
    [Parameter(Mandatory = $true)]
    [System.IO.FileInfo]$src
)
function Install-Font {
    param (
        [System.IO.FileInfo]$fontFile
    )

    try {
        # Check if the font file exists
        if (-not $fontFile.Exists) {
            throw "Font file not found: $($fontFile.FullName)"
        }

        # Get font name and style
        $fontName = $fontFile.Name
        switch ($fontFile.Extension.ToLower()) {
            ".ttf" { $fontName += " (TrueType)" }
            ".otf" { $fontName += " (OpenType)" }
        }

        # Check if the font is already installed
        $fontDestinationPath = "$($env:windir)\Fonts\$($fontFile.Name)"
        if (Test-Path $fontDestinationPath) {
            Write-Host "Font already installed: $($fontFile.Name)"
            return
        }

        # Prompt user for confirmation before proceeding
        $confirmation = Read-Host "Are you sure you want to install the font '$fontName'? (Y/N)"
        if ($confirmation -notmatch '^[Yy]$') {
            Write-Host "Font installation cancelled."
            return
        }

        # Copy the font file to the Fonts directory
        Write-Host "Copying font: $($fontFile.Name)"
        Copy-Item -Path $fontFile.FullName -Destination $fontDestinationPath

        # Install the font using AddFontResource
        $null = AddFontResource -LiteralPath $fontDestinationPath
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($null) | Out-Null

        # Check if the font is already registered
        $fontRegistryPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
        if (Get-ItemProperty -Name $fontName -Path $fontRegistryPath -ErrorAction SilentlyContinue) {
            Write-Host "Font already registered: $($fontFile.Name)"
            return
        }

        # Register the font in the system's font registry
        Write-Host "Registering font: $($fontFile.Name)"
        New-ItemProperty -Name $fontName -Path $fontRegistryPath -PropertyType String -Value $fontFile.Name -Force | Out-Null

        Write-Host "Font installed successfully: $($fontFile.Name)"
    } catch {
        Write-Host "Error installing font: $($fontFile.Name). $_"
    }
}


Install-Font -fontFile $src