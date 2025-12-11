import 'dart:io';

Future<void> main() async {
  // final f = File('11_2_test.txt');
  final f = File('11_input.txt');
  Map<String, List<String>> routes = {};

  final lines = await f.readAsLines();
  for (var line in lines) {
    if (line.isEmpty) {
      break;
    }
    final spl = line.split(' ');
    final a = spl[0].substring(0, spl[0].length - 1);
    for (int i = 1; i < spl.length; i++) {
      if (routes.containsKey(a)) {
        routes[a]!.add(spl[i]);
      } else {
        routes[a] = [spl[i]];
      }
    }
  }

  int count = countPaths(routes, 'svr', false, false);
  print('count: $count');
}

Map<String, int> memo = {};

int countPaths(
  Map<String, List<String>> routes,
  String node,
  bool dacVisited,
  bool fftVisited,
) {
  if (node == 'dac') {
    dacVisited = true;
  }
  if (node == 'fft') {
    fftVisited = true;
  }

  if (node == 'out' && (dacVisited && fftVisited)) return 1;

  String key = '$node|$dacVisited|$fftVisited';
  if (memo.containsKey(key)) return memo[key]!;

  int total = 0;
  if (routes.containsKey(node)) {
    for (var neighbor in routes[node]!) {
      total += countPaths(routes, neighbor, dacVisited, fftVisited);
    }
  }

  memo[key] = total;
  return total;
}
