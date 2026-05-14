package dropecho.dungen.regions.extensions;

import dropecho.dungen.map_extensions.Utils.distanceToValue;

function regionFill(map:Map2d, wall:Int = 0, diagonal:Bool = true) {
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
		var tile = regionMap.indexToXY(i);
		regionMap._mapData[i] = distanceToValue(regionMap, tile.x, tile.y, regionMapWallValue);
		// if dist == 1, check neighbors, and add number of walls to tile value.
	}

	return regionMap;
}
