package dropecho.dungen.map_extensions;

import dropecho.dungen.Map2d;
import dropecho.dungen.map_extensions.Utils.distanceToValue;

function distanceFill(map:Map2d, valueToFind:Int = 0, maxDistance:Int = 10) {
	var distanceMap = new Map2d(map._width, map._height);

	for (x in 0...distanceMap._width) {
		for (y in 0...distanceMap._height) {
			var dist = distanceToValue(map, x, y, valueToFind, maxDistance);
			distanceMap.set(x, y, dist);
		}
	}

	return distanceMap;
}
