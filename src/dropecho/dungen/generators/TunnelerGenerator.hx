package dropecho.dungen.generators;

import seedyrng.Random;
import dropecho.interop.Extender;
import dropecho.dungen.Map2d;

typedef TunnelerConfigProps = {
	var ?width:Int;
	var ?height:Int;
	var ?tile_floor:Int;
	var ?tile_wall:Int;
	var ?seed:String;
	var ?numTunnelers:Int;
	var ?lifeSpan:Int;
}

@:noDoc
class TunnelerParams {
	public var width:Int = 64;
	public var height:Int = 64;
	public var tile_floor:Int = 1;
	public var tile_wall:Int = 0;
	public var seed:String = "0";
	public var numTunnelers:Int = 3;
	public var lifeSpan:Int = 200;

	public function new() {}
}

@:expose("dungen.TunnelerGenerator")
class TunnelerGenerator {
	public static function generate(?opts:TunnelerConfigProps):Map2d {
		var params:TunnelerConfigProps = Extender.defaults(new TunnelerParams(), opts);
		var random:Random = new Random();
		random.setStringSeed(params.seed);

		var map = new Map2d(params.width, params.height, params.tile_wall);
		var centerX = Std.int(params.width / 2);
		var centerY = Std.int(params.height / 2);

		for (_ in 0...params.numTunnelers) {
			var tunneler = new Tunneler(map, new Tile2d(centerX, centerY), params.tile_floor, random, params.lifeSpan);
			tunneler.run();
		}

		return map;
	}
}

private class Tunneler {
	var map:Map2d;
	var position:Tile2d;
	var tileFloor:Int;
	var random:Random;
	var lifeSpan:Int;

	public function new(map:Map2d, position:Tile2d, tileFloor:Int, random:Random, lifeSpan:Int) {
		this.map = map;
		this.position = position;
		this.tileFloor = tileFloor;
		this.random = random;
		this.lifeSpan = lifeSpan;
	}

	public function run() {
		var ticks = 0;

		while (ticks < lifeSpan) {
			map.set(position.x, position.y, tileFloor);

			var direction = random.randomInt(0, 3);

			position.y += direction == 0 ? -1 : 0;
			position.y += direction == 2 ? 1 : 0;
			position.x += direction == 1 ? -1 : 0;
			position.x += direction == 3 ? 1 : 0;

			if (position.x < 0) position.x = 0;
			if (position.x >= map._width) position.x = map._width - 1;
			if (position.y < 0) position.y = 0;
			if (position.y >= map._height) position.y = map._height - 1;

			ticks++;
		}
	}
}
