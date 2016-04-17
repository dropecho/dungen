package map;

import massive.munit.Assert;
import degen.map.Map2d;
import degen.bsp.Generator;
import degen.bsp.BspData;
import degen.map.generators.RoomGenerator;
import degen.map.generators.MixedGenerator;
import degen.ca.Generator as CaGen;

class Map2dTest {
    var map : Map2d;

    //@Before
        //public function setup(){
            //map = new Map2d(100, 50);
        //}

    @Test
	public function bspMapTest() {
		
		var map = new Generator({
			width: 120,
			height: 60,
			minWidth: 15,
			minHeight: 15
		}).generate();
		trace(MixedGenerator.buildRooms(map));
		Assert.isTrue(true);
	}
}
