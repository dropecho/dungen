package dropecho.dungen.generators;

import dropecho.dungen.Map2d;
import dropecho.dungen.generators.RandomGenerator;
import dropecho.interop.Extender;

typedef CellularConfigProps = {
	?height:Int,
	?width:Int,
	?tile_floor:Int,
	?tile_wall:Int,
	?start_fill_percent:Int,
	?seed:String,
	?bornCount:Int,
	?surviveCount:Int,
	?passes:Int
}

@:expose("dungen.CellularParams")
class CellularParams {
	public var height:Int = 64;
	public var width:Int = 64;
	public var tile_floor:Int = 1;
	public var tile_wall:Int = 0;
	public var start_fill_percent:Int = 65;
	public var seed:String = "0";
	public var bornCount = 4;
	public var surviveCount = 5;

	public var passes = 1;

	public function new() {}
}

@:expose("dungen.CellularGenerator")
class CellularGenerator {
	public static function generate(?opts:CellularConfigProps = null):Map2d {
		var params:CellularParams = Extender.defaults(new CellularParams(), opts);
		var map = RandomGenerator.generate(params);

		var temp = map.clone();

		for (_ in 0...params.passes) {
			for (tile in map) {
				var neighborCount = map.getNeighborCount(tile.x, tile.y, params.tile_floor);
				if (tile.val == params.tile_floor && neighborCount > params.surviveCount) {
					continue;
				}
				if (tile.val == params.tile_wall && neighborCount > params.bornCount) {
					temp.set(tile.x, tile.y, params.tile_floor);
				} else {
					temp.set(tile.x, tile.y, params.tile_wall);
				}
			}
			map._mapData = temp._mapData.copy();
			temp = map.clone();
		}

		map._mapData = temp._mapData.copy();
		return map;
	}
}
