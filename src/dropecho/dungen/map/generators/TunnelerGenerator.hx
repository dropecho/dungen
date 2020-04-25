package dropecho.dungen.map.generators;

import dropecho.dungen.ca.Generator as CAGen;
import dropecho.dungen.utils.Extender;
import dropecho.dungen.map.Map2d;

@:expose("dropecho.dungen.TunnelerGenerator")
class TunnelerGenerator {
	public static function generate(?params:Dynamic) : Map2d {
		var height:Int = params.height;
		var width:Int = params.width;

		var tile_floor:Int = params.tile_floor;
		var tile_wall:Int = params.tile_wall;
		var start_fill_percent:Int = params.start_fill_percent;
		var countOfFilled:Int = 0;
		var totalCount:Int = height * width;

		var map = new Map2d(width, height, tile_wall);

		var walkerPos = {x: Std.int(width / 2), y: Std.int(height/2) };

		map.set(walkerPos.x, walkerPos.y, 0);
		return map;
	}

	private static function getEntrancePosition(map:Map2d):Tile2d {
		var top = Std.random(2) == 1;
		var right = Std.random(2) == 1;

		// var start = {x:Std.int(map._width/2), y:0};

		// return start;
    return null;
	}
}

private class Tunneler {
	var map:Map2d;
	var position:Tile2d;
	var width:Int;
	var direction:Int;
	var lifeSpan:Int;

	public function new(
	    map:Map2d,
	    position:Tile2d,
	    width:Int = 1,
	    direction:Int = 2,
	    lifeSpan:Int = 5
	) {
		this.map = map;
		this.position = position;
		this.width = width;
		this.direction = direction;
		this.lifeSpan = lifeSpan;
	}

	public function run() {
		var ticks = 0;

		while(ticks < lifeSpan) {
			//do tunnel
		}
	}
}
