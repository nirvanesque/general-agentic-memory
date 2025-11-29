#!/bin/bash

# Activate your conda/virtual environment if needed
# source /path/to/your/conda/bin/activate your_env
source /root/anaconda3/bin/activate /share/project/chaofan/envs/demo
cd /share/project/chaofan/code/memory/gam-github/general-agentic-memory

# Set base output directory
base_outputdir=./results/ruler

# Create base output directory
mkdir -p $base_outputdir

dataset="qa_1"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=0 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_qa_1.txt 2>&1 &

dataset="qa_2"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=1 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_qa_2.txt 2>&1 &

dataset="vt"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=2 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_vt.txt 2>&1 &

dataset="niah_single_1"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=3 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_niah_single_1.txt 2>&1 &

dataset="niah_single_2"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=4 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_niah_single_2.txt 2>&1 &

dataset="niah_single_3"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=5 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_niah_single_3.txt 2>&1 &

dataset="niah_multikey_1"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=6 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_niah_multikey_1.txt 2>&1 &

dataset="niah_multikey_2"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=7 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_niah_multikey_2.txt 2>&1 &

dataset="niah_multikey_3"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=8 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_niah_multikey_3.txt 2>&1 &

dataset="niah_multiquery"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=9 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_niah_multiquery.txt 2>&1 &

dataset="niah_multivalue"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=10 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_niah_multivalue.txt 2>&1 &

dataset="cwe"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=11 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_cwe.txt 2>&1 &

dataset="fwe"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=12 nohup python3 eval/ruler_test.py \
    --data ./data/ruler/${dataset}.jsonl \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048 \
    --memory-api-key "your-openai-api-key" \
    --memory-base-url "http://localhost:8000/v1" \
    --memory-model "gpt-4o-mini" \
    --research-api-key "your-openai-api-key" \
    --research-base-url "http://localhost:8000/v1" \
    --research-model "gpt-4o-mini" \
    --working-api-key "your-openai-api-key" \
    --working-base-url "http://localhost:8000/v1" \
    --working-model "gpt-4o-mini" \
    --embedding-model-path BAAI/bge-m3 > results/ruler_fwe.txt 2>&1 &

