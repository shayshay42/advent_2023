import 'dart:io';
import 'dart:math';

void main() {
  // Load the file
  String filePath = 'assets/almanac.txt';
  var myFile = File(filePath);
  List<String> lines = myFile.readAsLinesSync();

  // Extract seeds and mappings
  List<int> seeds = findSeeds(lines[0]);
  Map<String, Map<int, int>> precomputedMappings = extractAndPrecomputeMappings(lines);

  // Calculate and print the lowest location number
  int closestLoc = findLowestLocation(seeds, precomputedMappings);
  print('Lowest location number: $closestLoc');
}

List<int> findSeeds(String firstLine) {
  return firstLine.split(': ')[1].split(' ')
                  .map((s) => int.parse(s.trim()))
                  .toList();
}

Map<String, Map<int, int>> extractAndPrecomputeMappings(List<String> lines) {
  Map<String, Map<int, int>> mappings = {};
  String currentMap = '';
  
  for (var line in lines.skip(1)) {
    if (line.trim().isEmpty) {
      currentMap = '';
      continue;
    }

    if (currentMap.isEmpty) {
      currentMap = line.split(' ')[0].split('-to-')[1].trim();
      mappings[currentMap] = {};
    } else {
      var parts = line.split(' ').map((s) => int.parse(s)).toList();
      int destStart = parts[0], srcStart = parts[1], range = parts[2];
      for (int i = 0; i < range; i++) {
        mappings[currentMap]?[srcStart + i] = destStart + i; // Null-aware access
      }
    }
  }

  return mappings;
}

int findLowestLocation(List<int> seeds, Map<String, Map<int, int>> precomputedMappings) {
  var stages = ['soil', 'fertilizer', 'water', 'light', 'temperature', 'humidity', 'location'];
  
  int lowestLocation = seeds.map((seed) {
    int current = seed;
    for (var stage in stages) {
      current = precomputedMappings[stage]?[current] ?? current; // Null-aware access
    }
    return current;
  }).reduce(min);

  return lowestLocation;
}
