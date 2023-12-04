import 'dart:io';
import 'dart:collection';
import 'dart:math';

void main() {
    var myFile = File('assets/scratchcard.txt');
    List<String> myLines = myFile.readAsLinesSync();

    List<int> cards = List.generate(myLines.length, (index) => 1);
    List<int> matchesPerCard = [];//List.generate(myLines.length, (index) => 0);

    for (String line in myLines) {
        String nums = line.split(':')[1];

        List<String> parts = nums.split('|');

        List<int> winNums= parts[0].trim().split(' ').where((s) => s.isNotEmpty).toList().map(int.parse).toList();
        List<int> myNums = parts[1].trim().split(' ').where((s) => s.isNotEmpty).toList().map(int.parse).toList();

        var winNumbers = HashSet.from(winNums);
        var myNumbers = HashSet.from(myNums);

        if (winNumbers.intersection(myNumbers).isNotEmpty) {
            int matches = winNumbers.intersection(myNumbers).length;
            matchesPerCard.add(matches);
        }
        else {
            matchesPerCard.add(0);
        }
    }
    // print(matchesPerCard);
    print("matchesPerCard: $matchesPerCard");
    matchesPerCard.asMap().forEach((cardIdx, nMatches){
        if (nMatches > 0) {
            print('cardIdx: $cardIdx, nMatches: $nMatches');
            List<int> indices = List.generate(nMatches, (index) => index+1);
            List<int> iterations = List.generate(cards[cardIdx], (index) => 1);
            print('iterations: $iterations');
            for (int i in iterations){
                for (int idx in indices){
                    int newIdx = (cardIdx + idx);
                    if (newIdx <= (cards.length - 1)) {
                        cards[newIdx] += 1;
                    }
                }
        }
        }
    });
    print(cards);
    print(sum(cards));
}

int sum(List<int> list) {
    int sum = 0;
    for (int i in list) {
        sum += i;
    }
    return sum;
}