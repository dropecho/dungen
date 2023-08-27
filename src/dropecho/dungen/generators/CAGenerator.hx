package dropecho.dungen.generators;

import dropecho.dungen.generators.RandomGenerator;
import dropecho.interop.Extender;
import dropecho.dungen.Map2d;

typedef CA_PARAM_STEP = {
	reps:Int,
	r1_cutoff:Int,
	r2_cutoff:Int,
	invert:Bool
}

@:expose("dungen.CA_PARAMS")
class CA_PARAMS {
	public var steps:Array<CA_PARAM_STEP> = new Array<CA_PARAM_STEP>();
	public var height:Int = 64;
	public var width:Int = 64;
	public var tile_floor:Int = 1;
	public var tile_wall:Int = 0;
	public var start_fill_percent:Int = 65;
	public var seed:String = "0";
	public var useOtherType = false;

	public function new() {
		steps = [
			{
				reps: 4,
				r1_cutoff: 5,
				r2_cutoff: 2,
				invert: true
			},
			{
				reps: 3,
				r1_cutoff: 5,
				r2_cutoff: 0,
				invert: true
			}
		];
	}
}

@:expose("dungen.CAGenerator")
class CAGenerator {
	public static function generate(?opts:CA_PARAMS = null):Map2d {
		var params = opts == null ? new CA_PARAMS() : opts;
		var map = RandomGenerator.generate(params);

		var temp = map.clone();

		for (step in params.steps) {
			for (_ in 0...step.reps) {
				buildFromCA(temp, map, params, step);
			}
		}

		return map;
	}

	private static function buildFromCA(
		temp:Map2d,
		map:Map2d,
		params:CA_PARAMS,
		step:CA_PARAM_STEP
	):Void {
		var alive_tile_type = step.invert ? params.tile_floor : params.tile_wall;
		var dead_tile_type = step.invert ? params.tile_wall : params.tile_floor;

		for (x in 0...params.width) {
			for (y in 0...params.height) {
				var nCount = map.getNeighborCount(x, y, alive_tile_type);
				if (!params.useOtherType) {
					var is_alive = map.get(x, y) == alive_tile_type;

					if (!is_alive && nCount >= step.r1_cutoff) {
						is_alive = true;
					} else if (is_alive && nCount >= step.r2_cutoff) {
						is_alive = true;
					} else {
						is_alive = false;
					}

					temp.set(x, y, is_alive ? alive_tile_type : dead_tile_type);
				} else {
					var nCount2 = map.getNeighborCount(x, y, alive_tile_type, 2);
					if (nCount >= step.r1_cutoff || nCount2 <= step.r2_cutoff) {
						temp.set(x, y, dead_tile_type);
					} else {
						temp.set(x, y, alive_tile_type);
					}
				}
			}
		}

		map._mapData = temp._mapData.copy();
	}
}
