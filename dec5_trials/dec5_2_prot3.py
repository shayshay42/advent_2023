import numpy as np
import numba

# Define constants for the number of stages and the number of mappings per stage
NUM_STAGES = 7  # Adjust based on your actual number of stages
MAX_MAPPINGS_PER_STAGE = 100  # Estimate the maximum number of mappings per stage

@numba.njit
def find_final_value_numba(seed, mappings, stage_lengths):
    current_value = seed
    offset = 0
    for stage in range(NUM_STAGES):
        for i in range(stage_lengths[stage]):
            mapping = mappings[offset + i]
            dest_start, src_start, range_ = mapping
            if src_start <= current_value < src_start + range_:
                current_value = dest_start + (current_value - src_start)
                break
        offset += stage_lengths[stage]
    return current_value

@numba.njit(parallel=True)
def process_seed_ranges_numba(seeds, mappings, stage_lengths):
    final_values = np.empty(len(seeds), dtype=np.int32)
    for i in numba.prange(len(seeds)):
        final_values[i] = find_final_value_numba(seeds[i], mappings, stage_lengths)
    return np.min(final_values)

def convert_mappings_for_numba(mappings):
    numba_mappings = np.zeros((NUM_STAGES * MAX_MAPPINGS_PER_STAGE, 3), dtype=np.int32)
    stage_lengths = np.zeros(NUM_STAGES, dtype=np.int32)
    offset = 0
    for stage, stage_mappings in enumerate(mappings.values()):
        for mapping in stage_mappings:
            numba_mappings[offset] = mapping
            offset += 1
        stage_lengths[stage] = len(stage_mappings)
    return numba_mappings, stage_lengths
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
def main(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    seeds = np.array(find_seed_ranges(lines[0]), dtype=np.int32)
    mappings, stage_lengths = convert_mappings_for_numba(extract_mappings(lines))
    return process_seed_ranges_numba(seeds, mappings, stage_lengths)

import time
if __name__ == "__main__":
    file_path = 'assets/almanac_ex.txt'
    start_time = time.time()
    lowest_location_number = main(file_path)
    end_time = time.time()
    print(f"Execution Time: {end_time - start_time} seconds")
    print(lowest_location_number)
