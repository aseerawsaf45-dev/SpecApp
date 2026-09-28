@echo off
title Enable Windows Developer Mode

echo =====================================================================
echo             ENABLE WINDOWS DEVELOPER MODE
echo =====================================================================
echo.
echo Requesting administrator privileges to enable Developer Mode...
echo (A Windows User Account Control prompt may appear)
echo.

powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -Command reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock /t REG_DWORD /f /v AllowDevelopmentWithoutDevLicense /d 1'"

echo.
echo If approved, Developer Mode is now enabled for Windows Desktop apps.
echo You can now run 'run_windows.bat' or 'run_app.bat'.
echo.
pause
