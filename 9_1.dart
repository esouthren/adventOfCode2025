import 'dart:io';
import 'dart:math';

Future<void> main() async {
  // final f = File('9_test.txt');

  final f = File('9_input.txt');

  List<Point> points = [];

  final lines = await f.readAsLines();
  for (var line in lines) {
    final spl = line.split(',');
    points.add(Point(int.parse(spl[0]), int.parse(spl[1])));
  }

  int maxSize = 0;

  for (int a = 0; a < points.length; a++) {
    for (int b = a; b < points.length - 1; b++) {
      final dx = (points[b].x - points[a].x).abs() + 1;
      final dy = (points[b].y - points[a].y).abs() + 1;
      final size = (dx * dy).abs();
      print(
        '${points[a].toString()}-${points[b].toString()}, dx: $dx, dy: $dy, size: $size',
      );
      maxSize = max(maxSize, size);
    }
  }
  print('>');
  print(maxSize);
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  String toString() => '($x,$y)';
}
