package dropecho.dungen.regions;

import dropecho.dungen.Map2d;
import dropecho.ds.Set;

using Lambda;

class RegionManager {
	/**
	 * Remove islands by finding them and if they are below the passed size, fill them with walls. 
	 *
	 * @param map - The map to remove islands from.
	 * @param [size] - The minimum size of the filled tile region.
	 * @param [tileType] - The type of tile to find and fill islands of. 
	 * @return The cleaned map. 
	 */
	static public function removeIslandsBySize(map:Map2d, size:Int = 4, tileType:Int = 1):Map2d {
		var cleanedMap = new Map2d(map._width, map._height);
		var nextTile:Tile2d;
		var visited = new Set<Tile2d>(t -> cleanedMap.XYtoIndex(t.x, t.y));

		for (i in 0...map._mapData.length) {
			cleanedMap._mapData[i] = map._mapData[i];
		}

		while ((nextTile = cleanedMap.getFirstTileOfTypeSet(tileType, visited)) != null) {
			var tiles = cleanedMap.floodFill(nextTile.x, nextTile.y, tileType);
			var isIsland = tiles.size() <= size;

			if (isIsland) {
				visited.add(nextTile);
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
					visited.add(t);
				}
			}
		}

		return cleanedMap;
	}

	/**
	 * Remove islands by finding if they do not connect to any tiles other than the same type or walls (0).
	 *
	 * @param map - The map to remove islands from.
	 * @param [tileType] - The tile type to find and fill islands of.
	 * @return The cleaned map.
	 */
	static public function removeIslands(map:Map2d, tileType:Int = 1):Map2d {
		var nextTile:Tile2d;
		var visited = new Set<Tile2d>(t -> map.XYtoIndex(t.x, t.y));

		var cleanedMap = new Map2d(map._width, map._height);
		for (i in 0...map._mapData.length) {
			cleanedMap._mapData[i] = map._mapData[i];
		}

		while ((nextTile = cleanedMap.getFirstTileOfTypeSet(tileType, visited)) != null) {
			visited.add(nextTile);
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

	static public function findAndTagBorders(
		map:Map2d,
		borderType:Int = 1,
		startTag:Int = 2
	):Map2d {
		var borderMap = new Map2d(map._width, map._height);

		for (tile in map) {
			var value = tile.val == borderType ? 1 : 0;
			borderMap.set(tile.x, tile.y, value);
		}

		var nextTag = startTag;
		var nextBorder = borderMap.getFirstTileOfType(borderType);

		while (nextBorder != null) {
			for (t in borderMap.floodFill(nextBorder.x, nextBorder.y, borderType)) {
				borderMap.set(t.x, t.y, nextTag);
			}
			nextTag++;
			nextBorder = borderMap.getFirstTileOfType(borderType);
		}

		return borderMap;
	}

	static public function findAndTagRegions(map:Map2d, ?depth:Int = 2):Map2d {
		var regionmap = map.clone();

		for (tile in regionmap) {
			var val = tile.val >= depth ? depth : tile.val;
			regionmap.set(tile.x, tile.y, val);
		}

		var nextTag = depth;
		var nextRegion = regionmap.getFirstTileOfType(depth);

		while (nextRegion != null) {
			for (tile in regionmap.floodFill(nextRegion.x, nextRegion.y, depth)) {
				regionmap.set(tile.x, tile.y, nextTag);
			}

			nextTag++;
			nextRegion = regionmap.getFirstTileOfType(depth);
		}

		return regionmap;
	}

	/**
	 * Raises the min 'depth' by one, simulating water rising.
	 *
	 * @param map The map to expand regions for.
	 * @param startTag The lowest value for a region tag/id.
	 * @returns The new expanded map.
	 */
	static public function raiseLevel(map:Map2d, startTag:Int) {
		var expandedMap = map.clone();

		for (tile in map) {
			if (tile.val < startTag && tile.val != 0) {
				expandedMap.set(tile.x, tile.y, tile.val + 1);
			}
		}

		return expandedMap;
	}

	/**
	 * @param map The map to expand regions for.
	 * @param startTag The lowest value for a region tag/id.
	 * @returns The new expanded map.
	 */
	static public function expandRegionsByOne(map:Map2d, startTag:Int) {
		var expandedMap = map.clone();
		var emptyTag = startTag - 1;
		var wallTag = 0;

		for (regionTile in map) {
			if (regionTile.val < startTag) {
				continue;
			}

			var neighbors = expandedMap
				.getNeighbors(regionTile.x, regionTile.y)
				.filter(t -> t.val == emptyTag);

			for (n in neighbors) {
				var nn = expandedMap.getNeighbors(n.x, n.y, 1, false);

				var otherRegionsTouched = nn
					.filter(t -> t.val >= startTag && t.val != regionTile.val)
					.length;

				var open = nn
					.filter(t -> t.val == emptyTag)
					.length;

				var walls = nn
					.filter(t -> t.val == wallTag)
					.length;

				// if at border of two regions.
				if (otherRegionsTouched > 0) {
					continue;
				}

				// if corridor
				if (walls >= 2 && open >= 1) {
					continue;
				}

				expandedMap.set(n.x, n.y, regionTile.val);
			}
		}

		return raiseLevel(expandedMap, startTag - 1);
	}

	static public function fillAlcoves(map:Map2d, startTag:Int) {
		var expandedMap = map.clone();

		var visited = new Set<Tile2d>((tile) -> expandedMap.XYtoIndex(tile.x, tile.y));
		var first = expandedMap.getFirstTileOfTypeSet(startTag - 1, visited);

		while (first != null) {
			var fill = expandedMap.floodFill(first.x, first.y, startTag - 1, true);

			var allneighbors = new Array<Tile2d>();

			for (tile in fill) {
				allneighbors = allneighbors.concat(expandedMap.getNeighbors(tile.x, tile.y));
				visited.add(tile);
			}

			var regions = allneighbors.filter(t -> t.val >= startTag);
			if (regions.length > 0) {
				var single = regions.find(t -> t.val != regions[0].val) == null;
				if (single) {
					for (tile in fill) {
						expandedMap.set(tile.x, tile.y, regions[0].val);
					}
				}
			} else {
				for (tile in fill) {
					expandedMap.set(tile.x, tile.y, 0);
				}
			}

			first = expandedMap.getFirstTileOfTypeSet(startTag - 1, visited);
		}

		return expandedMap;
	}

	static public function expandRegions(map:Map2d, startTag:Int = 3, eatWalls = false) {
		var expandedMap = map.clone();

		for (_ in 0...100) {
			for (currentTag in startTag...startTag + 500) {
				var tilesToPaint = new Array<Int>();
				for (tile in expandedMap) {
					if (tile.val != currentTag) {
						continue;
					}

					for (neighbor in expandedMap.getNeighbors(tile.x, tile.y)) {
						if (neighbor.val > startTag) {
							continue;
						}
						if (!eatWalls && neighbor.val == 0) {
							continue;
						}
						var nWalls = expandedMap.getNeighborCount(neighbor.x, neighbor.y, 0);
						var nOpen = 0;
						for (i in 1...startTag) {
							nOpen += expandedMap.getNeighborCount(neighbor.x, neighbor.y, i);
						}
						var nTag = expandedMap.getNeighborCount(neighbor.x, neighbor.y, currentTag);
						if (nWalls + nOpen + nTag == 8) {
							tilesToPaint.push(expandedMap.XYtoIndex(neighbor.x, neighbor.y));
						}
					}
				}

				for (index in tilesToPaint) {
					expandedMap._mapData[index] = currentTag;
				}
			}
		}
		return expandedMap;
	}
}
