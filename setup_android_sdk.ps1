$ErrorActionPreference = "Stop"

$sdkDir = "$env:LOCALAPPDATA\Android\Sdk"
$cmdlineDir = "$sdkDir\cmdline-tools"
$latestDir = "$cmdlineDir\latest"
$zipPath = "$env:TEMP\cmdline-tools.zip"
$javaHome = "C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot"

Write-Host "=========================================================="
Write-Host "Setting up Android SDK and Build Environment for Flutter"
Write-Host "=========================================================="

# 1. Set JAVA_HOME in current process and user environment
Write-Host "[1/5] Configuring JAVA_HOME..."
$env:JAVA_HOME = $javaHome
$env:PATH = "$javaHome\bin;$env:PATH"
[Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, "User")

# 2. Download Android Command Line Tools
if (-not (Test-Path "$latestDir\bin\sdkmanager.bat")) {
    Write-Host "[2/5] Downloading Android Command Line Tools (~140MB)..."
    New-Item -ItemType Directory -Force -Path $cmdlineDir | Out-Null
    Remove-Item $zipPath -Force -ErrorAction SilentlyContinue

    $url = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
    & C:\Windows\system32\curl.exe -L -o "$zipPath" "$url" --progress-bar

    Write-Host "[2/5] Extracting Command Line Tools..."
    Expand-Archive -Path $zipPath -DestinationPath $cmdlineDir -Force
    Remove-Item $zipPath -Force -ErrorAction SilentlyContinue

    if (Test-Path "$cmdlineDir\cmdline-tools") {
        if (Test-Path $latestDir) { Remove-Item $latestDir -Recurse -Force }
        Rename-Item -Path "$cmdlineDir\cmdline-tools" -NewName "latest"
    }
} else {
    Write-Host "[2/5] Android Command Line Tools already exist."
}

# 3. Configure Android SDK path in environment
Write-Host "[3/5] Configuring Android SDK environment..."
$env:ANDROID_HOME = $sdkDir
$env:ANDROID_SDK_ROOT = $sdkDir
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdkDir, "User")
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $sdkDir, "User")

# 4. Accept licenses and install platform-tools, platforms, build-tools
Write-Host "[4/5] Installing Android Platform Tools & Build Tools..."
$sdkManager = "$latestDir\bin\sdkmanager.bat"

# Accept all licenses automatically
"y`ny`ny`ny`ny`ny`ny`ny`ny`ny`ny`ny`ny" | & $sdkManager --licenses --sdk_root=$sdkDir

# Install required components
& $sdkManager --sdk_root=$sdkDir "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# 5. Configure Flutter
Write-Host "[5/5] Configuring Flutter Android SDK..."
flutter config --android-sdk $sdkDir
"y`ny`ny`ny`ny`ny`ny`ny`ny`ny`ny" | flutter doctor --android-licenses

Write-Host "=========================================================="
Write-Host "[+] Android SDK setup complete!"
Write-Host "=========================================================="
