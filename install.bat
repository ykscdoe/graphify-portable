@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: graphify 便携安装脚本 (Windows)
:: 用法: 右键 "以管理员身份运行" 或直接双击
::       也可以在命令行中运行: install.bat [目标目录]
:: ============================================================

set "SCRIPT_DIR=%~dp0"

:: 目标安装目录 (默认 C:\graphify-portable)
if "%~1"=="" (
    set "INSTALL_DIR=C:\graphify-portable"
) else (
    set "INSTALL_DIR=%~1"
)

echo.
echo ==============================================
echo   graphify 便携版安装程序
echo ==============================================
echo.
echo 安装目录: %INSTALL_DIR%
echo.

:: 检测 Python
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
    echo [错误] 未找到 Python。请先安装 Python 3.10+。
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)
echo Python: %PYTHON%
"%PYTHON%" --version

:: 创建目标目录
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: 复制 vendor 包
echo.
echo 正在复制依赖包...
xcopy /E /I /Y /Q "%SCRIPT_DIR%vendor" "%INSTALL_DIR%\vendor" >nul 2>&1
if errorlevel 1 (
    echo [错误] 复制 vendor 失败，请以管理员身份运行。
    pause
    exit /b 1
)
echo 依赖包复制完成。

:: 复制启动脚本
copy /Y "%SCRIPT_DIR%graphify.bat" "%INSTALL_DIR%\graphify.bat" >nul 2>&1
copy /Y "%SCRIPT_DIR%graphify.ps1" "%INSTALL_DIR%\graphify.ps1" >nul 2>&1

:: 添加到 PATH (可选)
echo.
set /p ADD_PATH="是否将 graphify 添加到系统 PATH? (y/n): "
if /i "%ADD_PATH%"=="y" (
    setx PATH "%INSTALL_DIR%;%PATH%" >nul 2>&1
    if errorlevel 1 (
        echo [警告] 添加 PATH 失败，请以管理员身份运行。
    ) else (
        echo 已添加到 PATH (新终端窗口生效)。
    )
)

echo.
echo ==============================================
echo   安装完成!
echo ==============================================
echo.
echo 使用方法:
echo   %INSTALL_DIR%\graphify.bat --help
echo   或在任意目录运行: graphify [参数]
echo.
echo 快速开始:
echo   cd 你的项目目录
echo   graphify .
echo.
pause
