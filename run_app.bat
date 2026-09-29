@echo off
setlocal enabledelayedexpansion

title SpecApp - PC Launcher
color 0E

cd /d "%~dp0"

:main_entry
echo.
echo =====================================================================
echo                SPECS APP - ONE CLICK PC LAUNCHER
echo =====================================================================
echo.

:: 1. Check Python availability for instant web launcher
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

:: 2. Check if Flutter is installed / available in PATH
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
    echo Please ensure Flutter is installed and added to your system PATH:
    echo Download: https://docs.flutter.dev/get-started/install/windows/desktop
    echo.
    pause
    exit /b 1
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
    echo.
    echo [+] All packages and dependencies installed successfully!
    echo.
) else (
    echo [+] All Flutter dependencies are verified and installed.
)

:: 4. Test symlink support (Windows Developer Mode)
set "SYMLINK_OK=0"
set "TEST_SYMLINK=%TEMP%\symlink_test_%RANDOM%"
cmd /c "mklink ""!TEST_SYMLINK!"" ""%~f0"" >nul 2>&1"
if exist "!TEST_SYMLINK!" (
    set "SYMLINK_OK=1"
    del "!TEST_SYMLINK!" >nul 2>&1
)

:: 5. Check if pre-compiled web build exists
set "HAS_WEB_BUILD=0"
if exist "build\web\index.html" set "HAS_WEB_BUILD=1"

:menu
echo ---------------------------------------------------------------------
echo  [STATUS] Dependencies: READY - Verified and active
if "!HAS_WEB_BUILD!"=="1" (
    echo  [STATUS] Production App: READY - Instant Launch Available
) else (
    echo  [STATUS] Production App: Needs Initial Build
)

if "!SYMLINK_OK!"=="1" (
    echo  [STATUS] Windows Desktop Engine: READY - Developer Mode ON
) else (
    echo  [STATUS] Windows Desktop Engine: Developer Mode OFF - Web Recommended
)
echo ---------------------------------------------------------------------
echo.
echo  [1] Instant Launch Web App   [Recommended - Opens in 1 sec]
echo  [2] Launch Native Windows Desktop App
echo  [3] Live Developer Mode (Google Chrome with Hot Reload)
echo  [4] Live Developer Mode (Microsoft Edge with Hot Reload)
echo  [5] Re-install / Refresh Dependencies (flutter pub get)
echo  [6] Recompile Production Web Build (flutter build web)
echo  [7] Enable Windows Developer Mode (for Native Desktop)
echo  [8] Exit
echo.
echo =====================================================================

choice /c 12345678 /t 4 /d 1 /m "Select option (default: 1):"
set "USER_CHOICE=!errorlevel!"

if "!USER_CHOICE!"=="1" goto :do_instant_web
if "!USER_CHOICE!"=="2" goto :do_windows_desktop
if "!USER_CHOICE!"=="3" goto :do_dev_chrome
if "!USER_CHOICE!"=="4" goto :do_dev_edge
if "!USER_CHOICE!"=="5" goto :do_pub_get
if "!USER_CHOICE!"=="6" goto :do_recompile_web
if "!USER_CHOICE!"=="7" goto :do_enable_dev_mode
if "!USER_CHOICE!"=="8" exit /b 0
goto :do_instant_web

:: -----------------------------------------------------------------
:do_instant_web
echo.
echo =====================================================================
echo Launching AppSpecs Instant Web Server...
echo =====================================================================
echo.

if "!HAS_WEB_BUILD!"=="0" (
    echo [*] Production build not found. Compiling web assets for the first time...
    echo [*] Please wait a moment while Flutter builds the web bundle...
    flutter build web
    if !errorlevel! neq 0 (
        echo [*] Web compilation failed.
        pause
        goto :menu
    )
    set "HAS_WEB_BUILD=1"
)

if "!HAS_PYTHON!"=="1" (
    python launch_server.py
    goto :after_run
)

echo [*] Python not detected. Starting via Flutter Chrome engine...
echo [*] Note: Initial debug compile takes ~30-60 seconds.
flutter run -d chrome
goto :after_run

:: -----------------------------------------------------------------
:do_windows_desktop
echo.
echo =====================================================================
echo Launching Native Windows Desktop App...
echo =====================================================================
echo.

if "!SYMLINK_OK!"=="0" (
    echo [*] NOTICE: Windows Developer Mode is currently OFF.
    echo     Flutter requires Developer Mode or Admin rights to link plugins.
    echo.
    echo [1] Enable Developer Mode automatically (1-Click Admin prompt)
    echo [2] Open Windows Developer Settings
    echo [3] Switch to Instant Web App instead (Opens in 1s)
    echo [4] Cancel
    echo.
    choice /c 1234 /t 10 /d 3 /m "Select an option:"
    set "DEV_OPT=!errorlevel!"
    if "!DEV_OPT!"=="1" goto :do_enable_dev_mode
    if "!DEV_OPT!"=="2" (
        start ms-settings:developers
        echo Please switch "Developer Mode" to ON in Settings, then press any key.
        pause
        goto :do_windows_desktop
    )
    if "!DEV_OPT!"=="3" goto :do_instant_web
    if "!DEV_OPT!"=="4" exit /b 0
)

echo [*] Starting Windows Desktop compilation...
echo Tips: [r] Hot Reload  ^|  [R] Hot Restart  ^|  [q] Quit
echo.
flutter run -d windows
goto :after_run

:: -----------------------------------------------------------------
:do_dev_chrome
echo.
echo =====================================================================
echo Launching App in Google Chrome (Developer Mode)...
echo =====================================================================
echo [*] Compiling Dart debug code. Browser will open shortly...
echo Tips: [r] Hot Reload  ^|  [R] Hot Restart  ^|  [q] Quit
echo.
flutter run -d chrome
goto :after_run

:: -----------------------------------------------------------------
:do_dev_edge
echo.
echo =====================================================================
echo Launching App in Microsoft Edge (Developer Mode)...
echo =====================================================================
echo [*] Compiling Dart debug code. Browser will open shortly...
echo Tips: [r] Hot Reload  ^|  [R] Hot Restart  ^|  [q] Quit
echo.
flutter run -d edge
goto :after_run

:: -----------------------------------------------------------------
:do_pub_get
echo.
echo =====================================================================
echo Installing / Refreshing Flutter Dependencies...
echo =====================================================================
echo.
flutter pub get
echo.
echo Dependencies updated! Press any key to return to menu...
pause >nul
goto :menu

:: -----------------------------------------------------------------
:do_enable_dev_mode
echo.
echo =====================================================================
echo Enabling Windows Developer Mode...
echo =====================================================================
echo Requesting administrator permission...
powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -Command reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock /t REG_DWORD /f /v AllowDevelopmentWithoutDevLicense /d 1'"
echo.
echo If approved, Developer Mode has been requested.
echo Press any key to return to menu...
pause >nul
goto :menu

:: -----------------------------------------------------------------
:do_recompile_web
echo.
echo =====================================================================
echo Recompiling Production Web Bundle...
echo =====================================================================
flutter build web
echo.
echo Web build updated! Press any key to continue...
pause >nul
goto :menu

:: -----------------------------------------------------------------
:after_run
echo.
echo =====================================================================
echo Execution finished.
echo =====================================================================
echo.
choice /c YN /m "Would you like to return to the menu? (Y/N)"
if errorlevel 2 exit /b 0
if errorlevel 1 goto :menu
