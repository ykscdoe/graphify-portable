@echo off
setlocal

:: ============================================================
:: graphify 启动器 (Windows)
:: 自动设置 PYTHONPATH 加载 vendor 依赖
:: ============================================================

set "SCRIPT_DIR=%~dp0"
set "VENDOR_DIR=%SCRIPT_DIR%vendor"

:: 检测 Python
set "PYTHON="
for /f "delims=" %%i in ('where python 2^>nul') do set "PYTHON=%%i" & goto :found
for /f "delims=" %%i in ('where python3 2^>nul') do set "PYTHON=%%i" & goto :found
echo [错误] 未找到 Python
exit /b 1

:found
:: 设置 PYTHONPATH 优先加载 vendor 包
set "PYTHONPATH=%VENDOR_DIR%;%PYTHONPATH%"

:: 运行 graphify
"%PYTHON%" -m graphify %*
