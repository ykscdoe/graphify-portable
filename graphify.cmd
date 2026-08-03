@echo off
setlocal EnableExtensions

rem ============================================================
rem graphify 启动器 (Windows CMD)
rem 自动设置 PYTHONPATH 加载 vendor/ 中的依赖
rem 无需 pip install，所有依赖已内置在 vendor/ 中
rem ============================================================

set "SCRIPT_DIR=%~dp0"
set "VENDOR_DIR=%SCRIPT_DIR%vendor"

rem 检测 Python
set "PYTHON="
for /f "delims=" %%i in ('where python 2^>nul') do set "PYTHON=%%i" & goto :found
for /f "delims=" %%i in ('where python3 2^>nul') do set "PYTHON=%%i" & goto :found
echo [错误] 未找到 Python，请安装 Python 3.10+
echo 下载地址: https://www.python.org/downloads/
exit /b 1

:found
rem 设置 PYTHONPATH，确保 vendor 中的包优先加载
set "PYTHONPATH=%VENDOR_DIR%;%PYTHONPATH%"

rem 运行 graphify
"%PYTHON%" -m graphify %*
