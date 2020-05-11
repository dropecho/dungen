package dropecho.dungen.map.helpers;

import dropecho.dungen.Map2d;
import dropecho.dungen.map.MapHelper;

class RegionManager {
	public static function findAndTagRegions(map:Map2d, depth:Int = 2) {
		var regionmap = new Map2d(map._width, map._height, 0);
		for (i in 0...map._mapData.length) {
			regionmap._mapData[i] = map._mapData[i] > depth ? depth : map._mapData[i];
		}

		var nextRegion:Tile2d;
		var nextTag = 3;

		while ((nextRegion = MapHelper.getFirstTileOfType(regionmap, 2)) != null) {
			var tilesToFill = MapHelper.floodFill(regionmap, nextRegion.x, nextRegion.y, depth);

			for (t in tilesToFill) {
				regionmap.set(t.x, t.y, nextTag);
			}

			// no neighbors to fill, single tile region
			if (tilesToFill.length == 1) {
				regionmap.set(nextRegion.x, nextRegion.y, 1);
			}

			nextTag++;
		}

		for (x in 0...map._width) {
			for (y in 0...map._width) {
				if (regionmap.get(x, y) == 1) {
					var openCount = regionmap.getNeighborCount(x, y, 1, 1);
					var wallCount2 = regionmap.getNeighborCount(x, y, 0, 2);
					var openCount2 = regionmap.getNeighborCount(x, y, 1, 2);
					if (openCount == 7 && openCount2 + wallCount2 == 8 + 16) {
						regionmap.set(x, y, nextTag++);
					}
				}
			}
		}

		return regionmap;
	}

	public static function expandRegions(map:Map2d, startTag:Int = 3) {
		for (_ in 0...100) {
			for (currentTag in startTag...startTag + 500) {
				var tilesToPaint = new Array<Int>();
				for (x in 0...map._width) {
					for (y in 0...map._height) {
						if (map.get(x, y) == currentTag) {
							var neighbors = map.getNeighbors(x, y, 1, true);
							for (n in neighbors) {
								if (n.val == 1) {
									var nWalls = map.getNeighborCount(n.x, n.y, 0, 1, true);
									var nOpen = map.getNeighborCount(n.x, n.y, 1, 1, true);
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
} // for (currentTag in startTag...startTag + 100) {
//   for (x in 0...map._width) {
//     for (y in 0...map._height) {
//       if (map.get(x, y) == currentTag) {
//         // get neighbors that are not tag, and have no other tags next to them.
//
//         var neighbors = map.getNeighbors(x, y, 1, true);
//
//         for (n in neighbors) {
//           if (n.val == currentTag) {
//             continue;
//           }
//           if (n.val == 1) {
//             var nWalls = map.getNeighborCount(n.x, n.y, 0, 2, true);
//             var nOpen = map.getNeighborCount(n.x, n.y, 1, 2, true);
//             var nTag = map.getNeighborCount(n.x, n.y, currentTag, 2, true);
//             // if (nWalls + nOpen + nTag == (8 + 1) * pass) {
//             if (nWalls + nOpen + nTag == 8 + 16) {
//               map.set(n.x, n.y, currentTag);
//             }
//           }
//         }
//       }
//     }
//   }
// }
// var changes = 1;
// while (changes > 0) {
//   changes = 0;
//   for (c in startTag...100) {
//     var currentTag = (99 + startTag) - c;
//     for (x in 0...map._width) {
//       for (y in 0...map._height) {
//         if (map.get(x, y) == currentTag) {
//           // get neighbors that are not tag, and have no other tags next to them.
//           var tagCount = map.getNeighborCount(x, y, currentTag, 1, true);
//           if (tagCount == 0) {
//             map.set(x, y, 1);
//             changes++;
//             continue;
//           }
//
//           var neighbors = map.getNeighbors(x, y, 1, true);
//
//           for (n in neighbors) {
//             if (n.val == currentTag) {
//               continue;
//             }
//             if (n.val == 1) {
//               var nWalls = map.getNeighborCount(n.x, n.y, 0, 1, true);
//               var nOpen = map.getNeighborCount(n.x, n.y, 1, 1, true);
//               var nTag = map.getNeighborCount(n.x, n.y, currentTag, 1, true);
//               if (nWalls + nOpen + nTag == 8) {
//                 map.set(n.x, n.y, currentTag);
//                 changes++;
//               }
//             }
//           }
//         }
//       }
//     }
//   }
// }
//
