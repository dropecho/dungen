package dropecho.dungen.map_extensions;

function clone(map:Map2d, mapData:Array<Int> = null) {
	var cloned = new Map2d(map._width, map._height);
	if (mapData != null) {
		cloned._mapData = mapData;
	} else {
		for (i in 0...map._mapData.length) {
			cloned._mapData[i] = map._mapData[i];
		}
	}
	return cloned;
}
