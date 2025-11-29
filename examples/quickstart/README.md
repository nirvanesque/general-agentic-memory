# GAM Framework 快速开始示例

这个目录包含 GAM (General Agentic Memory) 框架的快速入门示例。

## 📁 文件说明

### 1. `basic_usage.py` - 基础使用示例
展示 GAM 框架的核心功能：
- ✅ 如何创建和配置 MemoryAgent（记忆代理）
- ✅ 如何使用 `memorize()` 方法构建记忆
- ✅ 如何创建和使用 ResearchAgent（研究代理）
- ✅ 如何进行基于记忆的研究和问答

**适合**: 初学者，想快速了解 GAM 核心功能

### 2. `model_usage.py` - 模型选择示例
展示如何使用不同类型的 LLM 模型：
- ✅ OpenAI API 模型（gpt-4o-mini, gpt-4, 等）
- ✅ 自定义 API 端点（兼容 OpenAI 的第三方服务）
- ✅ VLLM 本地模型（用于隐私和离线场景）
- ✅ 模型选择对比和建议

**适合**: 需要选择合适模型的开发者

## 🚀 快速开始

### 前置要求

1. **安装依赖**
```bash
pip install -r requirements.txt
```

2. **设置 API Key**（使用 OpenAI 模型时）
```bash
export OPENAI_API_KEY="your-api-key-here"
```

### 运行示例

#### 基础使用示例
```bash
cd examples/quickstart
python basic_usage.py
```

**你将看到**:
- 记忆构建过程
- 记忆事件和摘要的数量
- 基于记忆的研究结果
- 最终答案

#### 模型使用示例
```bash
cd examples/quickstart
python model_usage.py
```

**你将看到**:
- OpenAI API 模型配置和使用
- 自定义端点配置示例
- VLLM 本地模型配置（可选）
- 模型选择指南

## 📚 核心概念

### MemoryAgent（记忆代理）
负责从文本中构建结构化记忆：
```python
from gam import MemoryAgent, OpenAIGenerator, OpenAIGeneratorConfig

# 1. 创建生成器
gen_config = OpenAIGeneratorConfig(model="gpt-4o-mini")
generator = OpenAIGenerator(gen_config)

# 2. 创建记忆代理
memory_agent = MemoryAgent(generator=generator, ...)

# 3. 记忆文本
memory_agent.memorize("你的文本内容")

# 4. 获取记忆状态
memory_state = memory_agent.load()
print(f"构建了 {len(memory_state.abstracts)} 个记忆摘要")
```

### ResearchAgent（研究代理）
基于构建的记忆进行深度研究：
```python
from gam import ResearchAgent, DenseRetriever

# 1. 创建检索器
retriever = DenseRetriever(config=..., memory_store=..., page_store=...)

# 2. 创建研究代理
research_agent = ResearchAgent(generator=generator, retriever=retriever)

# 3. 进行研究
result = research_agent.research(question="你的问题")

# 4. 获取研究摘要
research_summary = result.integrated_memory
print(f"研究摘要: {research_summary}")
print(f"迭代次数: {len(result.raw_memory.get('iterations', []))}")
```

## 🔧 配置选项

### Generator 配置

#### OpenAI Generator
```python
OpenAIGeneratorConfig(
    model="gpt-4o-mini",        # 模型名称
    api_key="your-key",         # API Key
    base_url=None,              # 可选：自定义端点
    temperature=0.3,            # 温度参数
    max_tokens=1000,            # 最大 token 数
)
```

#### VLLM Generator（本地模型）
```python
VLLMGeneratorConfig(
    model_path="meta-llama/Llama-3-8B",  # 模型路径
    temperature=0.7,                      # 温度参数
    max_tokens=512,                       # 最大 token 数
    gpu_memory_utilization=0.9,          # GPU 内存使用率
)
```

### Retriever 配置

#### Dense Retriever（语义检索，推荐）
```python
DenseRetrieverConfig(
    model_path="BAAI/bge-base-en-v1.5",  # Embedding 模型
    top_k=5,                              # 检索数量
)
```

#### BM25 Retriever（关键词检索）
```python
BM25RetrieverConfig(
    top_k=5,
)
```

## 💡 使用建议

### 1. 选择合适的模型

| 场景 | 推荐模型 | 原因 |
|------|---------|------|
| 快速原型 | OpenAI API (gpt-4o-mini) | 快速、稳定、易用 |
| 生产环境 | OpenAI API (gpt-4) | 性能最佳 |
| 隐私要求 | VLLM 本地模型 | 数据不出本地 |
| 成本敏感 | gpt-3.5-turbo 或本地模型 | 成本较低 |

### 2. 优化记忆构建

- ✅ 将长文本分成适当大小的块（建议 500-2000 tokens）
- ✅ 按逻辑顺序提供文本（如时间顺序、主题顺序）
- ✅ 对于重要信息，可以单独作为一个记忆块

### 3. 优化研究效果

- ✅ 问题要具体明确
- ✅ 调整 `top_k` 参数来控制检索的记忆数量
- ✅ 使用 Dense Retriever 获得更好的语义检索效果

## 🔍 进阶示例

想了解更多高级用法？查看：

- **评估示例**: `eval/` 目录
  - HotpotQA: 多跳问答评估
  - NarrativeQA: 长文档问答评估
  - LoCoMo: 对话记忆评估
  - RULER: 长上下文评估

- **Shell 脚本**: `scripts/` 目录
  - 批量评估脚本
  - 配置示例

## 🐛 常见问题

### Q1: 运行时出现 API Key 错误
**A**: 确保设置了环境变量
```bash
export OPENAI_API_KEY="your-api-key"
```

### Q2: 内存不足（使用 VLLM 时）
**A**: 尝试：
- 使用更小的模型
- 减少 `gpu_memory_utilization` 参数
- 使用量化模型

### Q3: 导入错误
**A**: 确保安装了所有依赖
```bash
pip install -r requirements.txt
pip install -e .  # 安装 GAM 包
```

### Q4: 检索结果不理想
**A**: 尝试：
- 增加 `top_k` 参数
- 使用 Dense Retriever 而不是 BM25
- 改进问题的表述

## 📖 相关文档

- [主 README](../../README.md) - 项目整体介绍
- [评估框架文档](../../eval/README.md) - 评估使用指南
- [快速开始](../../eval/QUICKSTART.md) - 评估快速开始

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目遵循与 GAM 框架相同的许可证。

