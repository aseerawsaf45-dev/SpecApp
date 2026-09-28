@echo off
setlocal enabledelayedexpansion

title SpecApp - PC Launcher

cd /d "%~dp0"

echo =====================================================================
echo                SPECS APP - ONE CLICK PC LAUNCHER
echo =====================================================================
echo.

:: 1. Check if Flutter is installed / available in PATH
where flutter >nul 2>&1
if %errorlevel% neq 0 goto :find_flutter
goto :check_symlinks

:find_flutter
echo [!] Flutter was not found in your system PATH.
echo [*] Checking common Flutter install paths...

if exist "C:\flutter\bin\flutter.bat" (
    set "PATH=C:\flutter\bin;!PATH!"
    echo [+] Found Flutter in C:\flutter\bin
    goto :check_symlinks
)
if exist "C:\src\flutter\bin\flutter.bat" (
    set "PATH=C:\src\flutter\bin;!PATH!"
    echo [+] Found Flutter in C:\src\flutter\bin
    goto :check_symlinks
)
if exist "%LOCALAPPDATA%\Programs\flutter\bin\flutter.bat" (
    set "PATH=%LOCALAPPDATA%\Programs\flutter\bin;!PATH!"
    echo [+] Found Flutter in %LOCALAPPDATA%\Programs\flutter\bin
    goto :check_symlinks
)
if exist "%USERPROFILE%\flutter\bin\flutter.bat" (
    set "PATH=%USERPROFILE%\flutter\bin;!PATH!"
    echo [+] Found Flutter in %USERPROFILE%\flutter\bin
    goto :check_symlinks
)
if exist "%USERPROFILE%\development\flutter\bin\flutter.bat" (
    set "PATH=%USERPROFILE%\development\flutter\bin;!PATH!"
    echo [+] Found Flutter in %USERPROFILE%\development\flutter\bin
    goto :check_symlinks
)
if exist "%USERPROFILE%\fvm\default\bin\flutter.bat" (
    set "PATH=%USERPROFILE%\fvm\default\bin;!PATH!"
    echo [+] Found Flutter via FVM
    goto :check_symlinks
)

echo.
echo [ERROR] Flutter SDK could not be located on this computer.
echo Please ensure Flutter is installed and added to your system PATH.
echo Download: https://docs.flutter.dev/get-started/install/windows/desktop
echo.
pause
exit /b 1

:check_symlinks
set "SYMLINK_OK=0"
set "TEST_SYMLINK=%TEMP%\symlink_test_%RANDOM%"
cmd /c "mklink ""!TEST_SYMLINK!"" ""%~f0"" >nul 2>&1"
if exist "!TEST_SYMLINK!" (
    set "SYMLINK_OK=1"
    del "!TEST_SYMLINK!" >nul 2>&1
)

if "!SYMLINK_OK!"=="1" goto :dev_mode_ready
goto :dev_mode_needed

:dev_mode_ready
echo [OK] Windows Desktop environment is fully ready.
echo.
echo [1] Launch Native Windows Desktop App  [Auto-start in 3s]
echo [2] Launch in Google Chrome Browser
echo [3] Launch in Microsoft Edge Browser
echo [4] Run Flutter Pub Get (Refresh Dependencies)
echo [5] Exit
echo.
choice /c 12345 /t 3 /d 1 /m "Select an option:"
set "OPT=!errorlevel!"
goto :handle_launch

:dev_mode_needed
echo [NOTICE] Windows Developer Mode is currently OFF.
echo          Native Windows Desktop requires Developer Mode or Admin rights
echo          to enable plugin symlinks.
echo.
echo [1] Launch in Google Chrome Browser (Instant, recommended) [Auto-start in 5s]
echo [2] Enable Developer Mode (Opens Windows Developer Settings)
echo [3] Enable Developer Mode via 1-Click Administrator Prompt
echo [4] Force Launch Native Windows Desktop anyway
echo [5] Launch in Microsoft Edge Browser
echo [6] Exit
echo.
choice /c 123456 /t 5 /d 1 /m "Select an option:"
set "OPT_DEV=!errorlevel!"

if "!OPT_DEV!"=="1" set "OPT=2"
if "!OPT_DEV!"=="2" goto :open_settings
if "!OPT_DEV!"=="3" goto :enable_dev_mode
if "!OPT_DEV!"=="4" set "OPT=1"
if "!OPT_DEV!"=="5" set "OPT=3"
if "!OPT_DEV!"=="6" exit /b 0
goto :handle_launch

:handle_launch
if "!OPT!"=="1" goto :launch_windows
if "!OPT!"=="2" goto :launch_chrome
if "!OPT!"=="3" goto :launch_edge
if "!OPT!"=="4" goto :do_pub_get
if "!OPT!"=="5" exit /b 0
goto :launch_windows

:launch_windows
echo.
echo =====================================================================
echo Launching Native Windows Desktop App...
echo Tips while running:
echo   [r] Hot Reload  ^|  [R] Hot Restart  ^|  [q] Quit
echo =====================================================================
echo.
flutter run -d windows
goto :after_run

:launch_chrome
echo.
echo =====================================================================
echo Launching App in Google Chrome...
echo Tips while running:
echo   [r] Hot Reload  ^|  [R] Hot Restart  ^|  [q] Quit
echo =====================================================================
echo.
flutter run -d chrome
goto :after_run

:launch_edge
echo.
echo =====================================================================
echo Launching App in Microsoft Edge...
echo Tips while running:
echo   [r] Hot Reload  ^|  [R] Hot Restart  ^|  [q] Quit
echo =====================================================================
echo.
flutter run -d edge
goto :after_run

:do_pub_get
echo.
echo Fetching Flutter packages...
flutter pub get
echo.
pause
goto :check_symlinks

:open_settings
echo.
echo Opening Windows Developer Settings...
start ms-settings:developers
echo Please switch "Developer Mode" to ON.
echo Once turned on, run this script again to launch the Native Windows App!
echo.
pause
exit /b 0

:enable_dev_mode
echo.
echo Requesting administrator permission to enable Developer Mode...
powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -Command reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock /t REG_DWORD /f /v AllowDevelopmentWithoutDevLicense /d 1'"
echo.
echo If you accepted the administrator prompt, Developer Mode is now active.
echo Press any key to launch the Native Windows Desktop App...
pause >nul
goto :launch_windows

:after_run
echo.
echo =====================================================================
echo App execution finished.
echo =====================================================================
echo.
choice /c YN /m "Would you like to restart the app? (Y/N)"
if errorlevel 2 exit /b 0
if errorlevel 1 goto :handle_launch
