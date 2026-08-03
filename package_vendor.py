#!/usr/bin/env python3
"""
graphify 便携打包脚本
将 graphify 及其所有依赖复制到 vendor/ 目录，实现离线安装
用法: python package_vendor.py
"""
import os
import sys
import site
import shutil
import subprocess
from pathlib import Path

def get_site_packages():
    """获取 site-packages 路径"""
    for sp in site.getsitepackages():
        if 'site-packages' in sp.lower():
            return Path(sp)
    # fallback
    return Path(site.getusersitepackages())

def copy_package(src, dst, ignore_pyc=True, ignore_dirs=None):
    """复制包目录到目标"""
    src = Path(src)
    dst = Path(dst)
    
    if not src.exists():
        print(f"  [跳过] {src} 不存在")
        return False
    
    if dst.exists():
        shutil.rmtree(dst)
    
    def ignore_func(directory, files):
        ignored = []
        for f in files:
            if ignore_pyc and f.endswith('.pyc'):
                ignored.append(f)
            if f == '__pycache__':
                ignored.append(f)
            if f.endswith('.dist-info') or f.endswith('.egg-info'):
                ignored.append(f)
        return ignored
    
    shutil.copytree(src, dst, ignore=ignore_func)
    
    # 计算大小
    total = sum(
        os.path.getsize(os.path.join(r, f))
        for r, _, fs in os.walk(dst)
        for f in fs
    )
    print(f"  {src.name}/ -> {dst.name}/ ({total/1024/1024:.1f} MB)")
    return True

def main():
    script_dir = Path(__file__).parent.resolve()
    vendor_dir = script_dir / "vendor"
    
    # 清理旧的 vendor
    if vendor_dir.exists():
        print("清理旧的 vendor/ ...")
        shutil.rmtree(vendor_dir)
    vendor_dir.mkdir()
    
    sp = get_site_packages()
    print(f"site-packages: {sp}")
    print(f"vendor 目标: {vendor_dir}")
    print()
    
    # === 1. graphify 自身 ===
    print("[1/5] 复制 graphify 核心...")
    copy_package(sp / "graphify", vendor_dir / "graphify")
    
    # === 2. 纯 Python 依赖 ===
    print("\n[2/5] 复制纯 Python 依赖...")
    pure_python = ["networkx"]
    for pkg in pure_python:
        copy_package(sp / pkg, vendor_dir / pkg)
    
    # === 3. 带原生模块的依赖 (Windows .pyd) ===
    print("\n[3/5] 复制原生模块依赖...")
    native_pkgs = ["numpy", "rapidfuzz", "tree_sitter"]
    for pkg in native_pkgs:
        copy_package(sp / pkg, vendor_dir / pkg)
    
    # === 4. tree-sitter 语言包 ===
    print("\n[4/5] 复制 tree-sitter 语言包...")
    ts_dirs = sorted([
        d for d in sp.iterdir()
        if d.is_dir() and d.name.startswith("tree_sitter_")
        and not d.name.endswith(('.dist-info', '.egg-info'))
    ])
    for ts_dir in ts_dirs:
        copy_package(ts_dir, vendor_dir / ts_dir.name)
    
    # === 5. 验证 ===
    print("\n[5/5] 验证打包...")
    
    # 验证 graphify 可导入
    sys.path.insert(0, str(vendor_dir))
    try:
        import graphify
        print(f"  graphify {graphify.__version__ if hasattr(graphify, '__version__') else '(版本未标注)'} - OK")
    except Exception as e:
        print(f"  [警告] graphify 导入测试失败: {e}")
    
    # 统计总大小
    total = sum(
        os.path.getsize(os.path.join(r, f))
        for r, _, fs in os.walk(vendor_dir)
        for f in fs
    )
    file_count = sum(1 for r, _, fs in os.walk(vendor_dir) for f in fs)
    
    # 记录打包时的 Python 版本
    py_ver = f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
    (vendor_dir / ".python-version").write_text(f"{py_ver}\n")
    
    print(f"\n打包完成!")
    print(f"  Python 版本: {py_ver}")
    print(f"  总大小: {total/1024/1024:.1f} MB")
    print(f"  文件数: {file_count}")
    print(f"  输出目录: {vendor_dir}")
    print()
    print("下一步:")
    print("  1. 将整个 graphify-portable/ 目录复制到目标电脑")
    print("  2. 运行 install.cmd (Windows) 或 install.sh (Linux/Mac)")
    print("  3. 使用: graphify .")

if __name__ == "__main__":
    main()
