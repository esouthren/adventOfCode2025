import 'dart:collection';
import 'dart:io';
import 'dart:math';

/// BFS, keep track of depth, keep track of depth
///
/// New goal: joltage match
/// button presses update joltage counts
/// e.g joltage {0,0,0,0} (start), press (1,3) = {0,1,0,1}

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

    // Get joltage
    final rawJolts = spl[spl.length - 1];
    List<int> joltages = [];
    final j = rawJolts.substring(1, rawJolts.length - 1).split(',');
    j.forEach((a) => joltages.add(int.parse(a)));
    // print(joltages);
    final start = List.generate(joltages.length, (u) => 0);

    List<List<int>> pushes = [];
    // Get list of buttons 'pushes'
    for (var i = 1; i < spl.length - 1; i++) {
      final b = spl[i].substring(1, spl[i].length - 1).split(',');
      List<int> nums = [];
      b.forEach((a) => nums.add(int.parse(a)));
      pushes.add(nums);
    }

    final count = solveMinPresses(
      // start: start,
      goal: joltages,
      pushes: pushes,
    );
    print('count for this row: $count, goal $joltages');
    totalCount += count;
  }
  print('\n>> $totalCount');
}

int solveMinPresses({
  required List<int> goal,
  required List<List<int>> pushes, // each push is a list of indices it affects
}) {
  final m = pushes.length;
  final n = goal.length;

  // Remaining required jolts per counter
  final remaining = List<int>.from(goal);

  int? best; // best (minimal) total number of presses found so far

  // memo[(buttonIndex, remaining)] = smallest pressesSoFar we've seen there
  final Map<String, int> memo = {};

  String encodeState(int buttonIndex, List<int> remaining) {
    // 10 counters → string join is fine
    return '$buttonIndex:${remaining.join(",")}';
  }

  void dfs(int buttonIndex, int pressesSoFar) {
    // ---------- lower bound on future presses ----------
    int maxRem = 0;
    for (int i = 0; i < n; i++) {
      if (remaining[i] > maxRem) maxRem = remaining[i];
    }

    // If we already have a solution and even the *best possible*
    // continuation can't beat it, prune.
    if (best != null && pressesSoFar + maxRem >= best!) {
      return;
    }

    // ---------- early success / fail ----------
    if (maxRem == 0) {
      // All counters satisfied
      if (best == null || pressesSoFar < best!) {
        best = pressesSoFar;
      }
      return;
    }

    if (buttonIndex == m) {
      // No buttons left but still some remaining > 0
      return;
    }

    // ---------- memoisation ----------
    final key = encodeState(buttonIndex, remaining);
    final prev = memo[key];
    if (prev != null && prev <= pressesSoFar) {
      // We've been here before with equal or fewer presses → no need to continue
      return;
    }
    memo[key] = pressesSoFar;

    // ---------- explore this button ----------
    final affected = pushes[buttonIndex];
    if (affected.isEmpty) {
      // This button does nothing; skip
      dfs(buttonIndex + 1, pressesSoFar);
      return;
    }

    // Maximum times we can press this button without making any remaining < 0
    int maxPress = remaining[affected[0]];
    for (final idx in affected) {
      if (remaining[idx] < maxPress) {
        maxPress = remaining[idx];
      }
    }

    // Try pressing this button c times, from 0 up to maxPress.
    // Try small counts first so we find small solutions quickly.
    for (int c = 0; c <= maxPress; c++) {
      final newPresses = pressesSoFar + c;
      if (best != null && newPresses >= best!) {
        break; // can't beat best even if c grows further
      }

      // Apply c presses
      if (c > 0) {
        for (final idx in affected) {
          remaining[idx] -= c;
        }
      }

      dfs(buttonIndex + 1, newPresses);

      // Undo c presses
      if (c > 0) {
        for (final idx in affected) {
          remaining[idx] += c;
        }
      }
    }
  }

  dfs(0, 0);

  return best ?? -1; // -1 if no solution (shouldn't happen per your problem)
}