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
		var params = new CAParams();
		var map = CAGenerator.generate(params);
		var json = TiledExporter.export(map);

		#if !js
		File.saveContent("artifacts/ca.json", json);
		#end

		var parsed:Dynamic = haxe.Json.parse(json);
		Assert.equals(map._width, parsed.width);
		Assert.equals(map._height, parsed.height);
		Assert.equals(map._mapData.length, (parsed.layers[0].data : Array<Int>).length);
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

		var parsed:Dynamic = haxe.Json.parse(json);
		Assert.equals(map._width, parsed.width);
		Assert.equals(map._height, parsed.height);
		Assert.equals(map._mapData.length, (parsed.layers[0].data : Array<Int>).length);
	}
}
