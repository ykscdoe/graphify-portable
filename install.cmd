@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: graphify 便携安装脚本 (Windows CMD)
:: 用法: 双击运行 或 在命令行: install.cmd [目标目录]
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
echo   graphify 便携版安装程序 (Python 3.12)
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

:: 检查 Python 版本 >= 3.10
for /f "tokens=2" %%v in ('"%PYTHON%" --version 2^>^&1') do set "PYVER=%%v"
echo 检测到 Python %PYVER%
for /f "tokens=1,2 delims=." %%a in ("%PYVER%") do (
    set "MAJOR=%%a"
    set "MINOR=%%b"
)
if %MAJOR% LSS 3 (
    echo [错误] 需要 Python 3.10+, 当前版本: %PYVER%
    pause
    exit /b 1
)
if %MAJOR% EQU 3 if %MINOR% LSS 10 (
    echo [错误] 需要 Python 3.10+, 当前版本: %PYVER%
    pause
    exit /b 1
)

:: 创建目标目录
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: 复制 vendor 包
echo.
echo [1/2] 复制依赖包到 %INSTALL_DIR%...
xcopy /E /I /Y "%SCRIPT_DIR%vendor" "%INSTALL_DIR%\vendor" >nul
if errorlevel 1 (
    echo [错误] 复制 vendor 失败
    pause
    exit /b 1
)
echo   完成

:: 复制启动脚本
echo [2/2] 复制启动脚本...
copy /Y "%SCRIPT_DIR%graphify.cmd" "%INSTALL_DIR%\graphify.cmd" >nul

:: 检查是否需要添加到 PATH
echo.
echo 是否将 graphify 添加到系统 PATH？(Y/N)
echo 选 Y: 可在任意目录运行 "graphify"
echo 选 N: 需要在 %INSTALL_DIR% 目录下运行
set /p ADD_PATH="你的选择 [Y/N]: "

if /i "%ADD_PATH%"=="Y" (
    echo 正在添加到 PATH...
    setx PATH "%INSTALL_DIR%;%PATH%" >nul
    if errorlevel 1 (
        echo [提示] 添加 PATH 失败，请手动添加 %INSTALL_DIR% 到系统 PATH
        echo       或以管理员身份重新运行本脚本
    ) else (
        echo   已添加到 PATH (新终端窗口生效)
    )
)

echo.
echo ==============================================
echo   安装完成！
echo ==============================================
echo.
echo 使用方式:
echo   graphify .         对当前目录构建知识图谱
echo   graphify --help    查看完整帮助
echo.
echo 输出文件:
echo   graphify-out/
echo     graph.html       交互式知识图谱
echo     GRAPH_REPORT.md  文本报告
echo     graph.json       原始数据
echo.
echo 注意: 本便携版基于 Python 3.12 打包。
echo       如果系统 Python 版本不同，可能需要重新打包。
echo.
pause
