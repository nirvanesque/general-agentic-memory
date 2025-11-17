# GAM Benchmarks 快速开始指南

这是一个5分钟快速上手指南，帮助你快速运行第一个评估。

## ⚡ 超快速开始

```bash
# 1. 安装
pip install -r requirements.txt

# 2. 设置环境变量
export OPENAI_API_KEY="your_api_key_here"

# 3. 运行（假设你已有数据）
bash scripts/eval_hotpotqa.sh --data-path data/hotpotqa.json --max-samples 10
```

完成！🎉

## 📝 详细步骤

### 步骤 1: 安装依赖

```bash
cd general-agentic-memory
pip install -r requirements.txt
pip install -e .
```

### 步骤 2: 准备数据

创建数据目录：
```bash
mkdir -p data
```

下载或准备你的数据集：
- HotpotQA: `data/hotpotqa.json`
- LoCoMo: `data/locomo.json`
- RULER: `data/ruler.jsonl`
- NarrativeQA: 会自动从 HuggingFace 下载

### 步骤 3: 设置环境

```bash
# 必需（如果使用 OpenAI）
export OPENAI_API_KEY="sk-..."

# 可选：自定义API端点
export OPENAI_API_BASE="https://your-endpoint.com/v1"
```

### 步骤 4: 运行评估

#### 方式一：使用 Shell 脚本（推荐新手）

```bash
# HotpotQA - 快速测试（10个样本）
bash scripts/eval_hotpotqa.sh --data-path data/hotpotqa.json --max-samples 10

# 完整评估
bash scripts/eval_hotpotqa.sh --data-path data/hotpotqa.json
```

#### 方式二：使用 Python CLI（更灵活）

```bash
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --generator openai \
    --model gpt-4 \
    --retriever dense \
    --max-samples 10
```

### 步骤 5: 查看结果

结果保存在 `outputs/` 目录：

```bash
ls -lh outputs/hotpotqa/
cat outputs/hotpotqa/HotpotQABenchmark_*.json
```

## 🎯 常见场景

### 场景 1: 快速测试（10个样本）

```bash
bash scripts/eval_hotpotqa.sh \
    --data-path data/hotpotqa.json \
    --max-samples 10
```

### 场景 2: 使用不同的模型

```bash
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --model gpt-3.5-turbo \
    --max-samples 50
```

### 场景 3: 使用本地模型（VLLM）

```bash
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --generator vllm \
    --model meta-llama/Llama-3-8B
```

### 场景 4: 使用 BM25 检索器

```bash
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --retriever bm25
```

### 场景 5: 评估所有数据集

```bash
bash scripts/eval_all.sh
```

## 🔧 故障排除

### 问题 1: API Key 错误

```bash
# 检查环境变量
echo $OPENAI_API_KEY

# 如果为空，设置它
export OPENAI_API_KEY="your_key"
```

### 问题 2: 数据文件未找到

```bash
# 检查文件是否存在
ls -lh data/

# 确保路径正确
bash scripts/eval_hotpotqa.sh --data-path /absolute/path/to/hotpotqa.json
```

### 问题 3: 内存不足

```bash
# 减小 chunk size 或 样本数
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --chunk-size 1000 \
    --max-samples 10
```

### 问题 4: NLTK 数据未下载

```python
# 手动下载
python -c "import nltk; nltk.download('punkt_tab')"
```

## 📚 下一步

- 阅读完整文档: [README.md](README.md)
- 了解如何添加新数据集: [MIGRATION.md](MIGRATION.md)
- 查看更新日志: [CHANGELOG.md](CHANGELOG.md)

## 💡 提示

1. **首次运行**: 使用 `--max-samples 10` 快速验证
2. **节省成本**: 使用 `gpt-3.5-turbo` 而不是 `gpt-4`
3. **静默模式**: 添加 `--quiet` 减少输出
4. **保存结果**: 默认保存在 `outputs/`，可用 `--output-dir` 修改
5. **Shell 脚本**: 查看脚本内容了解默认参数

## 🎉 完成！

现在你已经可以运行 GAM 评估了！如有问题，请查看完整文档或提交 Issue。

Happy Benchmarking! 🚀

