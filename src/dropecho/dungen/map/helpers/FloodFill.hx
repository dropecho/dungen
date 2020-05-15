package dropecho.dungen.map.helpers;

using Lambda;

import haxe.ds.IntMap;
import dropecho.dungen.Map2d;

class FloodFill {
	public static function floodFill(map:Map2d, startX:Int, startY:Int, tile:Int = 0, diagonal:Bool = true):Array<Tile2d> {
		var closed = new IntMap<Tile2d>();
		var open = new Array<Tile2d>();
		var neighbors = new Array<Tile2d>();

		var currentTile = map.IndexToXY(map.XYtoIndex(startX, startY));
		open.push(currentTile);

		function whereHasNotBeenVisited(tile) {
			return closed.get(map.XYtoIndex(tile.x, tile.y)) == null;
		}

		function whereTileIsSameType(t) {
			return map.get(t.x, t.y) == tile;
		}

		while (open.length > 0) {
			currentTile = open.pop();

			closed.set(map.XYtoIndex(currentTile.x, currentTile.y), currentTile);
			neighbors = map.getNeighbors(currentTile.x, currentTile.y, 1, diagonal).filter(whereHasNotBeenVisited).filter(whereTileIsSameType);

			open = open.concat(neighbors);
		}

		return closed.array();
	}
}
