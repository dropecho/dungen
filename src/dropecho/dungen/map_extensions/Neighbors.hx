package dropecho.dungen.map_extensions;

import dropecho.dungen.Map2d;

using Lambda;

@:expose("dungen.Neighbors")
class Neighbors {
	/**
	 * Get count of neighbors within distance matching neighborType.
	 *
	 * @param x - The x position of the tile.
	 * @param y - The y position of the tile.
	 * @param neighborType - The integer representing the type of tile to find.
	 * @param [dist] - The distance to search within.
	 * @param [diagonal] - Should this return diagonal neighbors? 
	 * @return The count of matching neighbors.
	 */
	public static function getNeighborCount(
		map:Map2d,
		x:Int,
		y:Int,
		neighborType:Int,
		dist:Int = 1,
		diagonal:Bool = true
	):Int {
		var count = 0;
		var isSelf = false;
		var isOutsideOfMap = false;

		for (i in -dist...dist + 1) {
			for (j in -dist...dist + 1) {
				isSelf = (i == 0 && j == 0);
				isOutsideOfMap = x + i < 0 || x + i >= (map._width) || y + j < 0 || y + j >= (map._height);

				if (isSelf || isOutsideOfMap) {
					continue;
				}

				if (!diagonal && ((i == j) || (i == -dist && j == dist) || (j == -dist && i == dist))) {
					continue;
				}

				if (map.get(x + i, y + j) == neighborType) {
					count++;
				}
			}
		}

		return count;
	}

	/**
	 * Return the neighbor tiles of the given tile at x,y. 
	 * @param x - The x coord of the tile to get neighbors for.
	 * @param y - The y coord of the tile to get neighbors for.
	 * @param [dist] - The max distance to search within, defaults to 1.
	 * @param [diagonal] - Should this check diagonals? defaults to true.
	 */
	public static function getNeighbors(
		map:Map2d,
		x:Int,
		y:Int,
		maxDist:Int = 1,
		diagonal:Bool = true
	):Array<Tile2d> {
		var neighbors = new Array<Tile2d>();
		var isSelf = false;
		var isNotOnMap = false;

		for (i in -maxDist...maxDist + 1) {
			for (j in -maxDist...maxDist + 1) {
				isSelf = (i == 0 && j == 0);
				isNotOnMap = x + i < 0 || x + i >= (map._width) || y + j < 0 || y + j >= (map._height);

				if (isSelf || isNotOnMap) {
					continue;
				}

				if (!diagonal && ((i == j) || (i == -maxDist && j == maxDist) || (j == -maxDist && i == maxDist))) {
					continue;
				}

				var val = map.get(x + i, y + j);

				neighbors.push(new Tile2d(x + i, y + j, val));
			}
		}

		return neighbors;
	}

	public static function getNeighborsAtDist(
		map:Map2d,
		x:Int,
		y:Int,
		dist:Int = 1,
		diagonal:Bool = true
	) {
		var neighbors = new Array<Tile2d>();

		for (i in -dist...dist + 1) {
			for (j in -dist...dist + 1) {
				// if not on first or last column, skip middle x's
				if (j != -dist && j != dist && i > -dist && i < dist) {
					continue;
				}

				// if not on first or last row, skip middle y's
				if (i != -dist && i != dist && j > -dist && j < dist) {
					continue;
				}

				var isSelf = (i == 0 && j == 0);
				var isNotOnMap = x + i < 0 || x + i >= (map._width) || y + j < 0 || y + j >= (map._height);

				if (isSelf || isNotOnMap) {
					continue;
				}

				if (!diagonal && ((i == j) || (i == -dist && j == dist) || (j == -dist && i == dist))) {
					continue;
				}

				var val = map.get(x + i, y + j);

				neighbors.push(new Tile2d(x + i, y + j, val));
			}
		}

		return neighbors;
	}
}
