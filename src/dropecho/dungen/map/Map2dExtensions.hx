package dropecho.dungen.map;

@:expose("dungen.Map2dExtensions")
class Map2dExtensions {
	public static function setAllEdgesTo(map:Map2d, tileType:Int = 0) {
		for (x in 0...map._width) {
			map.set(x, 0, tileType);
			map.set(x, map._height - 1, tileType);
		}

		for (y in 0...map._height) {
			map.set(0, y, tileType);
			map.set(map._width - 1, y, tileType);
		}
	}

	public static function clone(map:Map2d, mapData:Array<Int> = null) {
		var clone = new Map2d(map._width, map._height);
		if (mapData != null) {
			clone._mapData = mapData;
		} else {
			for (i in 0...map._mapData.length) {
				clone._mapData[i] = map._mapData[i];
			}
		}
		return clone;
	}
}
