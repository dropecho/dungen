package dropecho.dungen.ca;

import dropecho.dungen.map.generators.RandomGenerator;
import dropecho.interop.Extender;
import dropecho.dungen.map.Map2d;

@:expose("dungen.CA_PARAM_STEP")
// class CA_PARAM_STEP = {
//   public var reps:Int = 4;
//   public var r1_cutoff:Int = 5;
//   public var r2_cutoff:Int = 2;
// }
typedef CA_PARAM_STEP = {
	reps:Int,
	r1_cutoff:Int,
	r2_cutoff:Int
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

	public function new() {
		steps = [
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
		];
		// var step1 = new CA_PARAM_STEP();
		// step1.reps = 4;
		// step1.r1_cutoff = 5;
		// step1.r2_cutoff = 2;
		//
		// var step2 = new CA_PARAM_STEP();
		// step2.reps = 3;
		// step2.r1_cutoff = 5;
		// step2.r2_cutoff = 0;
		//
		// steps.push(step1);
		// steps.push(step2);
	}
}

@:expose("dungen.CAGenerator")
class Generator {
	public static function generate(?opts:Dynamic = null):Map2d {
		var params = Extender.defaults(new CA_PARAMS(), opts);

		var map = RandomGenerator.generate(params);
		map.ensureEdgesAreWalls(params.tile_wall);

		for (step in params.steps) {
			for (_ in 0...step.reps) {
				buildFromCA(map, params, step);
			}
		}

		map.ensureEdgesAreWalls(params.tile_wall);
		return map;
	}

	private static function buildFromCA(map:Map2d, params:CA_PARAMS, step:CA_PARAM_STEP):Void {
		var temp = new Map<Int, Int>();

		for (x in 1...params.width - 1) {
			for (y in 1...params.height - 1) {
				var nCount = map.getNeighborCount(x, y, params.tile_floor);
				var nCount2 = map.getNeighborCount(x, y, params.tile_floor, 2);
				var pos = map.XYtoIndex(x, y);

				if (nCount >= step.r1_cutoff || nCount2 <= step.r2_cutoff) {
					temp.set(pos, params.tile_wall);
				} else {
					temp.set(pos, params.tile_floor);
				}
			}
		}

		for (i in temp.keys()) {
			var pos = map.IndexToXY(i);
			map.set(pos.x, pos.y, temp[i]);
		}
	}
}
