@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "VENDOR_DIR=%SCRIPT_DIR%vendor"

set "PYTHON="
for /f "delims=" %%i in ('where python 2^>nul') do set "PYTHON=%%i" & goto :found
for /f "delims=" %%i in ('where python3 2^>nul') do set "PYTHON=%%i" & goto :found
echo Python 3.10+ not found.
exit /b 1

:found
set "PYTHONPATH=%VENDOR_DIR%;%PYTHONPATH%"

"%PYTHON%" -m graphify %*
