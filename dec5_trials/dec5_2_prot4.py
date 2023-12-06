import numpy as np
from multiprocessing import Pool

def find_final_value_vectorized(seed, mappings):
    current_value = seed
    for stage, map_ in mappings.items():
        src_starts = map_[:, 1]
        src_ends = src_starts + map_[:, 2]
        mask = (current_value >= src_starts) & (current_value < src_ends)

        if np.any(mask):
            idx = np.where(mask)[0][0]
            dest_start, src_start, _ = map_[idx]
            current_value = dest_start + (current_value - src_start)
    return current_value

def process_seeds_parallel(seeds, mappings):
    # Using multiprocessing to parallelize the computation
    with Pool() as pool:
        final_values = pool.starmap(find_final_value_vectorized, [(seed, mappings) for seed in seeds])
    return np.min(final_values)
def find_seed_ranges(first_line):
    """
    Interpret the first line as ranges of seed numbers.
    Each range consists of a start number and a length.
    """
    parts = list(map(int, first_line.split(': ')[1].split()))
    seeds = []
    for i in range(0, len(parts), 2):
        start, length = parts[i], parts[i+1]
        seeds.extend(range(start, start + length))
    return seeds
def extract_mappings(lines):
    mappings = {}
    current_map = ''

    for line in lines[1:]:
        line = line.strip()
        if not line:
            current_map = ''
            continue

        if not current_map:
            current_map = line.split(':')[0].strip()
            mappings[current_map] = []
        else:
            parts = list(map(int, line.split()))
            if len(parts) == 3:
                mappings[current_map].append(parts)

    return mappings  # Added return statement


def main_optimized(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    seeds = np.array(find_seed_ranges(lines[0]), dtype=np.int32)
    mappings = {stage: np.array(map_, dtype=np.int32) for stage, map_ in extract_mappings(lines).items()}
    return process_seeds_parallel(seeds, mappings)

import multiprocessing
import time

if __name__ == "__main__":
    multiprocessing.set_start_method('spawn')  # or 'forkserver'
    file_path = 'assets/almanac_ex.txt'
    start = time.time()
    lowest_location_number = main_optimized(file_path)
    end = time.time()
    print(f'time spent: {end - start}')
    print(lowest_location_number)
