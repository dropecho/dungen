package map;

import massive.munit.Assert;
import degen.map.Map2d;
import degen.bsp.Generator;
import degen.bsp.Node;
import degen.map.generators.RoomGenerator;
import degen.ca.Generator as CaGen;

class Map2dTest {
    var map : Map2d;

    @Before
        public function setup(){
            map = new Map2d(96, 48);
        }

    @Test
        public function bspMapTest() {
            //var genOpts = {
            //width: 96,
            //height: 48,
            //minHeight: 12,
            //minWidth: 12,
            //depth: 8,
            //ratio: .45
            //};

            //var gen = new Generator(genOpts);

            //trace(RoomGenerator.buildRooms(gen.generate()));


            var params = {
                steps: [{
                    reps: 4,
                    r1_cutoff: 5,
                    r2_cutoff: 2
                },
                {
                    reps : 3,
                    r1_cutoff: 5,
                    r2_cutoff: 0
                }],
                height: 32,
                width: 64,
                tile_floor: 1,
                tile_wall: 0

            };

            trace(CaGen.generate(params));


            Assert.isTrue(true);
        }
}
