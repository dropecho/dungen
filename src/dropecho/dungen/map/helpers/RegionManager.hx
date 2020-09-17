package dropecho.dungen.map.helpers;

import dropecho.dungen.Map2d;

using dropecho.dungen.map.helpers.GetFirstTileOfType;
using dropecho.dungen.map.helpers.FloodFill;

@:expose("dungen.RegionManager")
class RegionManager {
	public static function findAndTagRegions(map:Map2d, depth:Int = 2) {
		var regionmap = new Map2d(map._width, map._height, 0);
		for (i in 0...map._mapData.length) {
			var val = map._mapData[i] > depth ? depth : map._mapData[i];
			regionmap._mapData[i] = val;
		}

		var nextRegion:Tile2d;
		var nextTag = depth + 1;

		while ((nextRegion = regionmap.getFirstTileOfType(depth)) != null) {
			var tilesToFill = regionmap.floodFill(nextRegion.x, nextRegion.y, depth);

			for (t in tilesToFill) {
				regionmap.set(t.x, t.y, nextTag);
			}

			// no neighbors to fill, single tile region
			if (tilesToFill.length == 1) {
				regionmap.set(nextRegion.x, nextRegion.y, 1);
			}

			nextTag++;
		}

		return regionmap;
	}

	public static function expandRegions(map:Map2d, startTag:Int = 3, eatWalls = false) {
		for (_ in 0...100) {
			for (currentTag in startTag...startTag + 500) {
				var tilesToPaint = new Array<Int>();
				for (x in 0...map._width) {
					for (y in 0...map._height) {
						if (map.get(x, y) == currentTag) {
							var neighbors = map.getNeighbors(x, y, 1, true);
							for (n in neighbors) {
								if (n.val < startTag) {
									if (!eatWalls && n.val == 0) {
										continue;
									}
									var nWalls = map.getNeighborCount(n.x, n.y, 0, 1, true);
									var nOpen = 0;
									for (i in 1...startTag) {
										nOpen += map.getNeighborCount(n.x, n.y, i, 1, true);
									}
									var nTag = map.getNeighborCount(n.x, n.y, currentTag, 1, true);
									if (nWalls + nOpen + nTag == 8) {
										tilesToPaint.push(map.XYtoIndex(n.x, n.y));
									}
								}
							}
						}
					}
				}

				for (c in tilesToPaint) {
					map._mapData[c] = currentTag;
				}
			}
		}
		return map;
	}
}
