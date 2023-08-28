package export;

import utest.Assert;
import utest.Test;
import dropecho.dungen.bsp.BSPBuilder;
import dropecho.dungen.generators.RoomGenerator;
import dropecho.dungen.Map2d;
import dropecho.dungen.generators.CAGenerator;
import dropecho.dungen.export.TiledExporter;
#if !js
import sys.io.File;
#end

class TiledExporterTests extends Test {
	public var map:Map2d;

	public function test_ca_map() {
		var params = new CA_PARAMS();

		var map = CAGenerator.generate(params);
		var json = TiledExporter.export(map);

		#if !js
		File.saveContent("artifacts/ca.json", json);
		#end

		Assert.isTrue(true);
	}

	public function test_bsp_map() {
		var genOpts = {
			width: 64,
			height: 64,
			minHeight: 10,
			minWidth: 10,
			depth: 10,
			ratio: .65
		};

		var gen = new BSPBuilder(genOpts);
		var tree = gen.generate();
		var map = RoomGenerator.buildRooms(tree);

		var json = TiledExporter.export(map);

		#if !js
		File.saveContent("artifacts/bsp.json", json);
		#end

		Assert.isTrue(true);
	}
}
