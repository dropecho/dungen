package dropecho.dungen.map.helpers;

using dropecho.dungen.map.helpers.FloodFill;
using dropecho.dungen.map.helpers.GetFirstTileOfType;

@:expose("dungen.CheckConnectivity")
class CheckConnectivity {
	public static function checkConnectivity(map:Map2d, tile:Int = 0, diagonal:Bool = true):Bool {
		// get random non-filled tile
		var firstTile = map.getFirstTileOfType(tile);
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
