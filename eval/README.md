# GAM Benchmarks

Evaluation benchmark suite for the GAM (General Agentic Memory) framework.

## 📋 Supported Datasets

| Dataset | Type | Description | Metrics |
|---------|------|-------------|---------|
| **HotpotQA** | Multi-hop QA | Question answering task requiring reasoning across multiple documents | F1 |
| **NarrativeQA** | Narrative QA | Reading comprehension based on long stories and documents | F1 |
| **LoCoMo** | Conversation Memory | Memory retrieval in long conversation history | F1, BLEU-1 |
| **RULER** | Long Context | Multiple tasks testing long-context understanding | Accuracy |

## 🚀 Quick Start

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Prepare Data

```bash
# Download datasets to data/ directory
mkdir -p data

# HotpotQA
# Download and place at data/hotpotqa.json

# NarrativeQA (will be automatically downloaded from HuggingFace)

# LoCoMo
# Download and place at data/locomo.json

# RULER
# Download and place at data/ruler.jsonl
```

### 3. Set Environment Variables

```bash
# If using OpenAI API
export OPENAI_API_KEY="your_api_key_here"

# Optional: Use custom API endpoint
export OPENAI_API_BASE="https://your-api-endpoint.com/v1"
```

### 4. Run Evaluation

#### Method 1: Using Shell Scripts (Recommended)

```bash
# HotpotQA
bash scripts/eval_hotpotqa.sh

# NarrativeQA
bash scripts/eval_narrativeqa.sh

# LoCoMo
bash scripts/eval_locomo.sh

# RULER
bash scripts/eval_ruler.sh --dataset-name niah_single_1

# Run all evaluations
bash scripts/eval_all.sh
```

#### Method 2: Using Python CLI

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

## 📊 Configuration Options

### Generator

```bash
# Use OpenAI API
--generator openai --model gpt-4 --api-key YOUR_KEY

# Use VLLM (Local models)
--generator vllm --model meta-llama/Llama-3-8B
```

### Retriever

```bash
# Dense Retriever (Semantic retrieval, recommended)
--retriever dense --embedding-model BAAI/bge-base-en-v1.5

# BM25 Retriever (Keyword retrieval)
--retriever bm25

# Index Retriever (Simple index)
--retriever index
```

### Evaluation Parameters

```bash
# Limit sample count (quick test)
--max-samples 50

# Adjust text chunk size
--chunk-size 2000

# Adjust retrieval count
--top-k 5

# Set output directory
--output-dir outputs/my_experiment

# Quiet mode
--quiet

# Don't save predictions
--no-save
```

## 📁 Project Structure

```
eval/
├── __init__.py              # Package initialization
├── __main__.py              # Allows python -m eval.run
├── run.py                   # CLI entry point
├── README.md                # This document
├── datasets/                # Dataset modules
│   ├── __init__.py
│   ├── base.py             # Base class
│   ├── hotpotqa.py         # HotpotQA implementation
│   ├── narrativeqa.py      # NarrativeQA implementation
│   ├── locomo.py           # LoCoMo implementation
│   └── ruler.py            # RULER implementation
└── utils/                   # Utility modules
    ├── __init__.py
    ├── chunking.py         # Text chunking utilities
    └── metrics.py          # Evaluation metrics utilities

scripts/                     # Shell scripts
├── eval_hotpotqa.sh
├── eval_narrativeqa.sh
├── eval_locomo.sh
├── eval_ruler.sh
└── eval_all.sh
```

## 🔧 Custom Evaluation

### Method 1: Modify Shell Script Parameters

Edit default parameters in `scripts/eval_*.sh` files:

```bash
# Change default model
MODEL="gpt-3.5-turbo"

# Change default retriever
RETRIEVER="bm25"

# Change default output directory
OUTPUT_DIR="outputs/my_experiment"
```

### Method 2: Create Custom Benchmark

```python
from eval.datasets.base import BaseBenchmark, BenchmarkConfig

class MyBenchmark(BaseBenchmark):
    def load_data(self):
        # Implement data loading logic
        pass
    
    def prepare_chunks(self, sample):
        # Implement text chunking logic
        pass
    
    def extract_question(self, sample):
        # Extract question
        pass
    
    def extract_ground_truth(self, sample):
        # Extract ground truth
        pass
    
    def compute_metrics(self, predictions, ground_truths):
        # Compute evaluation metrics
        pass

# Usage
config = BenchmarkConfig(data_path="my_data.json")
benchmark = MyBenchmark(config)
results = benchmark.run()
```

## 📈 Result Output

After evaluation completes, results are saved in the `outputs/` directory:

```
outputs/
├── hotpotqa/
│   └── HotpotQABenchmark_20240116_143022.json
├── narrativeqa/
│   └── NarrativeQABenchmark_20240116_150533.json
└── ...
```

Result files contain:
- Configuration information
- Evaluation metrics
- Predictions and ground truth for each sample

Example result:

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

## 🐛 Troubleshooting

### 1. ImportError: No module named 'gam'

Ensure GAM framework is installed:

```bash
pip install -e .
```

### 2. OpenAI API Error

Check if API Key is correctly set:

```bash
echo $OPENAI_API_KEY
```

### 3. CUDA Out of Memory (when using VLLM)

Reduce batch size or use a smaller model:

```bash
--model meta-llama/Llama-3-8B  # Use smaller model
```

### 4. NLTK Data Download Failed

Manual download:

```python
import nltk
nltk.download('punkt_tab')
```

## 📝 Contributing

Contributions for new dataset support are welcome!

1. Create a new file in `eval/datasets/`
2. Inherit from `BaseBenchmark` class
3. Implement necessary methods
4. Add corresponding Shell script
5. Update this README

## 📄 License

This project follows the same license as the GAM framework.

## 🙏 Acknowledgments

Thanks to the authors of the following datasets:
- HotpotQA
- NarrativeQA
- LoCoMo
- RULER

## 📮 Contact

For questions or suggestions, please submit an Issue or Pull Request.
