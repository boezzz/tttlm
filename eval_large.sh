#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=48:00:00
#SBATCH --ntasks=1
#SBATCH --job-name=eval_tttlm
#SBATCH --gpus=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=32GB



export XDG_CACHE_HOME=$PWD/.cache
export TRANSFORMERS_CACHE=$PWD/.cache
export HF_HOME=$PWD/.cache
export TORCH_HOME=$PWD/.cache
export PYTHON_EGG_CACHE=$PWD/.cache

# Ensure Conda is properly initialized
source /mmfs1/home/lindq2/miniconda3/bin/activate

# Activate the target environment
conda activate /gscratch/scrubbed/lindq2/tttlm_env

# Debugging: Print which Python is being used
which python
python --version

# Run the evaluation script
python3 code/eval_tttlm.py --task pile_github  --num_neighbors 20 --model gpt2-large --tokenizer gpt2-large --embedding_model_checkpoint models/roberta-large-pile-lr2e-5-bs16-8gpu/checkpoint-1700000 --max_length 1024 --stride 1024 --learning_rate 2e-5 --address_path servers/addresses.txt --results_dir results_large/ > job_output_github_large.log 2>&1 
