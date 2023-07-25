param (
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string[]]$srcDir
)

function Install-Font {
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$srcDir
    )

    # Function to get the formatted font name with style
    function Get-FontName {
        param (
            [string]$file
        )

        $extension = [System.IO.Path]::GetExtension($file).ToLower()
        switch ($extension) {
            ".ttf" { return "$(Split-Path -Leaf $file) (TrueType)" }
            ".otf" { return "$(Split-Path -Leaf $file) (OpenType)" }
            default { return $(Split-Path -Leaf $file) }
        }
    }

    # Process the fonts in the directory and its subdirectories
    $fontFiles = Get-ChildItem -Path $srcDir -Include "*.ttf","*.otf" -File -Recurse
    foreach ($file in $fontFiles) {
        try {
            # Check if the font file exists
            if (-not (Test-Path $file)) {
                Write-Host "Font file not found: $($file)"
                continue
            }

            # Get font name and style
            $fontName = Get-FontName -file $file

            # Check if the font is already installed
            $fontDestinationPath = "$($env:windir)\Fonts\$($file.Name)"
            if (Test-Path $fontDestinationPath) {
                Write-Host "Font already installed: $($file.Name)"
                continue
            }

            # Prompt user for confirmation before proceeding
            $confirmation = Read-Host "Are you sure you want to install the font '$fontName'? (Y/N')"
            if ($confirmation -notmatch '^[Yy]$') {
                Write-Host "Font installation cancelled."
                continue
            }

            # Copy the font file to the Fonts directory
            Write-Host "Copying font: $(Split-Path -Leaf $file)"
            Copy-Item -Path $file -Destination $fontDestinationPath -Force

            # Add a registry entry for the font
            $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
            $registryValueName = "$fontName (TrueType)"
            New-ItemProperty -Path $registryPath -Name $registryValueName -Value $file.FullName -PropertyType String -Force | Out-Null

            Write-Host "Font installed successfully: $(Split-Path -Leaf $file)"
        } catch {
            Write-Host "Error installing font: $(Split-Path -Leaf $file). $_.Exception.Message"
        }
    }
}

# Call the Install-Font function for each font directory in the source directory
$srcDir | Install-Font
