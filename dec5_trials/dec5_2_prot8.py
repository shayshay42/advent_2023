def read_input(file_path):
    with open(file_path, "r") as file:
        data = file.read()
    seed_input_line, *mapping_blocks = data.split("\n\n")
    return seed_input_line, mapping_blocks

def parse_seed_ranges(seed_input_line):
    seed_values = list(map(int, seed_input_line.split(":")[1].split()))
    seed_ranges = []
    for i in range(0, len(seed_values), 2):
        seed_ranges.append([seed_values[i], seed_values[i] + seed_values[i + 1]])
    return seed_ranges

def apply_mappings(seed_ranges, mapping_blocks):
    for mapping_block in mapping_blocks:
        mapping_ranges = [list(map(int, line.split())) for line in mapping_block.splitlines()[1:]]
        new_seed_ranges = []
        
        while seed_ranges:
            start, end = seed_ranges.pop()
            for destination, source, length in mapping_ranges:
                overlap_start = max(start, source)
                overlap_end = min(end, source + length)

                if overlap_start < overlap_end:
                    new_seed_ranges.append(
                        [overlap_start - source + destination, overlap_end - source + destination])
                    if overlap_start > start:
                        seed_ranges.append([start, overlap_start])
                    if overlap_end < end:
                        seed_ranges.append([overlap_end, end])
                    break
            else:
                new_seed_ranges.append([start, end])

        seed_ranges = new_seed_ranges
    return seed_ranges

def find_lowest_seed(seed_ranges):
    return min(seed_ranges)[0]

# Main execution
file_path = "assets/almanac.txt"
seed_input_line, mapping_blocks = read_input(file_path)
seed_ranges = parse_seed_ranges(seed_input_line)
transformed_seed_ranges = apply_mappings(seed_ranges, mapping_blocks)
lowest_seed = find_lowest_seed(transformed_seed_ranges)

print(f"Lowest location number: {lowest_seed}")