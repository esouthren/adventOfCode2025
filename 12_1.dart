import 'dart:io';
import 'dart:math';

Future<void> main() async {
  // final f = File('12_test.txt');
  final f = File('12_input.txt');

  final lines = await f.readAsLines();
  List<Region> regions = [];
  List<Present> presents = [];

  for (int p = 0; p < 6; p++) {
    final start = p * 5 + 1;
    List<List<String>> pres = [];
    var c = 0;
    for (int r = 0; r < 3; r++) {
      final l = lines[start + r].split('');
      for (final char in l) {
        if (char == '#') c += 1;
      }
      pres.add(l);
    }
    presents.add(Present(pres, c));
  }

  for (int p = 30; p < lines.length; p++) {
    final spl = lines[p].split(' ');
    final size = spl[0].substring(0, spl[0].length - 1);
    print(size);
    final splSize = size.split('x');
    List<int> presents = [];
    for (int i = 1; i < spl.length; i++) {
      presents.add(int.parse(spl[i]));
    }
    regions.add(Region(int.parse(splSize[0]), int.parse(splSize[1]), presents));
  }

  int canFitCount = 0;
  // how many of the regions can successfully fit their gifts?

  for (int r = 0; r < regions.length; r++) {
    final currR = regions[r];

    // First check if there is a valid amount of space - a quick knockout
    // before searching properly.
    final gridSize = currR.height * currR.width;
    int pSize = 0;
    for (int p = 0; p < currR.presents.length; p++) {
      pSize += currR.presents[p] * presents[p].count;
    }
    if (pSize > gridSize) {
      print(
        '${currR.height}x${currR.width} FAIL (insufficient space)',
      );
      continue;
    }

    // Search gridspace and see if presents can fit in grid. Presents can
    // be rotated or flipped.
    final ok = canFitRegion(currR, presents);
    if (ok) {
      canFitCount++;
      print('${currR.height}x${currR.width} OK');
    } else {
      print('${currR.height}x${currR.width} FAIL (packing)');
    }
  }

  print('\n\ncan fit: $canFitCount');
}

bool canFitRegion(Region region, List<Present> presentsRaw) {
  final H = region.height;
  final W = region.width;

  // Build normalized shapes and their unique rotations+mirrors
  final shapes = <Shape>[];
  final variantsByType = <int, List<Shape>>{};
  for (int i = 0; i < presentsRaw.length; i++) {
    final shape = shapeFrom3x3(presentsRaw[i].grid);
    shapes.add(shape);
    variantsByType[i] = uniqueRotationsAndMirrors(shape);
  }

  // Extra quick check: if any required type has no placements at all, fail
  final placementsByType = <int, List<Placement>>{};
  for (int i = 0; i < region.presents.length; i++) {
    if (region.presents[i] == 0) continue;

    final placements = generatePlacementsForType(i, variantsByType[i]!, H, W);
    if (placements.isEmpty) return false;
    placementsByType[i] = placements;
  }

  // Remaining counts to place
  final remaining = List<int>.from(region.presents);

  bool dfs(BigInt occ) {
    // Choose next type to place (heuristic: fewest placements)
    int nextType = -1;
    int best = 1 << 30;

    for (int i = 0; i < remaining.length; i++) {
      if (remaining[i] <= 0) continue;
      final n = placementsByType[i]!.length;
      if (n < best) {
        best = n;
        nextType = i;
      }
    }

    // All placed
    if (nextType == -1) return true;

    // Try all non-overlapping placements
    for (final pl in placementsByType[nextType]!) {
      if ((pl.mask & occ) != BigInt.zero) continue;
      remaining[nextType]--;
      if (dfs(occ | pl.mask)) return true;
      remaining[nextType]++;
    }
    return false;
  }

  return dfs(BigInt.zero);
}

class Placement {
  final int type;
  final BigInt mask;
  Placement(this.type, this.mask);
}

BigInt bit(int idx) => (BigInt.one << idx);

List<Placement> generatePlacementsForType(
  int type,
  List<Shape> variants,
  int H,
  int W,
) {
  final placements = <Placement>[];

  for (final shape in variants) {
    final maxX = shape.cells.map((p) => p.x).reduce(max);
    final maxY = shape.cells.map((p) => p.y).reduce(max);

    for (int oy = 0; oy + maxY < H; oy++) {
      for (int ox = 0; ox + maxX < W; ox++) {
        BigInt m = BigInt.zero;
        for (final c in shape.cells) {
          final x = ox + c.x;
          final y = oy + c.y;
          m |= bit(y * W + x);
        }
        placements.add(Placement(type, m));
      }
    }
  }

  return placements;
}

class Shape {
  final List<Point<int>> cells; // filled cells relative to (0,0)
  Shape(this.cells);

  Shape normalize() {
    int minX = cells.map((p) => p.x).reduce(min);
    int minY = cells.map((p) => p.y).reduce(min);

    final norm = cells.map((p) => Point(p.x - minX, p.y - minY)).toList();
    norm.sort((a, b) => (a.y == b.y) ? a.x - b.x : a.y - b.y);
    return Shape(norm);
  }

  // (x,y) -> (y, -x) then normalize
  Shape rotate90() {
    final rotated = cells.map((p) => Point(p.y, -p.x)).toList();
    return Shape(rotated).normalize();
  }

  // Mirror across vertical axis: (x,y) -> (-x, y) then normalize
  Shape mirrorX() {
    final flipped = cells.map((p) => Point(-p.x, p.y)).toList();
    return Shape(flipped).normalize();
  }

  String signature() => cells.map((p) => '${p.x},${p.y}').join(';');
}

Shape shapeFrom3x3(List<List<String>> grid) {
  final cells = <Point<int>>[];
  for (int y = 0; y < grid.length; y++) {
    for (int x = 0; x < grid[y].length; x++) {
      if (grid[y][x] == '#') cells.add(Point(x, y));
    }
  }
  return Shape(cells).normalize();
}

List<Shape> uniqueRotationsAndMirrors(Shape s) {
  final seen = <String>{};
  final out = <Shape>[];

  void addAll(Shape base) {
    var curr = base.normalize();
    for (int i = 0; i < 4; i++) {
      final sig = curr.signature();
      if (seen.add(sig)) out.add(curr);
      curr = curr.rotate90();
    }
  }

  addAll(s);
  addAll(s.mirrorX());

  return out;
}

class Region {
  int height;
  int width;
  // index equals index of presents, number is # of presents required to satisfy
  List<int> presents;

  Region(this.height, this.width, this.presents);
}

class Present {
  List<List<String>> grid;
  // How many squares this consumes
  int count;

  Present(this.grid, this.count);
}
