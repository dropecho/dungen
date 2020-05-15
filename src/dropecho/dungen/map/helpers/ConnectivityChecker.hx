package dropecho.dungen.map.helpers;

using dropecho.dungen.map.helpers.GetFirstEmptyTile;
using dropecho.dungen.map.helpers.FloodFill;

class ConnectivityChecker {
	public static function run(map:Map2d, tile:Int = 0, diagonal:Bool = true):Bool {
		var start = map.getFirstEmptyTile(tile);
		var filled = map.floodFill(start.x, start.y, tile, diagonal);

		return map.getFirstEmptyTile(tile, filled) == null;
	}
}
