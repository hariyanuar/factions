import 'dart:io';
import 'dart:collection';

void main(List<String> arguments) {
  final String contents = File(
          '/Users/hariyanuar/Developer/Dart/Generasi Gigih/factions/bin/input.in')
      .readAsStringSync();
  final rawInputs = contents.split('\n');
  final int testCasesLength = int.parse(rawInputs[0]);

  int inputsIndex = 1;
  for (int i = 0; i < testCasesLength; i++) {
    final List<dynamic> input;

    if (i == 0) {
      final firstDataLength = int.parse(rawInputs[inputsIndex]) + 2;
      input = List.generate(
        firstDataLength,
        (index) {
          return rawInputs[index + 1];
        },
      );
      inputsIndex += firstDataLength;
    } else {
      final dataLength = int.parse(rawInputs[inputsIndex]) + 2;
      input = List.generate(
        dataLength,
        (index) {
          return rawInputs[inputsIndex + index];
        },
      );
    }

    final verticalLength = int.parse(input[0]);
    final horizontalLength = int.parse(input[1]);
    final List<String> map =
        input.skip(2).toList().map((e) => e.toString()).toList();
    final List<List<bool>> visited = List.generate(verticalLength,
        (index) => List.generate(horizontalLength, (index) => false));
    final Set<String> factions = <String>{};
    final SplayTreeMap<String, int> armies = SplayTreeMap<String, int>();

    void findAndContest(int x, int y) {
      //stdout.writeln('SCANNING X: $x Y: $y');

      if (y < 0 || y >= verticalLength) {
        // make sure not not exceed the limit
        return;
      }
      if (x < 0 || x >= horizontalLength) {
        // make sure not not exceed the limit
        return;
      }
      if (visited[y][x]) {
        // ignore it when already visited
        return;
      }
      visited[y][x] = true; // set true when the maps is already visited
      if (map[y][x] == "#") {
        // ignore #
        return;
      }
      if (!(map[y][x] == ".")) {
        // add fraction to the Set tempFraction
        stdout.writeln('FOUND ARMY FACTION ${map[y][x]} on X: $x and Y: $y');
        factions.add(map[y][x]);
      }

      findAndContest(y, x + 1); // move direction right
      findAndContest(y, x - 1); // move direction left
      findAndContest(y + 1, x); // move direction up
      findAndContest(y - 1, x); // move direction down
      return;
    }

    int contest = 0;

    for (int y = 0; y < verticalLength; y++) {
      for (int x = 0; x < horizontalLength; x++) {
        // stdout.writeln('START SCANNING AT X: $x AND Y: $y');
        factions.clear();
        findAndContest(x, y);
        if (factions.length > 0)
          stdout.writeln('FOUND ARMIES : ${factions.join(',')}');
        if (factions.length > 1) {
          // stdout.writeln('CONTEST FOUND WITH FACTIONS ${factions.join(', ')}');
          contest++;
        } else {
          for (var element in factions) {
            String army = element;
            if ((armies.containsKey(army))) {
              armies[army] = armies[army]! + 1;
            } else {
              armies.addAll({army: 1});
            }
          }
        }
      }
    }

    stdout.writeln('Case $i:');
    stdout.writeln('contested $contest');
    armies.forEach((key, value) => stdout.writeln('$key $value'));
  }
}
