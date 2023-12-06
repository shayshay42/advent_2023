import 'dart:io';
import 'dart:math';

void main() {
  int closestLoc = parseFile('assets/almanac.txt');
  print('Lowest location number: $closestLoc');
}

int parseFile(String filePath) {
  var myFile = File(filePath);
  List<String> lines = myFile.readAsLinesSync();

  List<int> seeds = findSeeds(lines[0]);
  var mappings = extractMappings(lines);

  List<int> finalValues = [];
  for (var seed in seeds) {
    finalValues.add(findFinalValue(seed, mappings));
  }

  return finalValues.reduce(min);
}

List<int> findSeeds(String firstLine) {
  return firstLine.split(': ')[1].split(' ')
                  .map((s) => int.parse(s.trim()))
                  .toList();
}

Map<String, List<List<int>>> extractMappings(List<String> lines) {
  Map<String, List<List<int>>> mappings = {};
  String currentMap = '';

  for (var line in lines.skip(1)) {
    if (line.trim().isEmpty) {
      currentMap = '';
      continue;
    }

    if (currentMap.isEmpty) {
      currentMap = line.split(':')[0].trim();
      mappings[currentMap] = [];
    } else {
      var parts = line.split(' ').map((s) => int.parse(s)).toList();
      if (parts.length == 3) {
        mappings[currentMap]?.add(parts);
      }
    }
  }

  return mappings;
}

int findFinalValue(int seed, Map<String, List<List<int>>> mappings) {
  int currentValue = seed;
  List<String> trajectory = ['Seed $seed'];

  mappings.forEach((stage, map) {
    for (var mapping in map) {
      int destStart = mapping[0], srcStart = mapping[1], range = mapping[2];
      if (currentValue >= srcStart && currentValue < srcStart + range) {
        currentValue = destStart + (currentValue - srcStart);
        trajectory.add(' -> $stage $currentValue');
        break;
      }
    }
  });

  print(trajectory.join(''));
  return currentValue;
}
