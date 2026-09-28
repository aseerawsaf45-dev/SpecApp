@echo off
setlocal enabledelayedexpansion

title SpecApp - Windows Desktop

cd /d "%~dp0"

echo =====================================================================
echo              SPECS APP - WINDOWS DESKTOP LAUNCHER
echo =====================================================================
echo.

where flutter >nul 2>&1
if %errorlevel% neq 0 (
    if exist "C:\flutter\bin\flutter.bat" set "PATH=C:\flutter\bin;!PATH!"
    if exist "C:\src\flutter\bin\flutter.bat" set "PATH=C:\src\flutter\bin;!PATH!"
    if exist "%LOCALAPPDATA%\Programs\flutter\bin\flutter.bat" set "PATH=%LOCALAPPDATA%\Programs\flutter\bin;!PATH!"
    if exist "%USERPROFILE%\flutter\bin\flutter.bat" set "PATH=%USERPROFILE%\flutter\bin;!PATH!"
)

set "TEST_SYMLINK=%TEMP%\symlink_test_%RANDOM%"
cmd /c "mklink ""!TEST_SYMLINK!"" ""%~f0"" >nul 2>&1"
if exist "!TEST_SYMLINK!" goto :symlink_clean
goto :symlink_warn

:symlink_clean
del "!TEST_SYMLINK!" >nul 2>&1
goto :do_launch

:symlink_warn
echo [WARNING] Windows Developer Mode is currently OFF.
echo Flutter requires Developer Mode enabled to build Windows desktop plugins.
echo.
echo Opening Windows Developer Settings for you...
start ms-settings:developers
echo Please switch Developer Mode to ON in the Settings window.
echo.
choice /c YN /m "Would you like to try launching anyway? [Y/N]"
if errorlevel 2 exit /b 1
goto :do_launch

:do_launch
echo.
echo Launching Windows Desktop App...
echo Tips: [r] Hot Reload  ^|  [R] Hot Restart  ^|  [q] Quit
echo.
flutter run -d windows

if %errorlevel% neq 0 (
    echo.
    echo [!] App closed or encountered an error.
    pause
)
