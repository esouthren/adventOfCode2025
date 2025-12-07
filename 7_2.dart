import 'dart:io';

Future<void> main() async {
  final f = File('7_input.txt');
  // final f = File('7_test.txt');

  final lines = await f.readAsLines();
  List<List<String>> grid = [];
  for (var line in lines) {
    grid.add(line.split(''));
  }

  // Take 2: stop making so many grid copies
  Map<int, int> beamCounts = {};

  for (int r = 0; r < grid.length; r++) {
    Map<int, int> newBeamCounts = {};

    for (int i = 0; i < grid[r].length; i++) {
      // Find start position
      if (grid[r][i] == 'S') {
        newBeamCounts[i] = 1;
      }
      // Handle splitters
      else if (grid[r][i] == '^' && beamCounts.containsKey(i)) {
        int count = beamCounts[i]!;
        // Each beam splits into left and right
        newBeamCounts[i - 1] = (newBeamCounts[i - 1] ?? 0) + count;
        newBeamCounts[i + 1] = (newBeamCounts[i + 1] ?? 0) + count;
        // Remove the beams that hit the splitter (they've been redirected)
        beamCounts.remove(i);
      }
    }

    // Beams that didn't hit splitters continue straight down
    for (var entry in beamCounts.entries) {
      newBeamCounts[entry.key] = (newBeamCounts[entry.key] ?? 0) + entry.value;
    }

    beamCounts = newBeamCounts;
  }

  // Sum all beam counts = total timelines
  int timelines = beamCounts.values.fold(0, (sum, count) => sum + count);
  print('timelines: $timelines');
}
