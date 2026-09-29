@echo off
setlocal enabledelayedexpansion

title SpecApp - Windows Desktop
color 0E

cd /d "%~dp0"

echo.
echo =====================================================================
echo              SPECS APP - WINDOWS DESKTOP LAUNCHER
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
    echo Please install Flutter and add it to your system PATH:
    echo https://docs.flutter.dev/get-started/install/windows/desktop
    pause
    exit /b 1
)

:: 2. Check if all required Flutter dependencies are installed
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

:: 3. Test symlink support (Windows Developer Mode)
set "TEST_SYMLINK=%TEMP%\symlink_test_%RANDOM%"
cmd /c "mklink ""!TEST_SYMLINK!"" ""%~f0"" >nul 2>&1"
if exist "!TEST_SYMLINK!" goto :symlink_clean
goto :symlink_warn

:symlink_clean
del "!TEST_SYMLINK!" >nul 2>&1
goto :do_launch

:symlink_warn
echo.
echo [*] NOTICE: Windows Developer Mode is currently OFF.
echo     Flutter requires Developer Mode or Admin rights to build Windows plugins.
echo.
echo  [1] Enable Developer Mode automatically (1-Click Admin prompt)
echo  [2] Open Windows Developer Settings to turn ON manually
echo  [3] Launch the Web version instead (Instant, no Developer Mode needed)
echo  [4] Try launching Windows Desktop anyway
echo  [5] Exit
echo.
choice /c 12345 /t 10 /d 3 /m "Select an option (default: 3):"
set "DEV_CHOICE=!errorlevel!"

if "!DEV_CHOICE!"=="1" goto :enable_admin
if "!DEV_CHOICE!"=="2" goto :open_settings
if "!DEV_CHOICE!"=="3" goto :launch_web
if "!DEV_CHOICE!"=="4" goto :do_launch
if "!DEV_CHOICE!"=="5" exit /b 0

:enable_admin
echo.
echo Requesting administrator permission...
powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -Command reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock /t REG_DWORD /f /v AllowDevelopmentWithoutDevLicense /d 1'"
echo If approved, please restart this script or try option 4.
pause
goto :do_launch

:open_settings
echo Opening Windows Developer Settings...
start ms-settings:developers
echo Please switch "Developer Mode" to ON in the Settings window.
pause
goto :do_launch

:launch_web
echo Launching Web version...
call "%~dp0run_web.bat"
exit /b 0

:do_launch
echo.
echo Launching Windows Desktop App...
echo Tips: [r] Hot Reload  ^|  [R] Hot Restart  ^|  [q] Quit
echo.
flutter run -d windows

if %errorlevel% neq 0 (
    echo.
    echo =====================================================================
    echo [*] Windows Desktop encountered an error.
    echo [*] Note: You can always use 'run_web.bat' for an instant experience!
    echo =====================================================================
    echo.
    choice /c YN /m "Would you like to open the instant Web version instead? [Y/N]"
    if errorlevel 2 exit /b 1
    if errorlevel 1 goto :launch_web
)
