@echo off
setlocal
cd /d "%~dp0"

where flutter.bat >nul 2>nul
if errorlevel 1 goto flutter_missing

where java.exe >nul 2>nul
if errorlevel 1 goto java_missing

echo [1/5] Resolving packages...
call flutter pub get
if errorlevel 1 goto failed

where node.exe >nul 2>nul
if errorlevel 1 goto skip_data_check
echo [2/5] Verifying offline assets...
call node tool\verify_project.js
if errorlevel 1 goto failed
goto analyze

:skip_data_check
echo [2/5] Node.js is unavailable; skipping the optional asset check.

:analyze
echo [3/5] Analyzing source...
call flutter analyze
if errorlevel 1 goto failed

echo [4/5] Running tests...
call flutter test
if errorlevel 1 goto failed

echo [5/5] Building release APK...
call flutter build apk --release
if errorlevel 1 goto failed

if not exist "build\app\outputs\flutter-apk\app-release.apk" goto failed
copy /y "build\app\outputs\flutter-apk\app-release.apk" "%~dp0daguan-math-community-v1.1.0.apk" >nul

echo.
echo Build complete:
echo %~dp0daguan-math-community-v1.1.0.apk
echo.
pause
exit /b 0

:flutter_missing
echo.
echo Flutter was not found. Install Flutter 3.44.8 and add it to PATH.
echo.
pause
exit /b 1

:java_missing
echo.
echo Java was not found. Install JDK 17 and add it to PATH.
echo.
pause
exit /b 1

:failed
echo.
echo Build failed. Review the error output above.
echo.
pause
exit /b 1
