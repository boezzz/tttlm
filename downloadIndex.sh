#!/bin/bash

# run this under the folder you want to save the index

# Define a mapping of six-digit indices to filenames
declare -A FILE_MAP=(
    ["212354"]="00.jsonl.index"
    ["212364"]="01.jsonl.index"
    ["212366"]="02.jsonl.index"
    ["212368"]="03.jsonl.index"
    ["212370"]="04.jsonl.index"
    ["212372"]="05.jsonl.index"
    ["212374"]="06.jsonl.index"
    ["212376"]="07.jsonl.index"
    ["212378"]="08.jsonl.index"
    ["212380"]="09.jsonl.index"
    ["212355"]="10.jsonl.index"
    ["212356"]="11.jsonl.index"
    ["212357"]="12.jsonl.index"
    ["212358"]="13.jsonl.index"
    ["212359"]="14.jsonl.index"
    ["212360"]="15.jsonl.index"
    ["212361"]="16.jsonl.index"
    ["212362"]="17.jsonl.index"
    ["212363"]="18.jsonl.index"
    ["212365"]="19.jsonl.index"
    ["212367"]="20.jsonl.index"
    ["212369"]="21.jsonl.index"
    ["212371"]="22.jsonl.index"
    ["212373"]="23.jsonl.index"
    ["212375"]="24.jsonl.index"
    ["212377"]="25.jsonl.index"
    ["212379"]="26.jsonl.index"
    ["212381"]="27.jsonl.index"
    ["212382"]="28.jsonl.index"
    ["212383"]="29.jsonl.index"
)


# Function to download a single file
download_file() {
    local ID="$1"
    local FILE_NAME="${FILE_MAP[$ID]}"
    local URL="https://edmond.mpg.de/api/access/datafile/${ID}?format=original&gbrecs=true"


    echo "Downloading ${URL} as ${FILE_NAME}..."
    wget -q -O "$FILE_NAME" "$URL" && echo "Downloaded ${FILE_NAME}" || echo "Failed: ${FILE_NAME}"
}

# Export the function for parallel execution
export -f download_file
export OUTPUT_DIR
export -A FILE_MAP

# Run all downloads in parallel, limiting to 6 concurrent downloads
echo "Starting parallel downloads..."
for ID in "${!FILE_MAP[@]}"; do
    download_file "$ID" &
    if (( $(jobs -r | wc -l) >= 6 )); then
        wait -n  # Wait for at least one job to finish before continuing
    fi
done

# Wait for all remaining jobs to finish
wait

echo "All downloads completed."
