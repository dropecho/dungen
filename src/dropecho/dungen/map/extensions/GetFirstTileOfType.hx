package dropecho.dungen.map.extensions;

import dropecho.dungen.Map2d;

using Lambda;

@:expose("dungen.GetFirstTileOfType")
class GetFirstTileOfType {
	public static function getFirstTileOfType(
		map:Map2d,
		tile:Int = 0,
		ignore:Array<Tile2d> = null
	):Tile2d {
		function isIgnored(check) {
			if (ignore != null) {
				return ignore.find(tile -> tile.x == check.x && tile.y == check.y) != null;
			}
			return false;
		}

		for (i in 0...map._height * map._width) {
			if (map._mapData[i] == tile) {
				var cur = map.IndexToXY(i);
				if (isIgnored(cur)) {
					continue;
				}
				return cur;
			}
		}
		return null;
	}
}
