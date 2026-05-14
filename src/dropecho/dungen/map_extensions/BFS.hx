package dropecho.dungen.map_extensions;

import haxe.ds.IntMap;
import dropecho.dungen.Map2d;
import dropecho.ds.Queue;

using Lambda;

function BFS(map:Map2d, x:Int, y:Int, value:Int):Array<Tile2d> {
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
			path.push(map.indexToXY(currentIndex));
		}
	}

	return path;
}
