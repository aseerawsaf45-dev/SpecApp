@echo off
setlocal enabledelayedexpansion

title SpecApp - Web Launcher
color 0E

cd /d "%~dp0"

echo.
echo =====================================================================
echo             SPECS APP - INSTANT WEB LAUNCHER
echo =====================================================================
echo.

:: 1. Check for Python
set "HAS_PYTHON=0"
where python >nul 2>&1
if %errorlevel% equ 0 set "HAS_PYTHON=1"
if "!HAS_PYTHON!"=="0" (
    where py >nul 2>&1
    if %errorlevel% equ 0 (
        set "HAS_PYTHON=1"
        doskey python=py $* >nul 2>&1
    )
)

:: 2. Locate Flutter
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    if exist "C:\flutter\bin\flutter.bat" set "PATH=C:\flutter\bin;!PATH!"
    if exist "C:\src\flutter\bin\flutter.bat" set "PATH=C:\src\flutter\bin;!PATH!"
    if exist "%LOCALAPPDATA%\Programs\flutter\bin\flutter.bat" set "PATH=%LOCALAPPDATA%\Programs\flutter\bin;!PATH!"
    if exist "%USERPROFILE%\flutter\bin\flutter.bat" set "PATH=%USERPROFILE%\flutter\bin;!PATH!"
    if exist "%USERPROFILE%\development\flutter\bin\flutter.bat" set "PATH=%USERPROFILE%\development\flutter\bin;!PATH!"
    if exist "%USERPROFILE%\fvm\default\bin\flutter.bat" set "PATH=%USERPROFILE%\fvm\default\bin;!PATH!"
)

:: 3. Check if all required Flutter dependencies are installed
echo [*] Checking project dependencies...
set "DEPS_OK=1"
if not exist ".dart_tool\package_config.json" set "DEPS_OK=0"
if not exist "pubspec.lock" set "DEPS_OK=0"

if "!DEPS_OK!"=="1" (
    findstr /i /c:"flutter_riverpod" ".dart_tool\package_config.json" >nul 2>&1 || set "DEPS_OK=0"
    findstr /i /c:"go_router" ".dart_tool\package_config.json" >nul 2>&1 || set "DEPS_OK=0"
    findstr /i /c:"google_fonts" ".dart_tool\package_config.json" >nul 2>&1 || set "DEPS_OK=0"
    findstr /i /c:"intl" ".dart_tool\package_config.json" >nul 2>&1 || set "DEPS_OK=0"
)

if "!DEPS_OK!"=="0" (
    echo [*] Missing dependencies detected! Installing packages now...
    echo [*] Running: flutter pub get
    echo.
    flutter pub get
    if !errorlevel! neq 0 (
        echo.
        echo [*] ERROR: Failed to install Flutter dependencies.
        echo Please check your internet connection and try again.
        echo.
        pause
        exit /b 1
    )
    echo [+] All packages and dependencies installed successfully!
    echo.
) else (
    echo [+] All Flutter dependencies are verified and installed.
)

:: 4. Check for pre-built web assets
if not exist "build\web\index.html" (
    echo [*] Production build not found. Compiling web assets for the first time...
    echo [*] This will take approximately 1-2 minutes...
    flutter build web
    if !errorlevel! neq 0 (
        echo.
        echo [*] Flutter build web failed.
        pause
        exit /b 1
    )
)

:: 5. Launch local server
if "!HAS_PYTHON!"=="1" (
    echo [+] Starting high-speed local server...
    python launch_server.py
    pause
    exit /b 0
)

:: Fallback if Python is missing
echo [*] Python not found. Launching via Flutter Chrome runner...
flutter run -d chrome
pause
