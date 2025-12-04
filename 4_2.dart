import 'dart:io';

Future<void> main() async {
  int count = 0;
  // var f = File('4_1_test.txt');
  var f = File('4_1_input.txt');

  final lines = await f.readAsLines();

  // Create 2D Grid
  List<List<String>> grid = [];
  for (int x = 0; x < lines.length; x++) {
    List<String> line = [];
    for (int y = 0; y < lines[x].length; y++) {
      line.add(lines[x][y]);
    }
    grid.add(line);
  }

  bool hasMoreRolls = true;
  int neighbourCount({
    required int x,
    required int y,
    required int maxX,
    required int maxY,
  }) {
    // Define Neighbours
    final neighbours = [
      [-1, -1],
      [0, -1],
      [1, -1],
      [-1, 0],
      [1, 0],
      [1, 1],
      [-1, 1],
      [0, 1]
    ];

    int count = 0;
    neighbours.forEach((n) {
      final newG = [y + n[0], x + n[1]];
      if (newG[0] >= 0 && newG[0] < maxY && newG[1] >= 0 && newG[1] < maxY) {
        // print('$newG : ${grid[newG[0]][newG[1]]}');

        // Valid neighbour, check
        if (grid[newG[0]][newG[1]] == '@') {
          count += 1;
        }
      }
    });
    return count;
  }

  int totalCount = 0;

  // Iterate and check neighbours while we still can
  while (hasMoreRolls) {
    List<List<String>> newGrid = grid;
    count = 0;

    for (int y = 0; y < grid.length; y++) {
      for (int x = 0; x < grid[y].length; x++) {
        if (grid[y][x] == '@') {
          final n = neighbourCount(
            x: x,
            y: y,
            maxX: grid.length,
            maxY: grid[0].length,
          );
          if (n < 4) {
            newGrid[y][x] = '.';
            count += 1;
          }
        }
      }
    }
    print('count of this window: $count');
    totalCount += count;
    if (count == 0) {
      hasMoreRolls = false;
    }
  }

  print(totalCount);
}
