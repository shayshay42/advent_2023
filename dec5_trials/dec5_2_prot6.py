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

def find_lowest_location(seed_ranges, mappings):
    lowest_location = float('inf')
    for start, length in seed_ranges:
        for seed in range(start, start + length):
            location = seed
            for stage in ['soil', 'fertilizer', 'water', 'light', 'temperature', 'humidity', 'location']:
                location = apply_mapping(location, mappings[stage])
            lowest_location = min(lowest_location, location)
    return lowest_location

# Read the file
with open('assets/almanac_ex.txt', 'r') as file:
    lines = file.read().split('\n')

# Parse the seed ranges and mappings
seed_ranges = parse_ranges(lines[0])
mappings = parse_mappings(lines[1:])

# Find the lowest location number
lowest_location = find_lowest_location(seed_ranges, mappings)
print(f'Lowest location number: {lowest_location}')
