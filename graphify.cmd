@echo off
setlocal EnableExtensions

chcp 65001 >nul

rem ============================================================
rem graphify launcher (Windows CMD)
rem sets PYTHONPATH to load bundled vendor dependencies
rem no pip install required
rem ============================================================

set "SCRIPT_DIR=%~dp0"
set "VENDOR_DIR=%SCRIPT_DIR%vendor"

rem detect Python
set "PYTHON="
for /f "delims=" %%i in ('where python 2^>nul') do set "PYTHON=%%i" & goto :found
for /f "delims=" %%i in ('where python3 2^>nul') do set "PYTHON=%%i" & goto :found
echo [ERROR] Python not found. Install Python 3.10+
echo Download: https://www.python.org/downloads/
exit /b 1

:found
rem set PYTHONPATH so bundled packages load first
set "PYTHONPATH=%VENDOR_DIR%;%PYTHONPATH%"

rem run graphify
"%PYTHON%" -m graphify %*
