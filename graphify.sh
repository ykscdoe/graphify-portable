#!/usr/bin/env bash
# ============================================================
# graphify 启动器 (Linux / macOS)
# 自动设置 PYTHONPATH 加载 vendor 依赖
# ============================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENDOR_DIR="$SCRIPT_DIR/vendor"

# 检测 Python
PYTHON=""
for cmd in python3 python; do
    if command -v "$cmd" &>/dev/null; then
        PYTHON="$(command -v "$cmd")"
        break
    fi
done

if [ -z "$PYTHON" ]; then
    echo "[错误] 未找到 Python"
    exit 1
fi

# 设置 PYTHONPATH 优先加载 vendor 包
export PYTHONPATH="$VENDOR_DIR${PYTHONPATH:+:$PYTHONPATH}"

# 运行 graphify
exec "$PYTHON" -m graphify "$@"
