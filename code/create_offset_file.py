"""Server for Pile index."""

import argparse
from tqdm import tqdm


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('--filename', type=str, default='00')
    parser.add_argument('--all', action='store_true')
    return parser.parse_args()


def write_offset_file(filename):

    # Step 1: Create an index of byte offsets
    index_file = "offsets/"+filename+".index"
    json_file = "pile/train/"+filename+".jsonl"
    # Build the index (one-time operation)
    with open(json_file, "r") as f, open(index_file, "w") as index:
        offset = 0
        for line in tqdm(f):
            index.write(str(offset) + "\n")
            offset += len(line)  # Store byte position




if __name__ == '__main__':

    args = parse_args()
    if args.all:
        for i in range(3):
            for j in range(10):
                fiel = str(i)+str(j)
                write_offset_file(filename)
    else:
        write_offset_file(args.filename)
    