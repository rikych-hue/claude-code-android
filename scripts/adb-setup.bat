@echo off
:: adb-setup.bat — Run on Windows PC to prevent Android from killing Termux
:: Requires ADB: https://developer.android.com/tools/releases/platform-tools
:: Enable Wireless Debugging on phone: Settings > Developer Options > Wireless Debugging

title ADB Anti-Suspension Setup for Termux

echo ================================================
echo   Claude Code Android — ADB Setup
echo   Prevents Android from killing Termux
echo ================================================
echo.
echo Make sure:
echo   1. USB Debugging OR Wireless Debugging is enabled
echo   2. Your phone is connected (USB or same WiFi)
echo.
echo Checking ADB connection...
adb devices
echo.

echo [1/5] Exempting Termux from Doze mode...
adb shell dumpsys deviceidle whitelist +com.termux
adb shell cmd deviceidle whitelist +com.termux

echo [2/5] Allowing background execution...
adb shell cmd appops set com.termux RUN_IN_BACKGROUND allow

echo [3/5] Allowing wake lock...
adb shell cmd appops set com.termux WAKE_LOCK allow

echo [4/5] Disabling app standby...
adb shell settings put global app_standby_enabled 0

echo [5/5] Removing process kill limits (Samsung/One UI fix)...
adb shell cmd device_config put activity_manager max_phantom_processes 2147483647

echo.
echo ================================================
echo   Done! Termux will now stay alive in background
echo ================================================
echo.
pause
