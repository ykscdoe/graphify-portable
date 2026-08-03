#!/usr/bin/env bash
# ============================================================
# graphify 便携安装脚本 (Linux / macOS)
# 用法: bash install.sh [目标目录]
# ============================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${1:-$HOME/graphify-portable}"

echo ""
echo "=============================================="
echo "  graphify 便携版安装程序"
echo "=============================================="
echo ""
echo "安装目录: $INSTALL_DIR"

# 检测 Python
PYTHON=""
for cmd in python3 python; do
    if command -v "$cmd" &>/dev/null; then
        PYTHON="$(command -v "$cmd")"
        break
    fi
done

if [ -z "$PYTHON" ]; then
    echo "[错误] 未找到 Python。请先安装 Python 3.10+。"
    exit 1
fi
echo "Python: $PYTHON"
$PYTHON --version

# 检查 pip（发出警告但继续）
if ! $PYTHON -m pip --version &>/dev/null; then
    echo "[警告] pip 不可用，但 graphify 不需要 pip 即可运行"
fi

# 创建目标目录
mkdir -p "$INSTALL_DIR"

# 复制 vendor 包
echo ""
echo "正在复制依赖包..."
cp -r "$SCRIPT_DIR/vendor" "$INSTALL_DIR/vendor"
echo "依赖包复制完成。"

# 复制启动脚本
cp "$SCRIPT_DIR/graphify.sh" "$INSTALL_DIR/graphify"
chmod +x "$INSTALL_DIR/graphify"

# 添加到 PATH (可选)
echo ""
read -p "是否将 graphify 链接到 /usr/local/bin? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -w /usr/local/bin ]; then
        ln -sf "$INSTALL_DIR/graphify" /usr/local/bin/graphify
        echo "已链接到 /usr/local/bin/graphify"
    else
        echo "[需要 sudo] 请输入密码:"
        sudo ln -sf "$INSTALL_DIR/graphify" /usr/local/bin/graphify
        echo "已链接到 /usr/local/bin/graphify"
    fi
fi

echo ""
echo "=============================================="
echo "  安装完成!"
echo "=============================================="
echo ""
echo "使用方法:"
echo "  $INSTALL_DIR/graphify --help"
echo "  或在任意目录运行: graphify [参数]"
echo ""
echo "快速开始:"
echo "  cd 你的项目目录"
echo "  graphify ."
