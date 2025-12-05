import 'dart:io';
import 'dart:math';

Future<void> main() async {

  final f = File('5_1_input.txt');
  final lines = await f.readAsLines();

  final ranges = <(int, int)>[];
  for (final line in lines) {
    if (line.contains('-')) {
      final parts = line.split('-');
      final start = int.parse(parts[0]);
      final end = int.parse(parts[1]);
      ranges.add((start, end));
    } else if (line.trim().isEmpty) {
      // Blank line: end of the range section.
      break;
    }
  }

  // Sort ranges by start.
  ranges.sort((a, b) => a.$1.compareTo(b.$1));

  // Merge overlapping ranges.
  final merged = <(int, int)>[];
  var (currentStart, currentEnd) = ranges.first;

  for (var i = 1; i < ranges.length; i++) {
    final (start, end) = ranges[i];
    if (start > currentEnd) {
      // No overlap: close out previous range.
      merged.add((currentStart, currentEnd));
      currentStart = start;
      currentEnd = end;
    } else {
      // Overlap: extend current range.
      currentEnd = max(currentEnd, end);
    }
  }

  // Add the final merged range.
  merged.add((currentStart, currentEnd));

  var diffCount = 0;
  for (final (start, end) in merged) {
    diffCount += (end - start + 1);
  }

  print('diffCount: $diffCount');
}
