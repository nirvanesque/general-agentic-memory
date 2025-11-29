#!/bin/bash

# Activate your conda/virtual environment if needed
# source /path/to/your/conda/bin/activate your_env
source /root/anaconda3/bin/activate /share/project/chaofan/envs/demo
cd /share/project/chaofan/code/memory/gam-github/general-agentic-memory

# Set output directory
base_outputdir=./results/hotpotqa

# Create output directory
mkdir -p $base_outputdir

dataset="eval_400"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=0 nohup python3 eval/hotpotqa_test.py \
    --data ./data/hotpotqa/${dataset}.json \
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
    --embedding-model-path BAAI/bge-m3 > results/hotpotqa_56k.txt 2>&1 &

dataset="eval_1600"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=1 nohup python3 eval/hotpotqa_test.py \
    --data ./data/hotpotqa/${dataset}.json \
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
    --embedding-model-path BAAI/bge-m3 > results/hotpotqa_56k.txt 2>&1 &

dataset="eval_6400"
outputdir=$base_outputdir/${dataset}
CUDA_VISIBLE_DEVICES=2 nohup python3 eval/hotpotqa_test.py \
    --data ./data/hotpotqa/${dataset}.json \
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
    --embedding-model-path BAAI/bge-m3 > results/hotpotqa_56k.txt 2>&1 &
