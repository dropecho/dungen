package dropecho.dungen.map.extensions;

using dropecho.dungen.map.extensions.FloodFill;
using dropecho.dungen.map.extensions.GetFirstTileOfType;

@:expose("dungen.CheckConnectivity")
class CheckConnectivity {
	public static function checkConnectivity(map:Map2d, tile:Int = 0, diagonal:Bool = true):Bool {
		// get random non-filled tile
		var firstTile = map.getFirstTileOfType(tile);

		// If no tiles of the given type are found, default to false.
		if (firstTile == null) {
			return false;
		}

		// floodfill from tile
		var filledTiles = map.floodFill(firstTile.x, firstTile.y, tile, diagonal);

		// Get another tile of the same type, ignoring the ones we just filled.
		// If found, this means map is not connected.
		firstTile = map.getFirstTileOfType(tile, filledTiles);

		return firstTile == null;
	}
}
