#!/bin/bash

# Activate your conda/virtual environment if needed
# source /path/to/your/conda/bin/activate your_env

# Set output directory
outputdir=./results/hotpotqa

# Create output directory
mkdir -p $outputdir

# Run HotpotQA evaluation
python3 eval/hotpot_test.py \
    --data /path/to/hotpotqa/eval.json \
    --outdir $outputdir \
    --start-idx 0 \
    --max-tokens 2048
    # --end-idx 100 \
    # --embedding-model-path /path/to/embedding/model \