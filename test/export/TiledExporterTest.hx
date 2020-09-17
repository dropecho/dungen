package export;

import massive.munit.Assert;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.generators.RoomGenerator;
import dropecho.dungen.Map2d;
import dropecho.dungen.generators.CAGenerator;
import dropecho.dungen.export.TiledExporter;
#if !js
import sys.io.File;
#end

class TiledExporterTest {
	public var map:Map2d;

	@Test
	public function ca_map_test() {
		var params = {
			steps: [
				{
					reps: 4,
					r1_cutoff: 5,
					r2_cutoff: 2
				},
				{
					reps: 3,
					r1_cutoff: 5,
					r2_cutoff: 0
				}
			],
			height: 32,
			width: 32,
			tile_floor: 2,
			tile_wall: 1,
			start_fill_percent: 45
		};

		var map = CAGenerator.generate(params);
    var json = TiledExporter.export(map);

		#if !js
    File.saveContent("artifacts/ca.json", json);
		#end

		Assert.isTrue(true);
	}

	@Test
	public function bsp_map_test() {
		var genOpts = {
			width: 64,
			height: 64,
			minHeight: 10,
			minWidth: 10,
			depth: 10,
			ratio: .65
		};

		var gen = new Generator(genOpts);
		var tree = gen.generate();
		var map = RoomGenerator.buildRooms(tree);

    var json = TiledExporter.export(map);

		#if !js
    File.saveContent("artifacts/bsp.json", json);
		#end

		Assert.isTrue(true);
	}
}
