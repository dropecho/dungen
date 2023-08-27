package dropecho.dungen.map.extensions;

using Lambda;

import haxe.ds.IntMap;
import dropecho.dungen.Map2d;

@:expose("dungen.FloodFill")
class FloodFill {
	public static function floodFill(
		map:Map2d,
		x:Int,
		y:Int,
		value:Int = 0,
		diagonal:Bool = true
	):Array<Tile2d> {
		var visited = new IntMap<Tile2d>();
		var queue = new Array<Tile2d>();
		var neighbors = new Array<Tile2d>();

		var currentTile = map.IndexToXY(map.XYtoIndex(x, y));
		queue.push(currentTile);

		function whereHasNotBeenVisited(tile) {
			return visited.get(map.XYtoIndex(tile.x, tile.y)) == null;
		}

		function whereTileIsSameType(tile) {
			return map.get(tile.x, tile.y) == value;
		}

		while (queue.length > 0) {
			currentTile = queue.pop();

			visited.set(map.XYtoIndex(currentTile.x, currentTile.y), currentTile);
			neighbors = map
				.getNeighbors(currentTile.x, currentTile.y, 1, diagonal)
				.filter(whereHasNotBeenVisited)
				.filter(whereTileIsSameType);

			queue = queue.concat(neighbors);
		}

		return visited.array();
	}
}
