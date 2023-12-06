import 'dart:io';

int allDistancesRange(String filePath) {
    final file = File(filePath);
    List<String> lines = file.readAsLinesSync();

    // Concatenating the numbers on each line into a single number
    int time = int.parse(lines[0].split(':')[1].replaceAll(RegExp(r'\s+'), ''));
    int record = int.parse(lines[1].split(':')[1].replaceAll(RegExp(r'\s+'), ''));

    print('Time: $time');
    print('Record: $record');

    int minHoldTime = 0;
    while (minHoldTime * (time - minHoldTime) <= record) {
        minHoldTime++;
    }

    int maxHoldTime = time;
    while (maxHoldTime > time / 2 && maxHoldTime * (time - maxHoldTime) <= record) {
        maxHoldTime--;
    }

    int waysToWin = maxHoldTime - minHoldTime + 1;
    return waysToWin;
}

void main() {
    try {
        int result = allDistancesRange('assets/race_times.txt');
        print("Total ways to win: $result");
    } catch (e) {
        print('An error occurred: $e');
    }
}
