import 'dart:io';

Future<void> main() async {
  int count = 0;
  var f = File('3_1_input.txt');
  final lines = await f.readAsLines();
  for (final l in lines) {
    final x = joltage(l);
    count += x;
  }
  print(count);

  // final testA = joltage('987654321111111');
  // final testB= joltage('811111111111119');
  // final testC = joltage('234234234234278');
  // final testD = joltage('818181911112111');

  // print('987654321111111 = 987654321111 ? ${testA == 987654321111} / $testA');
  // print('811111111111119 = 811111111119 ? ${testB == 811111111119} / $testB');
  // print('234234234234278 = 434234234278 ? ${testC == 434234234278} / $testC');
  // print('818181911112111 = 888911112111 ? ${testD == 888911112111} / $testD');
}

int joltage(String input) {
  String output = input[0];

  int r = 1;
  int maxNums = 12;
  while (r < input.length) {
    final l = output.length;
    bool foundMatch = false;

    for (int c = 0; c < l; c++) {
      final spaceRequired = maxNums - c - 1;
      final availableSpace = input.length - r - 1;

      if (int.parse(input[r]) > int.parse(output[c])) {
        // if remainder - c leaves gap
        print('space required: $spaceRequired');
        print('available space: $availableSpace');
        if (spaceRequired <= availableSpace) {
          foundMatch = true;

          output = output.substring(0, c) + input[r];
          print('new output substring: $output, breaking');

          // r += 1;
          break;
        }
      }
    }
    if (output.length < 12 && !foundMatch) {
      print('no char match found, adding ${input[r]} to end of output');
      output = output + input[r];
    }
    r += 1;

    print(
        'new output $output / remaining: ${maxNums - r + 1} / r: $r / len ${output.length}');
  }

  // Add remaining letters, if any
  if (output.length < 12) {
    final remainder = input.substring(r);
    output = '$output$remainder';
  }

  return int.parse(output);
}
