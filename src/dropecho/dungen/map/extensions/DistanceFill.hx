package dropecho.dungen.map.extensions;

import dropecho.ds.Stack;
import dropecho.ds.Set;
import dropecho.dungen.Map2d;

using dropecho.dungen.map.extensions.Neighbors;
using Lambda;

@:expose("dungen.DistanceFill")
class DistanceFill {
	public static function distanceFill(
		map:Map2d,
		valueToMeasureFrom:Int = 0,
		diagonal:Bool = true,
		maxDepth:Int = 40
	) {
		var distanceMap = new Map2d(map._width, map._height);
		for (i in 0...map._mapData.length) {
			distanceMap._mapData[i] = map._mapData[i] == valueToMeasureFrom ? 0 : 1;
		}

		var visited = new Set<Tile2d>(t -> map.XYtoIndex(t.x, t.y));
		var stack = new Stack<Tile2d>();
		var neighbors = new Array<Tile2d>();

		var start = distanceMap.getFirstTileOfType(valueToMeasureFrom);
		stack.push(start);

		function whereHasNotBeenVisited(tile) {
			return visited.get(tile) == null;
		}

		function whereTileIsValue(tile, value) {
			return distanceMap.get(tile.x, tile.y) == value;
		}

		while (stack.length > 0) {
			var current = stack.pop();
			visited.add(current);
			neighbors = distanceMap.getNeighbors(current.x, current.y, 1, diagonal);

			if (current.val != 0) {
				var lowest = Std.int(neighbors.fold((t, val) -> Math.min(t.val, val), 999));
				distanceMap.set(current.x, current.y, Std.int(Math.min(lowest + 1, maxDepth)));
			}

			neighbors = neighbors.filter(whereHasNotBeenVisited);

			stack.pushMany(neighbors.filter(t -> whereTileIsValue(t, valueToMeasureFrom)));
			stack.pushMany(neighbors.filter(t -> !whereTileIsValue(t, valueToMeasureFrom)));
		}
		return distanceMap;
	}
}
