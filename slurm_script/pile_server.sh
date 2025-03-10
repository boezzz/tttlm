#!/bin/bash
#SBATCH --job-name=pile_servers
#SBATCH --output=servers/server-%A-%a.out
#SBATCH --error=servers/server-%A-%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=4:00:00
#SBATCH --array=0-29

# Load any required modules (if applicable)

# Define variables
DATA_FILES=(00.jsonl 01.jsonl 02.jsonl 03.jsonl 04.jsonl 05.jsonl 06.jsonl 07.jsonl 08.jsonl 09.jsonl \
            10.jsonl 11.jsonl 12.jsonl 13.jsonl 14.jsonl 15.jsonl 16.jsonl 17.jsonl 18.jsonl 19.jsonl \
            20.jsonl 21.jsonl 22.jsonl 23.jsonl 24.jsonl 25.jsonl 26.jsonl 27.jsonl 28.jsonl 29.jsonl)

DATA_FILE=${DATA_FILES[$SLURM_ARRAY_TASK_ID]}
LOG_DIR="servers"

# Run the script
python3 code/pile_server.py \
    --address_path $LOG_DIR/addresses.txt \
    --data_file $DATA_FILE \
    --num_servers 1 \
    --logging_level DEBUG

