import 'dart:io';

Future<void> main() async {
  int count = 0;
  int curr = 50;
  var f = File('1_1_input.txt');
  final lines = await f.readAsLines();
  for (final l in lines) {
    final dir = l.substring(0, 1);
    final ticks = int.parse(l.substring(1));

    if (dir == 'L') {
      for (int i = 0; i < ticks; i++) {
        if (curr == 0) {
          curr = 99;
        } else {
          curr = curr - 1;
        }
        if (curr == 0) {
          count += 1;
        }
      }
    } else {
      for (int i = 0; i < ticks; i++) {
        if (curr == 99) {
          curr = 0;
        } else {
          curr += 1;
        }
        if (curr == 0) {
          count += 1;
        }
      }
    }

    print('${dir} turn by ${ticks}, to ${curr}, count $count');
  }

  print(count);
}
