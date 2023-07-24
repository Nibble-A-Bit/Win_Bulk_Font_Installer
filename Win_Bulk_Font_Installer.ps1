param (
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [System.IO.FileInfo[]]$src
)
function Install-Font {
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [System.IO.FileInfo[]]$srcDir
    )

    process {
        foreach ($file in $srcDir) {
            try {
                # Check if the font file exists
                if (-not $file.Exists) {
                    Write-Host "Font file not found: $($file.FullName)"
                    continue
                }

                # Get font name and style
                $fontName = $file.Name
                switch ($file.Extension.ToLower()) {
                    ".ttf" { $fontName += " (TrueType)" }
                    ".otf" { $fontName += " (OpenType)" }
                }

                # Check if the font is already installed
                $fontDestinationPath = "$($env:windir)\Fonts\$($file.Name)"
                if (Test-Path $fontDestinationPath) {
                    Write-Host "Font already installed: $($file.Name)"
                    continue
                }

                # Prompt user for confirmation before proceeding
                $confirmation = Read-Host "Are you sure you want to install the font '$fontName'? (Y/N)"
                if ($confirmation -notmatch '^[Yy]$') {
                    Write-Host "Font installation cancelled."
                    continue
                }

                # Copy the font file to the Fonts directory
                Write-Host "Copying font: $($file.Name)"
                Copy-Item -Path $file.FullName -Destination $fontDestinationPath

                # Install the font using AddFontResource
                $result = AddFontResource -LiteralPath $fontDestinationPath
                [System.Runtime.InteropServices.Marshal]::ReleaseComObject($result) | Out-Null

                # Check if the font is already registered
                $fontRegistryPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
                if (Get-ItemProperty -Name $fontName -Path $fontRegistryPath -ErrorAction SilentlyContinue) {
                    Write-Host "Font already registered: $($file.Name)"
                    continue
                }

                # Register the font in the system's font registry
                Write-Host "Registering font: $($file.Name)"
                New-ItemProperty -Name $fontName -Path $fontRegistryPath -PropertyType String -Value $file.Name -Force | Out-Null

                Write-Host "Font installed successfully: $($file.Name)"
            } catch {
                Write-Host "Error installing font: $($file.Name). $_"
            }
        }
    }
}

# Replace "C:\Path\To\Your\FontsDirectory" with the actual path to your fonts directory.
$srcDirs = Get-ChildItem -Path $src -Include "*.ttf","*.otf" -Recurse
Install-Font -srcDir $srcDirs
