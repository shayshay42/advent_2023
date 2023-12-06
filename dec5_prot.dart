import 'dart:io';
import 'dart:math'; // Import dart:math for the min function

void main() {
  int closestLoc = parseFile('assets/almanac.txt');
  print('Lowest location number: $closestLoc');
}

int parseFile(String filePath) {
  var myFile = File(filePath);
  List<String> lines = myFile.readAsLinesSync();

  Map<String, Map<int, int>> mappings = {};
  List<int> seeds = findSeeds(lines[0]);

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
        int dest = mappings[currentMap]?[srcStart + i] ?? (srcStart + i);
        mappings[currentMap]?[srcStart + i] = destStart + i;
      }
    }
  }

  return seeds.map((seed) => transformThroughStages(seed, mappings))
              .reduce(min);
}

int transformThroughStages(int seed, Map<String, Map<int, int>> mappings) {
  var stages = ['soil', 'fertilizer', 'water', 'light', 'temperature', 'humidity', 'location'];
  int current = seed;

  for (var stage in stages) {
    current = mappings[stage]?[current] ?? current;
  }

  return current;
}

List<int> findSeeds(String firstLine) {
  return firstLine.split(': ')[1].split(' ')
                  .map((s) => int.parse(s.trim()))
                  .toList();
}
