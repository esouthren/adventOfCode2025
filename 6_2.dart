import 'dart:io';
import 'dart:math';

Future<void> main() async {
  // final f = File('6_1_test.txt');
  final f = File('6_1_input.txt');

  final lines = await f.readAsLines();
  int total = 0;

  final wp = RegExp(r"\s+");
  // Iterate each column; if all column elements are '', it's a problem split.
  // from there, can pad each number with 'x' where needed.

  var rawLines = [];

  for (var line in lines) {
    if (line[0] != '+' && line[0] != '*') {
      rawLines.add(line);
    } else {
      // Handle operator line
      line = line.trim().replaceAll(wp, ' ');
      final spl = line.split(' ');
      rawLines.add(spl);
    }
  }

  // print(rawLines);
  final operatorRow = rawLines.length - 1;
  var parsedNums = [];
  var problemIndex = 0;
  for (int row = 0; row < operatorRow; row++) {
    parsedNums.add(['']);
  }

  for (int c = 0; c < rawLines[0].length; c++) {
    List<String> colVals = [];
    for (int r = 0; r < operatorRow; r++) {
      colVals.add(rawLines[r][c]);
    }
    if (colVals.toSet().length == 1 && colVals[0] == ' ') {
      problemIndex += 1;
    } else {
      for (int row = 0; row < operatorRow; row++) {
        if (parsedNums[row].length <= problemIndex) {
          parsedNums[row].add('');
        }
        if (colVals[row] == ' ') {
          parsedNums[row][problemIndex] = parsedNums[row][problemIndex] + 'x';
        } else {
          parsedNums[row][problemIndex] =
              parsedNums[row][problemIndex] + colVals[row];
        }
      }
    }
  }

  // Now that we have the formatted numbers, do the calculation.
  for (int i = 0; i < parsedNums[0].length; i++) {
    final operation = rawLines[operatorRow][i];
    var result = 0;
    var colNums = [];
    for (int r = 0; r < parsedNums.length; r++) {
      final item = parsedNums[r][i];
      colNums.add(item);
    }
    // Calculate sum of each column of numbers
    // print(largestLength);
    var verticalParsed = [];
    // Loop over indices and construct numbers from valid column items
    for (int i = 0; i < colNums[0].length; i++) {
      var tmp = '';
      // Iterate each column number
      for (int r = 0; r < colNums.length; r++) {
        final curr = colNums[r];
        if (curr[i] != 'x') {
          tmp = tmp + curr[i];
        }
      }
      if (tmp.isNotEmpty) {
        verticalParsed.add(int.parse(tmp));
      }
    }
    result = 0;
    for (int r = 0; r < verticalParsed.length; r++) {
      if (operation == '+') {
        result = result + verticalParsed[r] as int;
      } else {
        if (r == 0) {
          result = verticalParsed[r] as int;
        } else {
          result = result * verticalParsed[r] as int;
        }
      }
    }
    total += result;
  }

  print(total);
}
