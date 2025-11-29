#!/bin/bash

# Activate your conda/virtual environment if needed
# source /path/to/your/conda/bin/activate your_env

# Set output directory
outputdir=./results/narrativeqa

# Create output directory
mkdir -p $outputdir

# Run NarrativeQA evaluation
python3 eval/narrativeqa_test.py \
    --data-dir /path/to/narrativeqa/data \
    --split test \
    --outdir $outputdir \
    --start-idx 0 \
    --end-idx 300 \
    --max-tokens 2048 \
    --seed 42
    # --embedding-model-path /path/to/embedding/model \

