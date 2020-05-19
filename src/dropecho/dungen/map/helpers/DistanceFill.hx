package dropecho.dungen.map.helpers;

import dropecho.dungen.Map2d;

@:expose("dungen.DistanceFill")
class DistanceFill {
	public static function distanceFill(map:Map2d, tile:Int = 0, diagonal:Bool = true, maxDepth:Int = 40) {
		var distanceMap = new Map2d(map._width, map._height);
		for (i in 0...map._mapData.length) {
			distanceMap._mapData[i] = map._mapData[i] == tile ? 0 : 999;
		}

		var pass = 0;
		var changes = 1;
		while (changes > 0 && pass++ < maxDepth) {
			changes = 0;
			for (x in 0...distanceMap._width) {
				for (y in 0...distanceMap._height) {
					var neighbors = distanceMap.getNeighbors(x, y, 1);

					for (n in neighbors) {
						var v = distanceMap.get(x, y);
						var nval = distanceMap.get(n.x, n.y);
						if (nval < v) {
							distanceMap.set(x, y, nval + 1);
							changes++;
						}
					}
				}
			}
		}
		return distanceMap;
	}
}
