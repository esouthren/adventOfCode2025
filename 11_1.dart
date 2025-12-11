import 'dart:io';

Future<void> main() async {
  final f = File('11_input.txt');
//   final f = File('11_test.txt');

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

  int pathsCount = 0;
  pathsCount = findPaths('you', routes);

  print('pathsCount: $pathsCount');
}

int findPaths(String start, Map<String, List<String>> routes) {
    print('finding paths');
  if (start == 'out') {
    return 1;
  }
  int paths = 0;
  for (var route in routes[start]!) {
    paths += findPaths(route, routes);
  }
  return paths;
}