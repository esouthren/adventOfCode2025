import 'dart:io';
import 'dart:math';

Future<void> main() async {
  final f = File('7_input.txt');
  // final f = File('7_test.txt');

  List<List<String>> grid = [];
  int splitterCount = 0;

  final lines = await f.readAsLines();
  for (var line in lines) {
    var tmpLine = <String>[];
    for (var c = 0; c < line.length; c++) {
      tmpLine.add(line[c]);
    }
    grid.add(tmpLine);
  }

  for (int r = 0; r < grid.length; r++) {
    for (int i = 0; i < grid[r].length; i++) {
      // find S
      if (grid[r][i] == 'S') {
        grid[r + 1][i] = '|';
      }
      // find splitters
      if (grid[r][i] == '^' && grid[r - 1][i] == '|') {
        grid[r][i - 1] = '|';
        grid[r][i + 1] = '|';
        splitterCount += 1;
      }
      // Handle '.'
      else if (grid[r][i] == '.') {
        if (r > 0) {
          if (grid[r - 1][i] == '|') {
            grid[r][i] = '|';
          }
        }
      }
    }
  }

  print('splitterCount: $splitterCount');
}
