import 'dart:io';
import 'dart:math'; // Import dart:math for the min function

void main() {
  int closestLoc = parseFile('assets/almanac_ex.txt');
  print('Lowest location number: $closestLoc');
}

int parseFile(String filePath) {
    var myFile = File(filePath);
    List<String> lines = myFile.readAsLinesSync();

    List<int> seeds = findSeeds(lines[0]);
    List<int> sections = [];
    for (int i = 0; i < lines.length; i++) {
        if (lines[i] == '') {
            sections.add(i);
        }
    }
    String currentMap = '';
    List<int> locations = [];
    for (int seed in seeds) {
        int source = seed;
        List<int> trajectory = [];
        trajectory.add(source);
        for (int i = 1; i < lines.length; i++) {
        // var line in lines.skip(1)) {
            String line = lines[i];
            // added = false
            print("line is $line");
            // print("seed is $seed");
            if (line.trim().isEmpty) {
                currentMap = '';
                continue;
            }
            if (currentMap.isEmpty) {
                currentMap = "not empty"; // line.split(' ')[0].split('-to-')[1].trim();
                // mappings[currentMap] = {};
            } else {
                var parts = line.split(' ').map((s) => int.parse(s)).toList();
                int destStart = parts[0], srcStart = parts[1], range = parts[2];
                if (srcStart <= source && source < (srcStart + (range))) {
                    source = destStart + (source - srcStart); //maybe need a -1
                    trajectory.add(source);
                    print("source is $source");
                } else {
                    if (sections.contains(i+1)) {
                        trajectory.add(source);
                        // added = true;
                        print("source is $source");
                        trajectory.add(source);
                    }
                }
            }
                // for (int i = 0; i < range; i++) {
                //     int dest = mappings[currentMap]?[srcStart + i] ?? (srcStart + i);
                //     mappings[currentMap]?[srcStart + i] = destStart + i;
        }
        int location = source;
        print("the trajectory is $trajectory");
        locations.add(location);
    }
    return locations.reduce(min);
}

List<int> findSeeds(String firstLine) {
  return firstLine.split(': ')[1].split(' ')
                  .map((s) => int.parse(s.trim()))
                  .toList();
}
