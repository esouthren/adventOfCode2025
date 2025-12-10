import 'dart:collection';
import 'dart:io';

/// BFS, keep track of depth, keep track of depth
///
/// Analyze each machine's indicator light diagram and button
/// wiring schematics. What is the fewest button presses required to
/// correctly configure the indicator lights on all of the machines?

Future<void> main() async {
  final f = File('10_input.txt');
  // final f = File('10_test.txt');

  int totalCount = 0;

  final lines = await f.readAsLines();
  for (var line in lines) {
    if (line.isEmpty) {
      break;
    }
    final spl = line.split(' ');
    // Get goal
    final goal = spl[0].substring(1, spl[0].length - 1);
    final start = '.' * goal.length;

    List<List<int>> pushes = [];
    // Get list of buttons 'pushes'
    for (var i = 1; i < spl.length - 1; i++) {
      final b = spl[i].substring(1, spl[i].length - 1).split(',');
      List<int> nums = [];
      b.forEach((a) => nums.add(int.parse(a)));
      pushes.add(nums);
    }

    final count = shortestPathCount(start: start, goal: goal, pushes: pushes);
    print('count for this row: $count');
    totalCount += count;
  }
  print('\n>> $totalCount');
}

String flip(String origin, List<int> indices) {
  for (var i in indices) {
    if (origin[i] == '.') {
      origin = origin.replaceFirst(RegExp('.'), '#', i);
    } else {
      origin = origin.replaceFirst(RegExp('#'), '.', i);
    }
  }
  return origin;
}

int shortestPathCount({
  required String start,
  required String goal,
  required List<List<int>> pushes,
}) {
  final Queue q = Queue();
  final distance = {};

  q.add(start);
  distance[start] = 0;

  while (q.isNotEmpty) {
    final current = q.removeFirst();
    final dist = distance[current]!;

    

    // found match
    if (current == goal) {
      return dist;
    }

    for (final p in pushes) {
      final next = flip(current, p);
      if (!distance.containsKey((next))) {
        distance[next] = dist + 1;
        q.add(next);
      }
    }
  }
  // Shouldn't get here, as long as there is a path.
  return 0;
}
