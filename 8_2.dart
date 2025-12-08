import 'dart:io';
import 'dart:math';

Future<void> main() async {
  // final f = File('8_test.txt');

  final f = File('8_input.txt');

  List<List<Point>> circuits = [];

  final lines = await f.readAsLines();
  List<Point> points = [];
  for (var line in lines) {
    final l = line.split(',');
    points.add(Point(int.parse(l[0]), int.parse(l[1]), int.parse(l[2])));
  }

  List<PointDistance> distances = [];

  // Calculate differences
  for (int i = 0; i < points.length; i++) {
    for (int j = i + 1; j < points.length; j++) {
      final a = points[i];
      final b = points[j];
      final d = distance(a.x, a.y, a.z, b.x, b.y, b.z);
      distances.add(PointDistance(a, b, d));
    }
  }

  distances.sort((a, b) => a.distance.compareTo(b.distance));

  print(distances.length);

  int connections = 0;
  int i = 0;

  final goalCircuitSize = points.length;
  print(goalCircuitSize);

  while (i < distances.length) {
    final toCheck = distances[i];

    int? aCircuit;
    int? bCircuit;
    for (int c = 0; c < circuits.length; c++) {
      if (circuits[c].contains(toCheck.a)) {
        aCircuit = c;
      }
      if (circuits[c].contains(toCheck.b)) {
        bCircuit = c;
      }
    }
    if (aCircuit == null && bCircuit == null) {
      circuits.add([toCheck.a, toCheck.b]);
    } else if (aCircuit != null && bCircuit == null) {
      circuits[aCircuit].add(toCheck.b);
    } else if (bCircuit != null && aCircuit == null) {
      circuits[bCircuit].add(toCheck.a);
    } else if (aCircuit == bCircuit) {
    } else if (aCircuit != null && bCircuit != null) {
      circuits[aCircuit].addAll(circuits[bCircuit]);
      circuits.removeAt(bCircuit);
    }
    i++;
    connections += 1;
    if (circuits.length == 1 && circuits[0].length == goalCircuitSize) {
      print('done!');
      print('x: ${toCheck.a.x}, ${toCheck.b.x}');
      print(toCheck.a.x * toCheck.b.x);
      break;
    }
  }

  // // Calculate circuits
  // circuits.sort((a, b) => a.length.compareTo(b.length));
  // circuits = circuits.reversed.toList();
  // // circuits.forEach((c) => print('circuit: ${c.length}'));
  // final top3 = circuits.take(3);
  // int total = 1;
  // top3.forEach((t) {
  //   print(t.length);
  //   total *= t.length;
  // });
  // print(total);
}

double distance(int x1, int y1, int z1, int x2, int y2, int z2) {
  final dx = x2 - x1;
  final dy = y2 - y1;
  final dz = z2 - z1;
  final sum = (dx * dx) + (dy * dy) + (dz * dz);
  return sqrt(sum);
}

class Point {
  int x;
  int y;
  int z;

  Point(this.x, this.y, this.z);
}

class PointDistance {
  Point a;
  Point b;
  double distance;
  PointDistance(this.a, this.b, this.distance);

  String toString() =>
      '${a.x},${a.y},${a.z} / ${b.x},${b.y},${b.z} - $distance';
}
