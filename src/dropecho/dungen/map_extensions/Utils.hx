package dropecho.dungen.map_extensions;

import dropecho.dungen.map_extensions.Rect;

/**
 * @param map - The map to search on.
 * @param fromX - The starting x coordinate.
 * @param fromY - The starting y coordinate.
 * @param valueToFind - The value to find the distance to (closest tile with this value.)
 * @param [maxDistance] - The max distance to search, will return this if further/not found.
 * @returns The distance to the closest tile with the valueToFind.
 */
function distanceToValue(map:Map2d, fromX:Int, fromY:Int, valueToFind:Int, maxDistance:Int = 10) {
	var dist = 1;
	while (dist <= maxDistance) {
		if (map.get(fromX, fromY) == valueToFind) {
			return 0;
		}

		var count = map.getNeighborCount(fromX, fromY, valueToFind, dist);

		if (count > 0) {
			return dist;
		}
		dist++;
	}

	return maxDistance;
}

function isOverlappingArray(r1, a:Array<Dynamic>) {
	for (r in a) {
		if (r == r1) {
			continue; // Ignore itself.
		}

		if (checkOverlap(r1, r)) {
			return true;
		}
	}

	return false;
}
