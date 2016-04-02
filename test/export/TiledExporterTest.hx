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
            height: 64,
            width: 64,
            tile_floor: 2,
            tile_wall: 1,
            start_fill_percent: 45
        };

		var map = CaGen.generate(params);
        var json = TiledExporter.export('map.json', map);

        File.saveContent("example/ca.json", json);

        Assert.isTrue(true);
    }

    @Test
    public function bsp_map_test(){
        var genOpts = {
            width: 64,
            height: 64,
            minHeight: 10,
            minWidth: 10,
            depth: 10,
            ratio: .65
        };

        var gen = new Generator(genOpts);
        var map = RoomGenerator.buildRooms(gen.generate());

        var json = TiledExporter.export('map.json', map);

        File.saveContent("example/bsp.json", json);

        Assert.isTrue(true);
    }
}
