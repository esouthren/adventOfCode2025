import 'dart:io';
import 'dart:math';

Future<void> main() async {
  // final f = File('9_test.txt');
  final f = File('9_input.txt');

  List<Point> points = [];

  final lines = await f.readAsLines();
  for (var line in lines) {
    if (line.isEmpty) {
      break;
    }
    final spl = line.split(',');
    points.add(Point(int.parse(spl[0]), int.parse(spl[1])));
  }

  int maxSize = 0;

  for (int a = 0; a < points.length; a++) {
    for (int b = a; b < points.length; b++) {
      if (!points[a].equals(points[b])) {
        // Need to check validity of square
        // It's valid if all 4 corners are within the boundaries

        final x = (points[b].x - points[a].x).abs() + 1;
        final y = (points[b].y - points[a].y).abs() + 1;

        if (rectangleFullyInside(points[a], points[b], points)) {
          final size = (x * y).abs();
          if (size > maxSize) {
            print(
              'new max $size at ${points[a].toString()}-${points[b].toString()}',
            );
          }
          maxSize = max(maxSize, size);
        }
      }
    }
  }
  print('>');
  print(maxSize);
}

// ray-cast algo on points: cast a 'ray', count how many times it crossed shape
// edges. odd == inside, even == outside.

bool _pointOnSegment(Point p, Point a, Point b, {double eps = 1e-9}) {
  // Collinearity via cross product
  final cross = (p.x - a.x) * (b.y - a.y) - (p.y - a.y) * (b.x - a.x);
  if (cross.abs() > eps) return false;

  // Inside bounding box via dot product
  final dot = (p.x - a.x) * (p.x - b.x) + (p.y - a.y) * (p.y - b.y);
  if (dot > eps) return false;

  return true;
}

bool _segmentsIntersect(Point p1, Point p2, Point p3, Point p4) {
  int cross(Point a, Point b, Point c) =>
      (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);

  final d1 = cross(p1, p2, p3);
  final d2 = cross(p1, p2, p4);
  final d3 = cross(p3, p4, p1);
  final d4 = cross(p3, p4, p2);

  // Proper intersection: segments cross each other in their interiors
  return (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) &&
      ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0)));
}

bool pointInPolygon(Point point, List<Point> polygon) {
  final int n = polygon.length;
  bool inside = false;

  final double px = point.x.toDouble();
  final double py = point.y.toDouble();

  for (int i = 0; i < n; i++) {
    final a = polygon[i];
    final b = polygon[(i + 1) % n];

    // 1) On boundary?
    if (_pointOnSegment(point, a, b)) return true;

    final double ax = a.x.toDouble();
    final double ay = a.y.toDouble();
    final double bx = b.x.toDouble();
    final double by = b.y.toDouble();

    // 2) Does edge (a,b) cross horizontal line y = py?
    final bool crosses = (ay > py) != (by > py);
    if (!crosses) continue;

    // 3) X coordinate where edge crosses y = py
    final double t = (py - ay) / (by - ay); // safe because crosses => by != ay
    final double xIntersect = ax + t * (bx - ax);

    // 4) Count crossing if it’s to the right of point
    if (px < xIntersect) {
      inside = !inside;
    }
  }

  return inside;
}

bool rectangleFullyInside(Point pA, Point pB, List<Point> polygon) {
  // Build all 4 corners of the axis-aligned rectangle
  final left = min(pA.x, pB.x);
  final right = max(pA.x, pB.x);
  final bottom = min(pA.y, pB.y);
  final top = max(pA.y, pB.y);

  final c1 = Point(left, bottom);
  final c2 = Point(right, bottom);
  final c3 = Point(right, top);
  final c4 = Point(left, top);

  final corners = [c1, c2, c3, c4];

  // 1) All corners must be inside or on boundary
  for (final c in corners) {
    if (!pointInPolygon(c, polygon)) return false;
  }

  // 2) Rectangle edges must not cross any polygon edge
  final rectEdges = [
    [c1, c2],
    [c2, c3],
    [c3, c4],
    [c4, c1],
  ];

  for (final edge in rectEdges) {
    final r1 = edge[0];
    final r2 = edge[1];

    for (int i = 0; i < polygon.length; i++) {
      final p1 = polygon[i];
      final p2 = polygon[(i + 1) % polygon.length];

      // Allow touching at shared vertices
      if (r1.equals(p1) || r1.equals(p2) || r2.equals(p1) || r2.equals(p2)) {
        continue;
      }

      if (_segmentsIntersect(r1, r2, p1, p2)) {
        return false; // crosses boundary -> invalid rectangle
      }
    }
  }

  return true;
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  String toString() => '($x,$y)';

  bool equals(Point b) => b.x == x && b.y == y;
}
