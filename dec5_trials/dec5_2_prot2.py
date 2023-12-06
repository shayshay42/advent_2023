# The provided Dart code can be translated and optimized in Python, including leveraging numpy for efficient array operations.
# The Python code will follow the same logic as the Dart code, but with Python syntax and optimizations.

import numpy as np

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

def process_seed_ranges(file_path):
    """
    Process the file with ranges of seeds and apply the mapping rules
    to find the lowest location number.
    """
    with open(file_path, 'r') as file:
        lines = file.readlines()

    seeds = find_seed_ranges(lines[0])
    mappings = extract_mappings(lines)

    # Using a set to avoid duplicate calculations for the same seed
    unique_seeds = set(seeds)
    final_values = [find_final_value(seed, mappings) for seed in unique_seeds]
    return min(final_values)


def parse_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    seeds = find_seeds(lines[0])
    mappings = extract_mappings(lines)

    final_values = [find_final_value(seed, mappings) for seed in seeds]
    return min(final_values)

def find_seeds(first_line):
    return list(map(int, first_line.split(': ')[1].split()))

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

    return mappings

def find_final_value(seed, mappings):
    current_value = seed
    trajectory = [f'Seed {seed}']

    for stage, map_ in mappings.items():
        for mapping in map_:
            dest_start, src_start, range_ = mapping
            if src_start <= current_value < src_start + range_:
                current_value = dest_start + (current_value - src_start)
                trajectory.append(f' -> {stage} {current_value}')
                break

    print(''.join(trajectory))
    return current_value

# The almanac data needs to be provided in a text file.
# For this example, let's assume the data is provided correctly in a file named "almanac.txt".
file_path = 'assets/almanac.txt'
lowest_location_number = process_seed_ranges(file_path)
lowest_location_number

