def parse_ranges(line):
    parts = line.split(': ')[1].split(' ')
    ranges = [(int(parts[i]), int(parts[i + 1])) for i in range(0, len(parts), 2)]
    return ranges

def parse_mappings(lines):
    mappings = {}
    current_map = None
    for line in lines:
        if line == '':
            current_map = None
        elif current_map is None:
            current_map = line.split(' ')[0].split('-to-')[1]
            mappings[current_map] = []
        else:
            parts = list(map(int, line.split(' ')))
            mappings[current_map].append(parts)
    return mappings

def apply_mapping(value, mapping):
    for dest_start, src_start, length in mapping:
        if src_start <= value < src_start + length:
            return dest_start + (value - src_start)
    return value  # Value unchanged if not in any range

def find_min_max_in_mapping(mapping):
    min_val = float('inf')
    max_val = -1
    for dest_start, src_start, length in mapping:
        min_val = min(min_val, dest_start)
        max_val = max(max_val, dest_start + length - 1)
    return min_val, max_val

def find_lowest_location(seed_ranges, mappings):
    min_max_values = {stage: find_min_max_in_mapping(mappings[stage]) for stage in mappings}
    lowest_location = float('inf')

    # Checking potential minimums and maximums
    for stage, (min_val, max_val) in min_max_values.items():
        for value in [min_val, max_val]:
            seed = reverse_map(value, mappings)
            if is_seed_in_range(seed, seed_ranges):
                lowest_location = min(lowest_location, value)

    return lowest_location

def reverse_map(location, mappings):
    for stage in reversed(list(mappings.keys())):
        mapping = mappings[stage]
        for dest_start, src_start, length in reversed(mapping):
            if dest_start <= location < dest_start + length:
                location = src_start + (location - dest_start)
                break
    return location

def is_seed_in_range(seed, seed_ranges):
    for start, length in seed_ranges:
        if start <= seed < start + length:
            return True
    return False

# Read the file and parse the seed ranges and mappings
with open('assets/almanac.txt', 'r') as file:
    lines = file.read().split('\n')
seed_ranges = parse_ranges(lines[0])
mappings = parse_mappings(lines[1:])

# Find the lowest location number
lowest_location = find_lowest_location(seed_ranges, mappings)
print(f'Lowest location number: {lowest_location}')
