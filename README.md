# graphify 便携安装包

> 🚀 **零依赖安装** — 无需 pip、uv、conda，下载即用
> 📦 本包基于 **Python 3.12** 打包，适用于 Python 3.10-3.12

## 这是什么？

这是 [graphify](https://github.com/safishamsi/graphify) 的离线便携安装包。所有 Python 依赖（networkx、numpy、rapidfuzz、tree-sitter 等）已内置在 `vendor/` 目录中，**不需要联网安装任何包**。

## 系统要求

- Python 3.10-3.12（仅需基础 Python 安装）
- Windows（本便携版为 Windows 打包）

## 快速开始（二选一）

### 方式一：安装到系统（推荐）

双击运行 `install.cmd` 或在命令行：

```cmd
install.cmd
```

安装后可在任意目录运行 `graphify`。

### 方式二：直接使用（免安装）

```cmd
graphify.cmd .
```

## 使用方法

```bash
# 对当前目录构建知识图谱
graphify .

# 指定路径
graphify my-project/

# 克隆 GitHub 仓库并分析
graphify https://github.com/user/repo

# 增量更新
graphify . --update

# 查询已构建的图谱
graphify query "数据流是怎么走的？"

# 查找两概念间最短路径
graphify path "AuthModule" "Database"

# 解释某个节点
graphify explain "SwinTransformer"

# 深度模式（更丰富的关系提取）
graphify . --mode deep

# 查看完整帮助
graphify --help
```

## 输出文件

运行后在项目目录生成 `graphify-out/`：

| 文件 | 说明 |
|------|------|
| `graph.html` | 交互式知识图谱（浏览器打开） |
| `GRAPH_REPORT.md` | 纯文本审计报告 |
| `graph.json` | 原始图谱数据（可导入 Neo4j 等） |

## 文件结构

```
graphify-portable/
├── vendor/                  # 所有 Python 依赖包 (Python 3.12)
│   ├── .python-version      # 打包时的 Python 版本
│   ├── graphify/            # graphify 核心
│   ├── networkx/            # 图算法库
│   ├── numpy/               # 数值计算
│   ├── rapidfuzz/           # 模糊匹配
│   ├── tree_sitter/         # AST 解析核心
│   └── tree_sitter_*/       # 30+ 语言解析器
├── install.cmd              # Windows 一键安装脚本
├── graphify.cmd              # Windows 启动器
├── package_vendor.py         # 打包脚本（开发者用）
└── README.md
```

## 注意事项

1. **平台兼容性**：本包为 Windows Python 3.12 打包。如果目标机器是 Python 3.13+，请运行 `package_vendor.py` 重新打包。
2. **vendor/.python-version**：记录打包时的 Python 版本，用于核对兼容性。

## 开发者：重新打包

如果你需要在不同平台/不同 Python 版本上重新打包：

```bash
# 在那台机器上有网络时运行一次
pip install graphifyy
python package_vendor.py
```

## 许可证

graphify 原作者: [safishamsi](https://github.com/safishamsi)
