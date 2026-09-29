@echo off
setlocal enabledelayedexpansion

title SpecApp - Android APK Builder
color 0A

cd /d "%~dp0"

echo =====================================================================
echo                SPECS APP - ANDROID APK BUILDER
echo =====================================================================
echo.

:: 1. Locate Flutter
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    if exist "C:\flutter\bin\flutter.bat" set "PATH=C:\flutter\bin;!PATH!"
    if exist "C:\src\flutter\bin\flutter.bat" set "PATH=C:\src\flutter\bin;!PATH!"
    if exist "%LOCALAPPDATA%\Programs\flutter\bin\flutter.bat" set "PATH=%LOCALAPPDATA%\Programs\flutter\bin;!PATH!"
    if exist "%USERPROFILE%\flutter\bin\flutter.bat" set "PATH=%USERPROFILE%\flutter\bin;!PATH!"
    if exist "%USERPROFILE%\development\flutter\bin\flutter.bat" set "PATH=%USERPROFILE%\development\flutter\bin;!PATH!"
    if exist "%USERPROFILE%\fvm\default\bin\flutter.bat" set "PATH=%USERPROFILE%\fvm\default\bin;!PATH!"
)

where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo [*] ERROR: Flutter SDK was not found on this computer.
    pause
    exit /b 1
)

:: 2. Set Android environment variables if needed
if "%ANDROID_HOME%"=="" (
    if exist "%LOCALAPPDATA%\Android\Sdk" (
        set "ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk"
        set "ANDROID_SDK_ROOT=%LOCALAPPDATA%\Android\Sdk"
    )
)

echo [*] Building Android Release APK...
echo [*] Command: flutter build apk --release
echo.

call flutter build apk --release

if %errorlevel% equ 0 (
    echo.
    echo =====================================================================
    echo [+] APK Built Successfully!
    echo Location: %~dp0build\app\outputs\flutter-apk\app-release.apk
    echo =====================================================================
    echo.
    explorer /select,"%~dp0build\app\outputs\flutter-apk\app-release.apk"
) else (
    echo.
    echo [*] Build failed with error code %errorlevel%.
)

pause
