import 'dart:io';
import 'dart:math';

void main() {
  String filePath = 'assets/almanac_ex.txt';
  var mappings = extractMappings(File(filePath).readAsLinesSync());
  List<List<int>> seedRanges = findSeeds(File(filePath).readAsLinesSync()[0]);

  int lowestLocation = findLowestLocation(seedRanges, mappings);
  print('Lowest location number: $lowestLocation');
}

List<List<int>> findSeeds(String firstLine) {
  var parts = firstLine.split(': ')[1].split(' ').map(int.parse).toList();
  List<List<int>> seedRanges = [];
  for (int i = 0; i < parts.length; i += 2) {
    seedRanges.add([parts[i], parts[i] + parts[i + 1] - 1]);
  }
  return seedRanges;
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

int findLowestLocation(List<List<int>> seedRanges, Map<String, List<List<int>>> mappings) {
  int potentialLocation = 0; // Starting with a low location number
  while (true) {
    int reverseMappedSeed = reverseMap(potentialLocation, mappings);
    if (isSeedInRange(reverseMappedSeed, seedRanges)) {
      return potentialLocation; // Found a valid location number
    }
    potentialLocation++; // Increment and check the next location number
  }
}

int reverseMap(int value, Map<String, List<List<int>>> mappings) {
  int currentValue = value;
  List<String> stages = mappings.keys.toList().reversed.toList();
  for (var stage in stages) {
    bool found = false;
    for (var mapping in mappings[stage]!.reversed) {
      int destStart = mapping[0], srcStart = mapping[1], range = mapping[2];
      if (currentValue >= destStart && currentValue < destStart + range) {
        currentValue = srcStart + (currentValue - destStart);
        found = true;
        break;
      }
    }
    if (!found) {
      currentValue = value; // If no mapping found, keep the current value
    }
  }
  return currentValue;
}

bool isSeedInRange(int seed, List<List<int>> seedRanges) {
  for (var range in seedRanges) {
    if (seed >= range[0] && seed <= range[1]) {
      return true;
    }
  }
  return false;
}