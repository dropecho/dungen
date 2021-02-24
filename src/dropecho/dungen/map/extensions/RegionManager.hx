package dropecho.dungen.map.extensions;

import dropecho.dungen.Map2d;

using dropecho.dungen.map.extensions.GetFirstTileOfType;
using dropecho.dungen.map.extensions.FloodFill;
using dropecho.dungen.map.Map2dExtensions;
using dropecho.dungen.map.extensions.Neighbors;

@:expose("dungen.RegionManager")
class RegionManager {
	/**
	 * Remove islands by finding them and if they are below the passed size, fill them with walls. 
	 *
	 * @param map - The map to remove islands from.
	 * @param [size] - The minimum size of the filled tile region.
	 * @param [tileType] - The type of tile to find and fill islands of. 
	 * @return The cleaned map. 
	 */
	public static function removeIslandsBySize(map:Map2d, size:Int = 4, tileType:Int = 1):Map2d {
		var cleanedMap = new Map2d(map._width, map._height);
		var nextTile:Tile2d;
		var visited = new Array<Tile2d>();

		for (i in 0...map._mapData.length) {
			cleanedMap._mapData[i] = map._mapData[i];
		}

		while ((nextTile = cleanedMap.getFirstTileOfType(tileType, visited)) != null) {
			var tiles = cleanedMap.floodFill(nextTile.x, nextTile.y, tileType);
			var isIsland = tiles.length <= size;

			if (isIsland) {
				visited.push(nextTile);
			}

			// for (t in tiles) {
			//   if (map.getNeighborCount(t.x, t.y, tileType) + map.getNeighborCount(t.x, t.y, 0) != 8) {
			//     isIsland = false;
			//     break;
			//   }
			// }

			for (t in tiles) {
				if (isIsland) {
					cleanedMap.set(t.x, t.y, 0);
				} else {
					visited.push(t);
				}
			}
		}

		return cleanedMap;
	}

	/**
	 * Remove islands by finding if they do not connect to any tiles other 
	 * than the same type or walls (0).
	 *
	 * @param map - The map to remove islands from.
	 * @param [tileType] - The tile type to find and fill islands of.
	 * @return The cleaned map.
	 */
	public static function removeIslands(map:Map2d, tileType:Int = 1):Map2d {
		var nextTile:Tile2d;
		var visited = new Array<Tile2d>();

		var cleanedMap = new Map2d(map._width, map._height);
		for (i in 0...map._mapData.length) {
			cleanedMap._mapData[i] = map._mapData[i];
		}

		while ((nextTile = cleanedMap.getFirstTileOfType(tileType, visited)) != null) {
			visited.push(nextTile);
			var tiles = cleanedMap.floodFill(nextTile.x, nextTile.y, tileType);
			var isIsland = true;

			for (t in tiles) {
				if (map.getNeighborCount(t.x, t.y, tileType) + map.getNeighborCount(t.x, t.y, 0) != 8) {
					isIsland = false;
					break;
				}
			}

			if (isIsland) {
				for (t in tiles) {
					cleanedMap.set(t.x, t.y, 0);
				}
			}
		}

		return cleanedMap;
	}

	public static function findAndTagBorders(map:Map2d, borderType:Int = 1, startTag:Int = 2):Map2d {
		var borderMap = new Map2d(map._width, map._height);

		for (i in 0...map._mapData.length) {
			borderMap._mapData[i] = map._mapData[i] != borderType ? 0 : 1;
		}

		var nextBorder:Tile2d;
		var nextTag = startTag;

		while ((nextBorder = borderMap.getFirstTileOfType(borderType)) != null) {
			for (t in borderMap.floodFill(nextBorder.x, nextBorder.y, borderType)) {
				borderMap.set(t.x, t.y, nextTag);
			}

			nextTag++;
		}

		return borderMap;
	}

	public static function findAndTagRegions(map:Map2d, ?depth:Int = 2):Map2d {
		var regionmap = new Map2d(map._width, map._height, 0);
		for (i in 0...map._mapData.length) {
			var val = map._mapData[i] > depth ? depth : map._mapData[i];
			regionmap._mapData[i] = val;
		}

		var nextRegion:Tile2d;
		var nextTag = depth + 1;

		while ((nextRegion = regionmap.getFirstTileOfType(depth)) != null) {
			for (t in regionmap.floodFill(nextRegion.x, nextRegion.y, depth)) {
				regionmap.set(t.x, t.y, nextTag);
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
