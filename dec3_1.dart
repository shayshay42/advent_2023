import 'dart:io';

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

    List<int> numbers = [];
    myLines.asMap().forEach((lineIndex, lineString) {
        RegExp exp = RegExp(r'\d+');
        Iterable<RegExpMatch> matches = exp.allMatches(lineString);
        matches.forEach((match) {
            bool symbolAdjacent = false;
            for (int digitIdx = match.start; digitIdx < match.end; digitIdx++) {
                if (symbolAdjacent) { break; }
                int digit = int.parse(lineString[digitIdx]);
                int row = lineIndex;
                int col = digitIdx;
                for (int i = 0; i < surround.length; i++) {
                    int newRow = row + surround[i][0];
                    int newCol = col + surround[i][1];
                    if (newRow >= 0 && newRow < myLines.length &&
                        newCol >= 0 && newCol < myLines[newRow].length) {
                        String newChar = myLines[newRow][newCol];
                        if (!isAlphanumeric(newChar)) {
                            symbolAdjacent = true;
                            break;
                        }
                    }
                }
            }
            if (symbolAdjacent) {
                int number = int.parse(lineString.substring(match.start, match.end));
                numbers.add(number); // Add the number to the list
            }
        });
        // for (int charIndex = 0; charIndex < lineString.length; i++) {
        //     // if (!isAlphanumeric(lineString[charIndex])) {}
        // }
    });
    print(numbers);
    print(sum(numbers));
}

bool isAlphanumeric(String str) {
    // Include period in the regular expression
    return RegExp(r'^[a-zA-Z0-9.]+$').hasMatch(str);
}

int sum(List<int> numbers) {
    return numbers.fold(0, (a, b) => a + b);
}