#!/usr/bin/env pwsh
# ============================================================
# graphify 启动器 (PowerShell)
# ============================================================
param([string[]]$Arguments)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$VendorDir = Join-Path $ScriptDir "vendor"

$env:PYTHONPATH = "$VendorDir;$env:PYTHONPATH"

$python = (Get-Command python -ErrorAction SilentlyContinue).Source
if (-not $python) { $python = (Get-Command python3 -ErrorAction SilentlyContinue).Source }
if (-not $python) { Write-Error "未找到 Python"; exit 1 }

& $python -m graphify @Arguments
