@echo off
setlocal EnableExtensions EnableDelayedExpansion

chcp 65001 >nul

rem ============================================================
rem graphify portable installer (Windows CMD)
rem usage: double-click or run install.cmd [target_dir]
rem ============================================================

set "SCRIPT_DIR=%~dp0"

rem default target directory: C:\graphify-portable
if "%~1"=="" (
    set "INSTALL_DIR=C:\graphify-portable"
) else (
    set "INSTALL_DIR=%~1"
)

echo.
echo ==============================================
echo   graphify portable installer (Python 3.12)
echo ==============================================
echo.
echo install dir: %INSTALL_DIR%
echo.

rem detect Python
set "PYTHON="
for /f "delims=" %%i in ('where python 2^>nul') do (
    if "!PYTHON!"=="" set "PYTHON=%%i"
)
if "%PYTHON%"=="" (
    for /f "delims=" %%i in ('where python3 2^>nul') do (
        if "!PYTHON!"=="" set "PYTHON=%%i"
    )
)
if "%PYTHON%"=="" (
    echo [ERROR] Python not found. Install Python 3.10+ first.
    echo Download: https://www.python.org/downloads/
    pause
    exit /b 1
)
echo Python: %PYTHON%
"%PYTHON%" --version

rem check Python version >= 3.10
for /f "tokens=2" %%v in ('"%PYTHON%" --version 2^>^&1') do set "PYVER=%%v"
echo detected Python %PYVER%
for /f "tokens=1,2 delims=." %%a in ("%PYVER%") do (
    set "MAJOR=%%a"
    set "MINOR=%%b"
)
if %MAJOR% LSS 3 (
    echo [ERROR] Python 3.10+ required, current: %PYVER%
    pause
    exit /b 1
)
if %MAJOR% EQU 3 if %MINOR% LSS 10 (
    echo [ERROR] Python 3.10+ required, current: %PYVER%
    pause
    exit /b 1
)

rem create target directory
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

rem copy vendor packages
echo.
echo [1/2] copying dependencies to %INSTALL_DIR%...
xcopy /E /I /Y "%SCRIPT_DIR%vendor" "%INSTALL_DIR%\vendor" >nul
if errorlevel 1 (
    echo [ERROR] failed to copy vendor
    pause
    exit /b 1
)
echo   done

rem copy launcher
echo [2/2] copying launcher...
copy /Y "%SCRIPT_DIR%graphify.cmd" "%INSTALL_DIR%\graphify.cmd" >nul

rem ask whether to add to PATH
echo.
echo Add graphify to system PATH? (Y/N)
echo Y: run "graphify" from any folder
echo N: run it from %INSTALL_DIR%
set /p ADD_PATH="Your choice [Y/N]: "

if /i "%ADD_PATH%"=="Y" (
    echo adding to PATH...
    setx PATH "%INSTALL_DIR%;%PATH%" >nul
    if errorlevel 1 (
        echo [WARN] failed to update PATH. Add %INSTALL_DIR% manually.
        echo       Or re-run this script as Administrator.
    ) else (
        echo   PATH updated. Open a new terminal to use it.
    )
)

echo.
echo ==============================================
echo   Installation complete!
echo ==============================================
echo.
echo Usage:
echo   graphify .         对当前目录构建知识图谱
echo   graphify --help    Show full help
echo.
echo Output files:
echo   graphify-out/
echo     graph.html       交互式知识图谱
echo     GRAPH_REPORT.md  文本报告
echo     graph.json       原始数据
echo.
echo Note: this package was built with Python 3.12.
echo       If the system Python version differs, it may need repackaging.
echo.
pause
