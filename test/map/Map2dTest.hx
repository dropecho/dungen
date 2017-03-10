package map;

import massive.munit.Assert;
import degen.map.Map2d;
import degen.bsp.Generator;
import degen.bsp.BspData;
import degen.map.generators.RoomGenerator;
import degen.map.generators.MixedGenerator;
import degen.ca.Generator as CaGen;

class Map2dTest {
  @Test
  public function bspMapTest() {
    // var map = CaGen.generate({
    //   width: 64,
    //   height: 32,
    //   start_fill_percent: 55,
    //   tile_floor: 46,
    //   tile_wall: 35
    // });


    var gen = new Generator();
    var map = gen.generate();

    var bsp = new Generator({
      width: 64,
      height: 32,
      minWidth: 8,
      minHeight: 8,
      depth: 6,
      ratio: .95
    }).generate();

    var map = RoomGenerator.buildRooms(bsp, {tileFloor: 46, tileWall: 35});

    trace(map);
    Assert.isTrue(true);
  }

  @Test
  public function get_neighbors_should_return_all_neighbors_of_tile(){
    var map = new Map2d(4,4);

    var neighbors = map.getNeighbors(0,0); 
    Assert.areEqual(neighbors.length, 3);
  }

  @Test
  public function get_neighbors_should_return_all_neighbors_of_tile_2(){
    var map = new Map2d(4,4);

    var neighbors = map.getNeighbors(2,2); 
    Assert.areEqual(neighbors.length, 8);
  }

}
