package dropecho.dungen.map.extensions;

import haxe.ds.IntMap;
import dropecho.dungen.Map2d;
import dropecho.ds.Queue;

using Lambda;

@:expose("dungen.RegionFill")
class RegionFill {
	public static function BFS(map:Map2d, x:Int, y:Int, value:Int):Array<Tile2d> {
		var q = new Queue<Tile2d>();
		var visited = new IntMap<Int>();

		q.enqueue(new Tile2d(x, y));
		visited.set(map.XYtoIndex(x, y), -1);

		var currentIndex = -1;

		while (q.length > 0) {
			var current = q.dequeue();
			if (map.get(current.x, current.y) == value) {
				break;
			}

			currentIndex = map.XYtoIndex(current.x, current.y);
			var neighbors = map.getNeighbors(current.x, current.y);

			for (neighbor in neighbors) {
				var index = map.XYtoIndex(neighbor.x, neighbor.y);
				if (!visited.exists(index)) {
					visited.set(index, currentIndex);
					q.enqueue(neighbor);
				}
			}
		}

		var path = new Array<Tile2d>();
		while (currentIndex != -1) {
			currentIndex = visited.get(currentIndex);
			if (currentIndex != -1) {
				path.push(map.IndexToXY(currentIndex));
			}
		}

		return path;
	}

	public static function distToValue(map:Map2d, x:Int, y:Int, value:Int) {
		var count = 0;
		var dist = 0;
		while (count == 0 && dist < 10) {
			dist++;
			count = map.getNeighborCount(x, y, value, dist);
		}
		return dist - 1;
	}

	public static function regionFill(map:Map2d, wall:Int = 0, diagonal:Bool = true) {
		var regionMapWallValue = 999999;

		var regionMap = new Map2d(map._width, map._height);
		for (i in 0...map._mapData.length) {
			if (map._mapData[i] == wall) {
				regionMap._mapData[i] = regionMapWallValue;
			} else {
				regionMap._mapData[i] = map._mapData[i];
			}
		}

		for (i in 0...regionMap._mapData.length) {
			// foreach non wall
			if (regionMap._mapData[i] == regionMapWallValue) {
				continue;
			}
			// BFS for nearest wall, set value to dist.
			var tile = regionMap.IndexToXY(i);
			regionMap._mapData[i] = distToValue(regionMap, tile.x, tile.y, regionMapWallValue);
			// if dist == 1, check neighbors, and add number of walls to tile value.
		}

		return regionMap;
	}
}
