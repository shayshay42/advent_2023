import 'dart:io';
import 'dart:collection';
import 'dart:math';


/*
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
*/

void main() {
    int closestLoc = parseFile('assets/almanac_ex.txt');
    print('Lowest location number: $closestLoc');
}

int parseFile(String filePath) {
    var myFile = File(filePath);
    List<String> lines = myFile.readAsLinesSync();
    Map<String, Map<int, int>> mappings = new HashMap();
    List<int> seeds = findSeeds(lines[0]);
    List<int> sections = [];
    for (int i = 0; i < lines.length; i++) {
        if (lines[i] == '') {
            sections.add(i);
        }
    }
    List<String> allKeys = [];
    for (int i = 0; i < sections.length; i++) {
        String section = lines[sections[i]+1];
        List<String> header = section[0].split(' ')[0].split('-');
        String key = header[header.length-1];
        allKeys.add(key);
    }
    for (int i = 0; i < sections.length; i++) {
        List<String> section = lines.sublist(sections[i]+1, sections[i+1]);
        Map<String, Map<int, int>> map = parseSection(section);
        mappings.addAll(map);
    }
    List<int> locations = [];
    for (int seed in seeds) {
        int output = seed;
        for (int i = 0; i < allKeys.length; i++) {
            String kep = allKeys[i];
            // check if output is in the map other wise don't update output
            if (mappings[kep].containsKey(output)) {
                int output = mappings[kep][output];
            }
        }
        locations.add(output);
    }
    int minValue = locations.reduce((currentMin, element) => 
    element < currentMin ? element : currentMin);
    return minValue;
}

List<int> findSeeds(String firstLine) {
  // Split the line to get the part after ': ', then split by spaces to get individual seeds as strings
  List<String> seedStrings = firstLine.split(': ')[1].split(' ');

  // Convert each string seed into an int and return the list
  return seedStrings.map((seedString) => int.parse(seedString)).toList();
}

Map<String, Map<int, int>> parseSection(List<String> section) {
    Map<String, Map<int, int>> map = new HashMap();
    List<String> header = section[0].split(' ')[0].split('-');
    String key = header[header.length-1];
    // map[key] = int.parse(parts[1]);
    Map<int, int> mapping = new HashMap();
    List<int> fullSource = [];
    List<int> fullDest = [];
    for (String line in section.sublist(1, section.length-1)) {
        List<int> parts = line.split(' ')
                                        .map((s) => int.tryParse(s))
                                        .toList();
        int range = parts[parts.length-1];
        int srcStart = parts[1];
        int destStart = parts[0];
        List<int> sources = List.generate(range, (i) => srcStart + i);
        // extend the  fullSource list with the sources list
        fullSource.addAll(sources);
        List<int> destinations = List.generate(range, (i) => destStart + i);
        // extend the fullDest list with the destinations list
        fullDest.addAll(destinations);
    }
    mapping[fullSource] = fullDest;
    map[key] = mapping;
    return map;
}

