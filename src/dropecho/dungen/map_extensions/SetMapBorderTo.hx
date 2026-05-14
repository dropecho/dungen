package dropecho.dungen.map_extensions;

function setMapBorderTo(map:Map2d, tileType:Int = 0) {
	for (x in 0...map._width) {
		map.set(x, 0, tileType);
		map.set(x, map._height - 1, tileType);
	}

	for (y in 0...map._height) {
		map.set(0, y, tileType);
		map.set(map._width - 1, y, tileType);
	}
}
