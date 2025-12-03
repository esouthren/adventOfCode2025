import 'dart:io';

Future<void> main() async {
  int count = 0;
  var f = File('2_1_input.txt');
  final content = await f.readAsString();
  final ranges = content.split(',');
  for (final r in ranges) {
    final parts = r.split('-');
    for (var i = int.parse(parts[0]); i <= int.parse(parts[1]); i++) {
      if (!isValid(i)) {
        count = count + i;
      }
    }
  }

  print(count);
}

bool isValid(int n) {
  final str = n.toString();
  if (str.length % 2 != 0) {
    return true;
  }
  final m = str.length / 2;
  for (int i = 0; i < m; i++) {
    if (str[i] != str[m.toInt() + i]) {
      return true;
    }
  }
  // print('$n is invalid, returning');
  return false;
}
