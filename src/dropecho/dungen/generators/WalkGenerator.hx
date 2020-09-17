package dropecho.dungen.generators;

import seedyrng.Random;
import dropecho.interop.Extender;

typedef WALK_PARAMS = {
	var ?height:Int;
	var ?width:Int;
	var ?tile_floor:Int;
	var ?tile_wall:Int;
	var ?start_fill_percent:Int;
	var ?seed:String;
}

@:noDoc
class WALK_PARAMS_DEF {
	public var height:Int = 64;
	public var width:Int = 64;
	public var tile_floor:Int = 1;
	public var tile_wall:Int = 0;
	public var start_fill_percent:Int = 50;
	public var seed:String = "0";

	public function new() {}
}

@:expose("dungen.WalkGenerator")
class WalkGenerator {
	/**
	 * Generates a random walk based map.
	 *
	 * @param opts - The paramaters.
	 * @return The generated map.
	 */
	public static function generate(?opts:WALK_PARAMS):Map2d {
		var params:WALK_PARAMS = Extender.defaults(new WALK_PARAMS_DEF(), opts);
		var random:Random = new Random();
		random.setStringSeed(params.seed);

		var countOfFilled:Int = 0;
		var totalCount:Int = params.height * params.width;

		var map = new Map2d(params.width, params.height, params.tile_wall);

		var walkerPos = {x: Std.int(params.width / 2), y: Std.int(params.height / 2)};

		map.set(walkerPos.x, walkerPos.y, 0);
		var counter = 0;
		var direction = random.randomInt(0, 3);

		while (countOfFilled < totalCount * (params.start_fill_percent / 100)) {
			direction = random.randomInt(0, 3);
			if (map.get(walkerPos.x, walkerPos.y) != params.tile_floor) {
				map.set(walkerPos.x, walkerPos.y, params.tile_floor);
				countOfFilled++;
			}

			walkerPos.y += direction == 0 ? -1 : 0;
			walkerPos.y += direction == 2 ? 1 : 0;

			walkerPos.x += direction == 1 ? -1 : 0;
			walkerPos.x += direction == 3 ? 1 : 0;

			if (walkerPos.x < 0 || walkerPos.x > params.width - 1) {
				walkerPos.x = Std.int(params.width / 2);
				walkerPos.y = Std.int(params.height / 2);
			}

			if (walkerPos.y < 0 || walkerPos.y > params.height - 1) {
				walkerPos.x = Std.int(params.width / 2);
				walkerPos.y = Std.int(params.height / 2);
			}

			if (counter >= 500000) {
				break;
			}
			counter++;
		}

		return map;
	}
}
