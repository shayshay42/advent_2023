import 'dart:io';

int allDistances(String filePath) {
    final file = File(filePath);
    List<String> lines = file.readAsLinesSync();

    // Parsing times and records from the file
    List<int> times = lines[0].split(':')[1].trim().split(RegExp(r'\s+')).map(int.parse).toList();
    List<int> records = lines[1].split(':')[1].trim().split(RegExp(r'\s+')).map(int.parse).toList();

    print('Times: $times');
    print('Records: $records');

    int totalWays = 1;

    for (int i = 0; i < times.length; i++) {
        int time = times[i];
        int record = records[i];
        int waysToWin = 0;

        for (int holdTime = 0; holdTime <= time; holdTime++) {
            int distance = holdTime * (time - holdTime);
            if (distance > record) {
                waysToWin++;
            }
        }

    totalWays *= waysToWin;
    }

    return totalWays;
}

void main() {
    try {
        int result = allDistances('assets/race_times.txt');
        print("Total ways to win: $result");
    } catch (e) {
        print('An error occurred: $e');
    }
}
