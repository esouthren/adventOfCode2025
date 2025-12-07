import 'dart:io';

Future<void> main() async {
  final f = File('6_1_input.txt');
  // final f = File('6_1_test.txt');

  final lines = await f.readAsLines();
  int total = 0;

  final wp = RegExp(r"\s+");
  int r = 0;
  var parsed = [];
  for (var line in lines) {
    line = line.trim().replaceAll(wp, ' ');
    final spl = line.split(' ');

    if (spl.isNotEmpty) {
      parsed.add(spl);
    }
  }

  print(parsed);

  final operatorRow = parsed.length - 1;
  for (int i = 0; i < parsed[0].length; i++) {
    final operation = parsed[operatorRow][i];
    print(operation);
    var result = 0;
    for (int r = 0; r < parsed.length - 1; r++) {
      // print(int.parse(parsed[r][i]));
      if (operation == '+') {
        result = result + int.parse(parsed[r][i]);
      } else {
        if (r == 0) {
          result = int.parse(parsed[r][i]);
        } else {
          result = result * int.parse(parsed[r][i]);
        }
      }
    }
    // print('r: $result');
    total += result;
  }

  print(total);
}
