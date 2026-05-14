package dropecho.dungen.map_extensions;

using Lambda;

import dropecho.ds.Set;
import dropecho.ds.Queue;
import dropecho.dungen.Map2d;

@:expose("dungen.FloodFill")
class FloodFill {
	public static function floodFill(
		map:Map2d,
		x:Int,
		y:Int,
		value:Int = 0,
		diagonal:Bool = true
	):Set<Tile2d> {
		var visited = new Set<Tile2d>(t -> map.XYtoIndex(t.x, t.y));
		var queue = new Queue<Tile2d>();

		var current = new Tile2d(x, y, 0);
		queue.enqueue(current);

		inline function whereHasNotBeenVisited(tile) {
			return !visited.exists(tile);
		}

		inline function whereTileIsSameType(tile) {
			return map.get(tile.x, tile.y) == value;
		}

		// While we have tiles in the queue,
		// Search the neighbors for ones that have not been visited, and are the
		// same type we are trying to fill.
		while (queue.length > 0) {
			current = queue.dequeue();
			visited.add(current);

			queue.enqueueMany(map
				.getNeighbors(current.x, current.y, 1, diagonal)
				.filter(tile -> whereHasNotBeenVisited(tile) && whereTileIsSameType(tile))
			);
		}

		return visited;
	}
}
