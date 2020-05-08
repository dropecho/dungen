package dropecho.dungen.generators;

import seedyrng.Random;
import dropecho.interop.Extender;

class RandomParams {
	public var height:Int = 64;
	public var width:Int = 64;
	public var tile_floor:Int = 1;
	public var tile_wall:Int = 0;
	public var start_fill_percent:Int = 50;
	public var seed:String = "0";

	public function new() {}
}

@:expose("dungen.RandomGenerator")
class RandomGenerator {
	public static function generate(?opts:Dynamic = null):Map2d {
		var params:RandomParams = Extender.defaults(new RandomParams(), opts);

		var random:Random = new Random();
		random.setStringSeed(params.seed);

		var map = new Map2d(params.width, params.height, params.tile_wall);

		for (i in 0...(params.width * params.height)) {
			map._mapData[i] = random.random() * 100 > params.start_fill_percent ? params.tile_floor : params.tile_wall;
		}

		return map;
	}
}
