import 'dart:io';
import 'dart:math';

Future<void> main() async {
  int count = 0;
  var f = File('3_1_input.txt');
  final lines = await f.readAsLines();
  for (final l in lines) {
    count += joltage(l);
  }

  print(count);
}

int joltage(String input) {
  // print('examining $input');
  int l = 0;
  int r = 1;
  int currMax = 0;
  while (r < input.length) {
    // print('currMax: $currMax, l: $l, r: $r');
    int newCount = int.parse('${input[l]}${input[r]}');
    currMax = max(currMax, newCount);
    if (int.parse(input[r]) > int.parse(input[l])) {
      l = r;
      r += 1;
    } else {
      r += 1;
    }
  }

  print('row joltage: $currMax');
  return currMax;
}
