import 'dart:io';

Future<void> main() async {
  int count = 0;
  int curr = 50;
  var f = File('1_1_input.txt');
  final lines = await f.readAsLines();
  for (final l in lines) {
    final dir = l.substring(0,1);
    final ticks = int.parse(l.substring(1));

    if (dir == 'L') {
      curr = curr - ticks;
    } else {
      curr = curr + ticks;
    }
    // normalize
    curr = curr % 100;
    if (curr == 0) {
      count = count +1;
    }

    print('${dir} turn by ${ticks}, to ${curr}');


  }

  print(count);
  
  

}



