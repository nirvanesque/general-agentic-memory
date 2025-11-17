# GAM Benchmarks Quick Start Guide

This is a 5-minute quick start guide to help you run your first evaluation quickly.

## ⚡ Ultra Quick Start

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Set environment variables
export OPENAI_API_KEY="your_api_key_here"

# 3. Run (assuming you have data ready)
bash scripts/eval_hotpotqa.sh --data-path data/hotpotqa.json --max-samples 10
```

Done! 🎉

## 📝 Detailed Steps

### Step 1: Install Dependencies

```bash
cd general-agentic-memory
pip install -r requirements.txt
pip install -e .
```

### Step 2: Prepare Data

Create data directory:
```bash
mkdir -p data
```

Download or prepare your datasets:
- HotpotQA: `data/hotpotqa.json`
- LoCoMo: `data/locomo.json`
- RULER: `data/ruler.jsonl`
- NarrativeQA: Will be automatically downloaded from HuggingFace

### Step 3: Set Environment

```bash
# Required (if using OpenAI)
export OPENAI_API_KEY="sk-..."

# Optional: Custom API endpoint
export OPENAI_API_BASE="https://your-endpoint.com/v1"
```

### Step 4: Run Evaluation

#### Method 1: Using Shell Scripts (Recommended for Beginners)

```bash
# HotpotQA - Quick test (10 samples)
bash scripts/eval_hotpotqa.sh --data-path data/hotpotqa.json --max-samples 10

# Full evaluation
bash scripts/eval_hotpotqa.sh --data-path data/hotpotqa.json
```

#### Method 2: Using Python CLI (More Flexible)

```bash
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --generator openai \
    --model gpt-4 \
    --retriever dense \
    --max-samples 10
```

### Step 5: View Results

Results are saved in the `outputs/` directory:

```bash
ls -lh outputs/hotpotqa/
cat outputs/hotpotqa/HotpotQABenchmark_*.json
```

## 🎯 Common Scenarios

### Scenario 1: Quick Test (10 samples)

```bash
bash scripts/eval_hotpotqa.sh \
    --data-path data/hotpotqa.json \
    --max-samples 10
```

### Scenario 2: Using Different Models

```bash
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --model gpt-3.5-turbo \
    --max-samples 50
```

### Scenario 3: Using Local Models (VLLM)

```bash
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --generator vllm \
    --model meta-llama/Llama-3-8B
```

### Scenario 4: Using BM25 Retriever

```bash
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --retriever bm25
```

### Scenario 5: Evaluate All Datasets

```bash
bash scripts/eval_all.sh
```

## 🔧 Troubleshooting

### Issue 1: API Key Error

```bash
# Check environment variable
echo $OPENAI_API_KEY

# If empty, set it
export OPENAI_API_KEY="your_key"
```

### Issue 2: Data File Not Found

```bash
# Check if file exists
ls -lh data/

# Ensure path is correct
bash scripts/eval_hotpotqa.sh --data-path /absolute/path/to/hotpotqa.json
```

### Issue 3: Out of Memory

```bash
# Reduce chunk size or sample count
python -m eval.run \
    --dataset hotpotqa \
    --data-path data/hotpotqa.json \
    --chunk-size 1000 \
    --max-samples 10
```

### Issue 4: NLTK Data Not Downloaded

```python
# Manual download
python -c "import nltk; nltk.download('punkt_tab')"
```

## 📚 Next Steps

- Read full documentation: [README.md](README.md)
- Learn how to add new datasets: [MIGRATION.md](MIGRATION.md)
- Check changelog: [CHANGELOG.md](CHANGELOG.md)

## 💡 Tips

1. **First run**: Use `--max-samples 10` for quick verification
2. **Save costs**: Use `gpt-3.5-turbo` instead of `gpt-4`
3. **Quiet mode**: Add `--quiet` to reduce output
4. **Save results**: Default saved in `outputs/`, can be modified with `--output-dir`
5. **Shell scripts**: Check script contents to understand default parameters

## 🎉 Done!

Now you can run GAM evaluations! If you have questions, please check the full documentation or submit an Issue.

Happy Benchmarking! 🚀
