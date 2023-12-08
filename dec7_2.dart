import 'dart:io';

Map<String, int> parseFile(String filePath) {
    final file = File(filePath);
    List<String> lines = file.readAsLinesSync();
    Map<String, int> cards = {};
    for (String line in lines) {
        var parts = line.split(' ');
        String card = parts[0];
        int value = int.parse(parts[1]);
        cards[card] = value;
    }
    return cards;
}

int countOccurrences(List<String> list, String element) {
    return list.where((item) => item == element).length;
}

int getHandType(List<String> hand, [Map<String, int> types = const {'five': 7, 'four': 6, 'full': 5, 'three': 4, 'two': 3, 'pair': 2, 'high': 1}]) {
    Set<String> uniqueHand = hand.toSet(); // Remove duplicates
    List<String> uniqueList = uniqueHand.toList();
    if (uniqueHand.length == 1) {
        return types['five']!;
    } else if (uniqueHand.length == 2) {
        if (uniqueList[0] == 'J' || uniqueList[1] == 'J') {
            return types['five']!;
        } else if (countOccurrences(hand, uniqueList[0]) == 4 || countOccurrences(hand, uniqueList[1]) == 4) {
            return types['four']!;
        } else {
            return types['full']!;
        }
    } else if (uniqueHand.length == 3) {
        //  3 1 1   2 2 1
        bool scenarioOne = false;
        for (String card in uniqueList) {
            if (countOccurrences(hand, card) > 2) {
                scenarioOne = true;
            }
        }
        if (scenarioOne) {
            if (hand.contains('J')) {
                return types['four']!;
            } else {
                return types['three']!;
            }
        } else {
            if (hand.contains('J')) {
                if (countOccurrences(hand, 'J') > 1) {
                    return types['four']!;
                } else {
                    return types['full']!;
                }
            } else {
                return types['two']!;
            }
        }
    } else if (uniqueHand.length == 4) {
        // 2 1 1 1   
        if (hand.contains('J')) {
            return types['three']!;
        } else {
            return types['pair']!;
        }
    } else {
        // 1 1 1 1 1
        if (hand.contains('J')) {
            return types['pair']!;
        } else {
            return types['high']!;
        }
    }
}


String getCardRankings(String hand, [Map<String, String> cardStrengths = const {'A': '13',
                                                                                'K': '12',
                                                                                'Q': '11',
                                                                                'T': '10',
                                                                                '9': '09',
                                                                                '8': '08',
                                                                                '7': '07',
                                                                                '6': '06',
                                                                                '5': '05',
                                                                                '4': '04',
                                                                                '3': '03',
                                                                                '2': '02',
                                                                                'J': '01',}]) {
    String strength = '';
    for (String card in hand.split('')) {
        strength += cardStrengths[card]!;
    }
    return strength;
}

void main() {
    Map<String,
int> cards = parseFile('assets/camel_cards.txt');

    Map<String, int> hands = {};
    for (String hand in cards.keys) {
        List<String> handList = hand.split(''); // Split the string into a list of characters
        int typeStrength = getHandType(handList);
        String cardStrength = getCardRankings(hand);
        String handStrength = typeStrength.toString() + cardStrength;
        hands[hand] = int.parse(handStrength);
    }
    // Sort the hands map by value in reverse order
    var handsSorted = hands.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    int winnings = 0;
    List<String> sortedHands = handsSorted.map((e) => e.key).toList();
    for (int i = 1; i <= sortedHands.length; i++) {
        String hand = sortedHands[i-1];
        int bid = cards[hand]!;
        int flippedI = sortedHands.length - (i-1);
        int value = flippedI * bid;
        winnings += value;
    }
    print('Hands: $handsSorted');
    print('Winnings: $winnings');
}
