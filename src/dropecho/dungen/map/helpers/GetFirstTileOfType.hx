package dropecho.dungen.map.helpers;

import dropecho.dungen.Map2d;

using Lambda;

class GetFirstTileOfType {
	public static function getFirstTileOfType(map:Map2d, tile:Int = 0, ignore:Array<Tile2d> = null):Tile2d {
		for (i in 0...map._height * map._width) {
			if (map._mapData[i] == tile) {
				var cur = map.IndexToXY(i);

				if (ignore != null) {
					var foo = ignore.find(function(tile) {
						return tile.x == cur.x && tile.y == cur.y;
					});

					if (foo != null) {
						continue;
					}
				}

				return cur;
			}
		}

		return null;
	}
}
