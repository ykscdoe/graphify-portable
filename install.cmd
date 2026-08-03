@echo off
setlocal

set "SCRIPT_DIR=%~dp0"

if "%~1"=="" (
    set "INSTALL_DIR=C:\graphify-portable"
) else (
    set "INSTALL_DIR=%~1"
)

echo.
echo install dir: %INSTALL_DIR%
echo.

set "PYTHON="
for /f "delims=" %%i in ('where python 2^>nul') do set "PYTHON=%%i" & goto :python_found
if "%PYTHON%"=="" (
    for /f "delims=" %%i in ('where python3 2^>nul') do set "PYTHON=%%i" & goto :python_found
)
if "%PYTHON%"=="" (
    echo Python 3.10+ not found.
    exit /b 1
)

:python_found
echo Python: %PYTHON%
for /f "tokens=2" %%v in ('"%PYTHON%" --version 2^>^&1') do set "PYVER=%%v"
echo version: %PYVER%

for /f "tokens=1,2 delims=." %%a in ("%PYVER%") do (
    set "MAJOR=%%a"
    set "MINOR=%%b"
)
if %MAJOR% LSS 3 (
    echo Python 3.10+ required.
    exit /b 1
)
if %MAJOR% EQU 3 if %MINOR% LSS 10 (
    echo Python 3.10+ required.
    exit /b 1
)

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

xcopy /E /I /Y "%SCRIPT_DIR%vendor" "%INSTALL_DIR%\vendor" >nul
if errorlevel 1 (
    echo Failed to copy vendor.
    exit /b 1
)

copy /Y "%SCRIPT_DIR%graphify.cmd" "%INSTALL_DIR%\graphify.cmd" >nul
if errorlevel 1 (
    echo Failed to copy graphify.cmd.
    exit /b 1
)

echo.
echo Add to PATH? [Y/N]
set /p "ADD_PATH="

if /i "%ADD_PATH%"=="Y" (
    setx PATH "%INSTALL_DIR%;%PATH%" >nul
)

echo.
echo Install complete.
echo Run: %INSTALL_DIR%\graphify.cmd --help
