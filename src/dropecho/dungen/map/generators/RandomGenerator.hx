package dropecho.dungen.map.generators;

import seedyrng.Random;
import dropecho.interop.Extender;

@:expose("dungen.RandomGenerator")
class RandomGenerator {
	public static function generate(?params:Dynamic):Map2d {
		var random:Random = new Random();
		if (params.seed != null) {
			random.setStringSeed(params.seed);
		}
		var height:Int = params.height;
		var width:Int = params.width;

		var tile_floor:Int = params.tile_floor;
		var tile_wall:Int = params.tile_wall;
		var start_fill_percent:Int = params.start_fill_percent;

		var map = new Map2d(width, height, tile_wall);

		for (i in 0...(width * height)) {
			map._mapData[i] = random.random() * 100 > start_fill_percent ? tile_floor : tile_wall;
		}

		return map;
	}
}
