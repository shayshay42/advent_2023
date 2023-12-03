import 'dart:io';
import 'dart:collection';

/*
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
*/
void main() {
    var myFile = File('assets/engine_parts.txt');

    List<String> myLines = myFile.readAsLinesSync();
    List<List<int>> surround = [[-1, -1], [-1, 0], [-1, 1], 
                                [ 0, -1],          [ 0, 1], 
                                [ 1, -1], [ 1, 0], [ 1, 1]];

    List<List<int>> gears = [];
    myLines.asMap().forEach((lineIndex, lineString) {
        List<int> positions = findAllStars(lineString);
        for (int starPos in positions) {
            int row = lineIndex;
            int col = starPos;
            List<int> gearRatio = [];
            for (int i = -1; i <= 1; i++) {
                int newRow = row + i;
                if (newRow >= 0 && newRow < myLines.length) { //so that we don't go out of bounds
                    RegExp exp = RegExp(r'\d+');
                    String newlineString = myLines[newRow];
                    Iterable<RegExpMatch> matches = exp.allMatches(newlineString);
                    matches.forEach((match) {
                        // bool starAdjacent = false;
                        List<int> possibleNewCols = [col - 1, col, col + 1];
                        // Create a range from match.start to match.end
                        var rangeNumber = HashSet.from(List.generate(match.end - match.start, (i) => i + match.start));

                        // Check for intersection with possibleNewCols
                        if (rangeNumber.intersection(HashSet.from(possibleNewCols)).isNotEmpty) {
                            int number = int.parse(newlineString.substring(match.start, match.end));
                            gearRatio.add(number);
                        }
                    });
                }
            }
            if (gearRatio.length == 2) {
                gears.add(gearRatio);
            }
        }
    });
    print(sumOfProducts(gears));
}

List<int> findAllStars(String line) {
    List<int> positions = [];
    for (int i = 0; i < line.length; i++) {
        if (line[i] == '*') {
            positions.add(i);
        }
    }
    return positions; // Ensure this function always returns a list
}

int sumOfProducts(List<List<int>> list) {
  int sum = 0;
  for (List<int> sublist in list) {
    sum += sublist[0] * sublist[1];
  }
  return sum;
}