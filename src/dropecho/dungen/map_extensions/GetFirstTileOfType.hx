package dropecho.dungen.map_extensions;

import dropecho.ds.Set;
import dropecho.dungen.Map2d;

using Lambda;

@:expose("dungen.GetFirstTileOfType")
class GetFirstTileOfType {
	public static function getFirstTileOfType(
		map:Map2d,
		tileVal:Int = 0,
		ignore:Array<Tile2d> = null
	):Null<Tile2d> {
		inline function isIgnored(check) {
			if (ignore == null) {
				return false;
			}
			return ignore.find(tile -> tile.x == check.x && tile.y == check.y) != null;
		}

		for (tile in map) {
			if (isIgnored(tile)) {
				continue;
			}
			if (tile.val == tileVal) {
				return tile;
			}
		}

		return null;
	}

	public static function getFirstTileOfTypeSet(
		map:Map2d,
		tileVal:Int = 0,
		ignore:Set<Tile2d> = null
	):Null<Tile2d> {
		for (tile in map) {
			if (ignore != null && ignore.exists(tile)) {
				continue;
			}
			if (tile.val == tileVal) {
				return tile;
			}
		}

		return null;
	}
}
