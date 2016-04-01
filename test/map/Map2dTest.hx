package map;

import massive.munit.Assert;
import degen.map.Map2d;
import degen.bsp.Generator;
import degen.bsp.Node;
import degen.map.generators.RoomGenerator;
import degen.ca.Generator as CaGen;

class Map2dTest {
    var map : Map2d;

    //@Before
        //public function setup(){
            //map = new Map2d(100, 50);
        //}

    @Test
        public function bspMapTest() {
			var genOpts = {
				width: 100,
				height: 50,
				minHeight: 10,
				minWidth: 10,
				depth: 10,
				ratio: .65
			};

			var gen = new Generator(genOpts);

			trace(RoomGenerator.buildRooms(gen.generate()));


            //var params = {
                //steps: [{
                    //reps: 4,
                    //r1_cutoff: 5,
                    //r2_cutoff: 2
                //},
                //{
                    //reps : 3,
                    //r1_cutoff: 5,
                    //r2_cutoff: 0
                //}],
                //height: 50,
                //width: 100,
                //tile_floor: 1,
                //tile_wall: 0

            //};

            //trace(CaGen.generate(params));


            Assert.isTrue(true);
        }
}
