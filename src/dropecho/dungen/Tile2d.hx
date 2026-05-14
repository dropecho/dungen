package dropecho.dungen;

import dropecho.dungen.Map2d;

@:expose("dungen.Tile2d")
@:struct
class Tile2d {
	public var x:Int;
	public var y:Int;
	public var val:Int;

	public function new(x:Int, y:Int, ?val:Int) {
		this.x = x;
		this.y = y;
		this.val = val;
	};
}

class TileIterator {
	var map:Map2d;
	var current = 0;

	public function new(map:Map2d) {
		this.map = map;
	}

	public inline function hasNext():Bool {
		return current < map._mapData.length;
	}

	public inline function next():Tile2d {
		return map.indexToXY(current++);
	}
}
