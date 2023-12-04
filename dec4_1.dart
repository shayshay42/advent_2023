import 'dart:io';
import 'dart:collection';
import 'dart:math';

void main() {
    var myFile = File('assets/scratchcard.txt');
    List<String> myLines = myFile.readAsLinesSync();

    List<int> points = [];
    for (String line in myLines) {
        String nums = line.split(':')[1];
        // print(nums); 
    
        // List<int> winNums, myNums;
        List<String> parts = nums.split('|');
        // print(parts);
        // print(parts.length);
        // print(parts[0].trim().split(' '));
        // print(parts[1].trim().split(' '));
        // List<String> words = str.split(' ').where((s) => s.isNotEmpty).toList();
        // if (parts.length == 2) {
        List<int> winNums= parts[0].trim().split(' ').where((s) => s.isNotEmpty).toList().map(int.parse).toList();
        List<int> myNums = parts[1].trim().split(' ').where((s) => s.isNotEmpty).toList().map(int.parse).toList();
        // print(winNums);
        // print(myNums);
        // }
        var winNumbers = HashSet.from(winNums);
        var myNumbers = HashSet.from(myNums);
        // Check for intersection with possibleNewCols
        if (winNumbers.intersection(myNumbers).isNotEmpty) {
            int matches = winNumbers.intersection(myNumbers).length;
            int point = pow(2, (matches - 1)).toInt();
            points.add(point);
        }
        else {
            points.add(0);
        }
    }
    print(sum(points));
}

int sum(List<int> list) {
    int sum = 0;
    for (int i in list) {
        sum += i;
    }
    return sum;
}