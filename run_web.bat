@echo off
setlocal enabledelayedexpansion

title SpecApp - Web Launcher (Chrome)

cd /d "%~dp0"

echo =====================================================================
echo             SPECS APP - CHROME WEB APP LAUNCHER
echo =====================================================================
echo.

where flutter >nul 2>&1
if %errorlevel% neq 0 (
    if exist "C:\flutter\bin\flutter.bat" set "PATH=C:\flutter\bin;!PATH!"
    if exist "C:\src\flutter\bin\flutter.bat" set "PATH=C:\src\flutter\bin;!PATH!"
    if exist "%LOCALAPPDATA%\Programs\flutter\bin\flutter.bat" set "PATH=%LOCALAPPDATA%\Programs\flutter\bin;!PATH!"
    if exist "%USERPROFILE%\flutter\bin\flutter.bat" set "PATH=%USERPROFILE%\flutter\bin;!PATH!"
)

echo Launching app in Google Chrome...
echo Tips: [r] Hot Reload  ^|  [R] Hot Restart  ^|  [q] Quit
echo.
flutter run -d chrome

if %errorlevel% neq 0 goto :on_error
goto :eof

:on_error
echo.
echo [!] App closed or encountered an error.
pause
