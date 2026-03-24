# Store the current directory in a variable
$currentDir = Get-Location
# Define the subdirectory name within %TEMP%
$tempSubDirName = "ubuntu-installation"

# Construct the full path to the temporary subdirectory
$tempDirPath = Join-Path $env:TEMP $tempSubDirName

# Create the temporary subdirectory
if (-not (Test-Path $tempDirPath -PathType Container)) {
    New-Item -ItemType Directory -Path $tempDirPath | Out-Null
}

# Check if the directory was created successfully
if (Test-Path $tempDirPath -PathType Container) {
    # Move to the temporary subdirectory
    Set-Location $tempDirPath

    # ... Perform your operations in the temporary directory here ...
    # Define the URL for the file you want to download
    $url = "https://cloud-images.ubuntu.com/releases/23.10/release/ubuntu-23.10-server-cloudimg-amd64-root.tar.xz"

    # Define the output file name
    $outputFileName = "ubuntu-23.10-wsl-root-tar.xz"
    Write-Host ""
    Write-Host "Installing Ubuntu for WSL2..."
    Write-Host ""
    Write-Host "Downloading: $outputFileName to $tempDirPath ..."
    # Define the output directory and file name
    $outputFileName = Join-Path $tempDirPath "ubuntu-23.10-wsl-root-tar.xz"


    $webClient = New-Object System.Net.WebClient

    # Download the file
    $webClient.DownloadFile($url, $outputFileName)

    # Dispose of the WebClient object
    $webClient.Dispose()

    Write-Host "Importing Ubuntu WSL..."
    wsl --import ubuntu-test C:\Users\mpk\wsl\test2 .\ubuntu-23.10-wsl-root-tar.xz

    # Move back to the original directory
    Set-Location $currentDir

    # Delete the temporary directory
    Remove-Item -Path $tempDirPath -Force -Recurse
    Write-Host "Deleted the temporary directory: $tempDirPath"
} else {
    Write-Host "Failed to create or access the temporary directory: $tempDirPath"
}

wsl.exe -d ubuntu-test bash -c "curl -H 'Cache-Control: no-cache' -s https://raw.githubusercontent.com/mpeki/ubuntu-pc-setup/main/init.sh | bash"

Write-Host "Restarting WLS ..."
wsl.exe --terminate ubuntu-test

wsl.exe -d ubuntu-test

wsl.exe --terminate ubuntu-test

wsl.exe -d ubuntu-test