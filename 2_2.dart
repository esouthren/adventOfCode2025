import 'dart:io';

Future<void> main() async {
  int count = 0;
  var f = File('2_1_input.txt');
  final content = await f.readAsString();
  final ranges = content.split(',');
  for (final r in ranges) {
    final parts = r.split('-');
    for (var i = int.parse(parts[0]); i <= int.parse(parts[1]); i++) {
      print('\nchecking $i');
      if (!isValid(i)) {
        count = count + i;
      }
    }
  }

  // print(isValid(1188511880));

  print(count);
}

bool isValid(int n) {
  if (n < 10) {
    return true;
  }
  final str = n.toString();

  for (int window = 1; window < str.length; window++) {
    if (str.length % window != 0) {
      continue;
    }

    String? baseWindowValue = null;
    List<int> dSum = [];

    for (int startOfWindow = 0;
        startOfWindow < str.length - window + 1;
        startOfWindow += window) {
      // Handle windowsize 1 specifically
      if (window == 1) {
        if (baseWindowValue == null) {
          baseWindowValue = str[startOfWindow];
        }
        dSum.add(int.parse(str[startOfWindow]));
      } else {
        if (window > 1 && window != str.length) {
          final w = str.substring(startOfWindow, startOfWindow + window);

          if (baseWindowValue == null) {
            baseWindowValue = w;
          }
          dSum.add(int.parse(w));
        }
      }
    }
    print('dSum: $dSum');
    if (dSum.toSet().length == 1) {
      print('reached end of window with all matches; returning false for $n');
      return false;
    }
  }
  return true;
}
