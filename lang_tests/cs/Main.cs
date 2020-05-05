using System;
using dropecho.interop;
using bsp = dropecho.dungen.bsp;
using ca = dropecho.dungen.ca;
using map = dropecho.dungen.map;

public class ExtenderTest {
  static int Main(string[] args) {

    var bspGen = new bsp.Generator(new { width = 64, height = 32 });
    var bsp = bspGen.generate();

    Console.WriteLine(bspGen.width);
    Console.WriteLine(bspGen.height);

    var bspMap = map.generators.RoomGenerator.buildRooms(bsp, null);

    Console.WriteLine(bspMap._width);
    Console.WriteLine(bspMap._height);
    Console.Write(bspMap.toString());


    var caMap = ca.Generator.generate(new { width = 64, height = 32 });

    Console.WriteLine(caMap._width);
    Console.WriteLine(caMap._height);

    Console.Write(caMap.toString());

    return 0;
  }
}
