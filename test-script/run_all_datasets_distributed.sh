#!/bin/bash

# 主脚本：将所有数据集和子数据集分配到8张GPU卡上（0-7），循环分配

# 设置GPU数量
NUM_GPUS=8

# 定义所有数据集和子数据集
declare -a tasks=(
    # HotpotQA 子数据集
    "hotpotqa:eval_400"
    "hotpotqa:eval_1600"
    "hotpotqa:eval_3200"
    
    # NarrativeQA (单个数据集)
    "narrativeqa:test"
    
    # RULER 子数据集
    "ruler:qa_1"
    "ruler:qa_2"
    "ruler:vt"
    "ruler:niah_single_1"
    "ruler:niah_single_2"
    "ruler:niah_single_3"
    "ruler:niah_multikey_1"
    "ruler:niah_multikey_2"
    "ruler:niah_multikey_3"
    "ruler:niah_multiquery"
    "ruler:niah_multivalue"
    "ruler:cwe"
    "ruler:fwe"
    
    # LoCoMo (单个数据集)
    "locomo:locomo10"
)

# 创建日志目录
mkdir -p ./logs

# 函数：运行单个任务
run_task() {
    local task=$1
    local gpu_id=$2
    
    # 解析数据集名称和子数据集名称
    IFS=':' read -r dataset subdataset <<< "$task"
    
    echo "[GPU $gpu_id] 开始处理: $dataset - $subdataset"
    
    # 设置GPU
    export CUDA_VISIBLE_DEVICES=$gpu_id
    
    # 根据数据集类型运行相应的命令
    case $dataset in
        hotpotqa)
            base_outputdir=./results/hotpotqa
            mkdir -p $base_outputdir
            outputdir=$base_outputdir/${subdataset}
            
            python3 eval/hotpotqa_test.py \
                --data ./data/hotpotqa/${subdataset}.json \
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
                --embedding-model-path BAAI/bge-m3 \
                > ./logs/${dataset}_${subdataset}_gpu${gpu_id}.log 2>&1
            ;;
            
        narrativeqa)
            outputdir=./results/narrativeqa
            mkdir -p $outputdir
            
            python3 eval/narrativeqa_test.py \
                --data-dir ./data/narrativeqa \
                --split test \
                --outdir $outputdir \
                --start-idx 0 \
                --end-idx 300 \
                --max-tokens 2048 \
                --seed 42 \
                --memory-api-key "your-openai-api-key" \
                --memory-base-url "http://localhost:8000/v1" \
                --memory-model "gpt-4o-mini" \
                --research-api-key "your-openai-api-key" \
                --research-base-url "http://localhost:8000/v1" \
                --research-model "gpt-4o-mini" \
                --working-api-key "your-openai-api-key" \
                --working-base-url "http://localhost:8000/v1" \
                --working-model "gpt-4o-mini" \
                --embedding-model-path BAAI/bge-m3 \
                > ./logs/${dataset}_${subdataset}_gpu${gpu_id}.log 2>&1
            ;;
            
        ruler)
            base_outputdir=./results/ruler
            mkdir -p $base_outputdir
            outputdir=$base_outputdir/${subdataset}
            
            python3 eval/ruler_test.py \
                --data ./data/ruler/${subdataset}.jsonl \
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
                --embedding-model-path BAAI/bge-m3 \
                > ./logs/${dataset}_${subdataset}_gpu${gpu_id}.log 2>&1
            ;;
            
        locomo)
            outputdir=./results/locomo
            mkdir -p $outputdir
            
            python3 eval/locomo_test.py \
                --data ./data/locomo/locomo10.json \
                --outdir $outputdir \
                --start-idx 0 \
                --memory-api-key "your-openai-api-key" \
                --memory-base-url "http://localhost:8000/v1" \
                --memory-model "gpt-4o-mini" \
                --research-api-key "your-openai-api-key" \
                --research-base-url "http://localhost:8000/v1" \
                --research-model "gpt-4o-mini" \
                --working-api-key "your-openai-api-key" \
                --working-base-url "http://localhost:8000/v1" \
                --working-model "gpt-4o-mini" \
                > ./logs/${dataset}_${subdataset}_gpu${gpu_id}.log 2>&1
            ;;
            
        *)
            echo "未知的数据集类型: $dataset"
            return 1
            ;;
    esac
    
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo "[GPU $gpu_id] 完成: $dataset - $subdataset (成功)"
    else
        echo "[GPU $gpu_id] 完成: $dataset - $subdataset (失败, 退出码: $exit_code)"
    fi
    
    return $exit_code
}

# 主循环：分配任务到GPU
total_tasks=${#tasks[@]}
echo "总共 $total_tasks 个子数据集需要处理"
echo "使用 $NUM_GPUS 张GPU卡 (0-$((NUM_GPUS-1)))"
echo ""

# 存储后台进程的PID
declare -a pids=()

# 遍历所有任务，循环分配到GPU
for i in "${!tasks[@]}"; do
    task=${tasks[$i]}
    gpu_id=$((i % NUM_GPUS))
    
    echo "分配任务 $((i+1))/$total_tasks: $task -> GPU $gpu_id"
    
    # 在后台运行任务
    run_task "$task" $gpu_id &
    pids+=($!)
    
    # 可选：添加小延迟以避免同时启动过多进程
    sleep 1
done

echo ""
echo "所有任务已启动，等待完成..."
echo "可以使用以下命令查看日志:"
echo "  tail -f ./logs/*.log"
echo ""

# 等待所有后台进程完成
failed_tasks=0
for i in "${!pids[@]}"; do
    pid=${pids[$i]}
    task=${tasks[$i]}
    wait $pid
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
        failed_tasks=$((failed_tasks + 1))
        echo "任务失败: $task (PID: $pid)"
    fi
done

echo ""
echo "=========================================="
echo "所有任务完成!"
echo "成功: $((total_tasks - failed_tasks))/$total_tasks"
echo "失败: $failed_tasks/$total_tasks"
echo "=========================================="

