package export;

import massive.munit.Assert;
import degen.bsp.Generator;
import degen.bsp.Node;
import degen.map.generators.RoomGenerator;
import degen.map.Map2d;
import degen.ca.Generator as CaGen;
import degen.export.TiledExporter;

import sys.io.File;

class TiledExporterTest {
    var map : Map2d;

    @Test
    public function ca_map_test() {

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
            //height: 32,
            //width: 32,
            //tile_floor: 1,
            //tile_wall: 0

        //};

		//var map = CaGen.generate(params);
			//var genOpts = {
			//width: 100,
			//height: 50,
			//minHeight: 10,
			//minWidth: 10,
			//depth: 10,
			//ratio: .65
			//};

			//var gen = new Generator(genOpts);

		//var map = RoomGenerator.buildRooms(gen.generate());



		//var json = TiledExporter.export('map.json', map);

		//File.saveContent("bsp.json", json);	

        Assert.isTrue(true);
    }
}
