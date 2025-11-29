#!/bin/bash

# Activate your conda/virtual environment if needed
# source /path/to/your/conda/bin/activate your_env

# Set base output directory
base_outputdir=./results/ruler

# Create base output directory
mkdir -p $base_outputdir

# Process all RULER datasets
for dataset in "cwe" "fwe" "qa_1" "qa_2" "vt" "niah_single_1" "niah_single_2" "niah_single_3" "niah_multikey_1" "niah_multikey_2" "niah_multikey_3" "niah_multiquery" "niah_multivalue"
do 
    echo "Processing dataset: $dataset"
    outputdir=$base_outputdir/${dataset}
    
    python3 eval/ruler_test.py \
        --data /path/to/ruler/data/${dataset}.jsonl \
        --outdir $outputdir \
        --start-idx 0 \
        --max-tokens 2048
        # --end-idx 100 \
        # --embedding-model-path /path/to/embedding/model \
done

