# GAM Benchmarks

GAM (General Agentic Memory) 框架的评估基准套件。

## 📋 支持的数据集

| 数据集 | 类型 | 描述 | 指标 |
|--------|------|------|------|
| **HotpotQA** | 多跳问答 | 需要跨多个文档推理的问答任务 | F1 |
| **NarrativeQA** | 叙事问答 | 基于长篇故事和文档的阅读理解 | F1 |
| **LoCoMo** | 对话记忆 | 长对话历史中的记忆检索 | F1, BLEU-1 |
| **RULER** | 长上下文 | 测试长上下文理解能力的多种任务 | Accuracy |

## 🚀 快速开始

### 1. 安装依赖

```bash
pip install -r requirements.txt
```

### 2. 准备数据

```bash
# 下载数据集到 data/ 目录
mkdir -p data

# HotpotQA
# 下载并放置到 data/hotpotqa.json

# NarrativeQA (会自动从 HuggingFace 下载)

# LoCoMo
# 下载并放置到 data/locomo.json

# RULER
# 下载并放置到 data/ruler.jsonl
```

### 3. 设置环境变量

```bash
# 如果使用 OpenAI API
export OPENAI_API_KEY="your_api_key_here"

# 可选：使用自定义 API endpoint
export OPENAI_API_BASE="https://your-api-endpoint.com/v1"
```

### 4. 运行评估

#### 方式一：使用 Shell 脚本（推荐）

```bash
# HotpotQA
bash scripts/eval_hotpotqa.sh

# NarrativeQA
bash scripts/eval_narrativeqa.sh

# LoCoMo
bash scripts/eval_locomo.sh

# RULER
bash scripts/eval_ruler.sh --dataset-name niah_single_1

# 运行所有评估
bash scripts/eval_all.sh
```

#### 方式二：使用 Python CLI

```bash
# HotpotQA
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --generator openai \
    --model gpt-4 \
    --retriever dense

# NarrativeQA
python -m eval.run \
    --dataset narrativeqa \
    --data-path narrativeqa \
    --max-samples 100

# LoCoMo
python -m eval.run \
    --dataset locomo \
    --data-path data/locomo.json

# RULER
python -m eval.run \
    --dataset ruler \
    --data-path data/ruler.jsonl \
    --dataset-name niah_single_1
```

## 📊 配置选项

### 生成器 (Generator)

```bash
# 使用 OpenAI API
--generator openai --model gpt-4 --api-key YOUR_KEY

# 使用 VLLM (本地模型)
--generator vllm --model meta-llama/Llama-3-8B
```

### 检索器 (Retriever)

```bash
# Dense Retriever (语义检索，推荐)
--retriever dense --embedding-model BAAI/bge-base-en-v1.5

# BM25 Retriever (关键词检索)
--retriever bm25

# Index Retriever (简单索引)
--retriever index
```

### 评估参数

```bash
# 限制样本数量（快速测试）
--max-samples 50

# 调整文本块大小
--chunk-size 2000

# 调整检索数量
--top-k 5

# 设置输出目录
--output-dir outputs/my_experiment

# 静默模式
--quiet

# 不保存预测结果
--no-save
```

## 📁 项目结构

```
eval/
├── __init__.py              # 包初始化
├── __main__.py              # 允许 python -m eval.run
├── run.py                   # CLI 入口
├── README.md                # 本文档
├── datasets/                # 数据集模块
│   ├── __init__.py
│   ├── base.py             # 基类
│   ├── hotpotqa.py         # HotpotQA 实现
│   ├── narrativeqa.py      # NarrativeQA 实现
│   ├── locomo.py           # LoCoMo 实现
│   └── ruler.py            # RULER 实现
└── utils/                   # 工具模块
    ├── __init__.py
    ├── chunking.py         # 文本切分工具
    └── metrics.py          # 评估指标工具

scripts/                     # Shell 脚本
├── eval_hotpotqa.sh
├── eval_narrativeqa.sh
├── eval_locomo.sh
├── eval_ruler.sh
└── eval_all.sh
```

## 🔧 自定义评估

### 方法一：修改 Shell 脚本参数

编辑 `scripts/eval_*.sh` 文件中的默认参数：

```bash
# 修改默认模型
MODEL="gpt-3.5-turbo"

# 修改默认检索器
RETRIEVER="bm25"

# 修改默认输出目录
OUTPUT_DIR="outputs/my_experiment"
```

### 方法二：创建自定义 Benchmark

```python
from eval.datasets.base import BaseBenchmark, BenchmarkConfig

class MyBenchmark(BaseBenchmark):
    def load_data(self):
        # 实现数据加载逻辑
        pass
    
    def prepare_chunks(self, sample):
        # 实现文本切分逻辑
        pass
    
    def extract_question(self, sample):
        # 提取问题
        pass
    
    def extract_ground_truth(self, sample):
        # 提取标准答案
        pass
    
    def compute_metrics(self, predictions, ground_truths):
        # 计算评估指标
        pass

# 使用
config = BenchmarkConfig(data_path="my_data.json")
benchmark = MyBenchmark(config)
results = benchmark.run()
```

## 📈 结果输出

评估完成后，结果会保存在 `outputs/` 目录：

```
outputs/
├── hotpotqa/
│   └── HotpotQABenchmark_20240116_143022.json
├── narrativeqa/
│   └── NarrativeQABenchmark_20240116_150533.json
└── ...
```

结果文件包含：
- 配置信息
- 评估指标
- 每个样本的预测和标准答案

示例结果：

```json
{
  "config": {
    "data_path": "data/hotpotqa.json",
    "generator_type": "openai",
    "model_name": "gpt-4",
    "num_samples": 100
  },
  "metrics": {
    "em": 0.75,
    "f1": 0.83
  },
  "predictions": [
    {
      "prediction": "The answer is...",
      "ground_truth": ["correct answer"]
    }
  ]
}
```

## 🐛 故障排除

### 1. ImportError: No module named 'gam'

确保已安装 GAM 框架：

```bash
pip install -e .
```

### 2. OpenAI API 错误

检查 API Key 是否正确设置：

```bash
echo $OPENAI_API_KEY
```

### 3. CUDA Out of Memory (使用 VLLM 时)

减小批处理大小或使用更小的模型：

```bash
--model meta-llama/Llama-3-8B  # 使用更小的模型
```

### 4. 下载 NLTK 数据失败

手动下载：

```python
import nltk
nltk.download('punkt_tab')
```

## 📝 贡献指南

欢迎贡献新的数据集支持！

1. 在 `eval/datasets/` 创建新文件
2. 继承 `BaseBenchmark` 类
3. 实现必要的方法
4. 添加对应的 Shell 脚本
5. 更新本 README

## 📄 许可证

本项目遵循与 GAM 框架相同的许可证。

## 🙏 致谢

感谢以下数据集的作者：
- HotpotQA
- NarrativeQA
- LoCoMo
- RULER

## 📮 联系方式

如有问题或建议，请提交 Issue 或 Pull Request。

