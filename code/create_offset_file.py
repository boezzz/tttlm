"""Server for Pile index."""

import argparse
from tqdm import tqdm


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('--index_path', type=str, default='indices/00.index')
    parser.add_argument('--data_file', type=str, default='pile/train/00.jsonl')
    return parser.parse_args()


def write_offset_file(data_path, storage_path):

	# Step 1: Create an index of byte offsets
	index_file = storage_path
	json_file = data_path
	# Build the index (one-time operation)
	with open(json_file, "r") as f, open(index_file, "w") as index:
		offset = 0
		for line in tqdm(f):
			index.write(str(offset) + "\n")
			offset += len(line)  # Store byte position




if __name__ == '__main__':

    args = parse_args()
    create_pile_index(args.data_file,args.index_path)
    