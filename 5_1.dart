import 'dart:io';
import 'dart:math';

Future<void> main() async {
  int count = 0;
  // var f = File('5_1_test.txt');
  var f = File('5_1_input.txt');

  Map<int, int> freshIds = {};
  List<int> idsToCheck = [];

  final lines = await f.readAsLines();
  for (final l in lines) {
    // Parse ranges to map
    // Maintain ordered list of starts
    if (l.contains('-')) {
      final rangeVals = l.split('-');
      final s = int.parse(rangeVals[0]);
      final e = int.parse(rangeVals[1]);
      // ! check if start range already exists; if it does, maybe extend 
      // the range value with the larger max.
      if (freshIds.containsKey(s)) {
        freshIds[s] = max(freshIds[s]!, e);
      } else
      freshIds[s] = e;

      // Blank line; continue.
    } else if (l == "") {
      continue;
      // Add IDs to list
    } else {
      final id = int.parse(l);
      idsToCheck.add(id);
    }
  }

  idsToCheck.forEach((i) {
    for (final key in freshIds.keys) {
      if (i >= key && i <= (freshIds[key] as int)) {
        print('found $i in range $key-${freshIds[key]}');
        count += 1;
        break;
      }
    }
  });

  // Loop over Ids
  print('values: ${idsToCheck.length}');
  print('ranges: ${freshIds.length}');
  print('\nfresh count: $count');

  // Look up IDs and check in map
}
