using System;
using dropecho.interop;
// using bsp = dropecho.dungen.bsp;
// using ca = dropecho.dungen.ca;
using map = dropecho.dungen.map;
using dropecho.dungen.generators;

public class ExtenderTest {
  static int Main(string[] args) {

    var map = WalkGenerator.generate(new{width=32});

    Console.Write(map.toString(false));

   
    //
    // var bspGen = new bsp.Generator(new { width = 64, height = 32 });
    // var bsp = bspGen.generate();
    //
    // Console.WriteLine(bspGen.width);
    // Console.WriteLine(bspGen.height);
    //
    // var bspMap = map.generators.RoomGenerator.buildRooms(bsp, null);
    //
    // Console.WriteLine(bspMap._width);
    // Console.WriteLine(bspMap._height);
    // Console.Write(bspMap.toString());
    //
    //
    // var caMap = ca.Generator.generate(new { width = 64, height = 32 });
    //
    // Console.WriteLine(caMap._width);
    // Console.WriteLine(caMap._height);
    //
    // Console.Write(caMap.toString());
    // var sample = new map.Map2d(4, 4, 0);
    // sample.set(0, 0, 0);
    // sample.set(1, 0, 0);
    // sample.set(2, 0, 0);
    // sample.set(3, 0, 0);
    // sample.set(0, 1, 0);
    // sample.set(1, 1, 1);
    // sample.set(2, 1, 1);
    // sample.set(3, 1, 1);
    // sample.set(0, 2, 0);
    // sample.set(1, 2, 1);
    // sample.set(2, 2, 0);
    // sample.set(3, 2, 1);
    // sample.set(0, 3, 0);
    // sample.set(1, 3, 1);
    // sample.set(2, 3, 1);
    // sample.set(3, 3, 1);
    // Console.Write(sample.toString());
    //
    // var start = DateTime.Now;
    // var gen = new dropecho.dungen.convchain.ConvChain(sample);
    // var map = gen.generate(80, 40, 2, 1, 25);
    //
    // Console.Write(map.toString());
    // Console.WriteLine("took: " + (DateTime.Now - start));


    return 0;
  }
}
