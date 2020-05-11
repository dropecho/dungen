package dropecho.dungen.map;

import dropecho.dungen.Map2d;
import haxe.ds.IntMap;
import dropecho.dungen.map.Pattern.RegionPatterns;

using Lambda;

class MapHelper {
	public static function isMapConnected(map:Map2d, tile:Int = 0, diagonal:Bool = true):Bool {
		var start = getFirstEmptyTile(map, tile);
		var filled = floodFill(map, start.x, start.y, tile, diagonal);

		return getFirstEmptyTile(map, tile, filled) == null;
	}

	public static function getFirstEmptyTile(map:Map2d, tile:Int = 0, ignore:Array<Tile2d> = null):Tile2d {
		for (i in 0...map._height * map._width) {
			if (map._mapData[i] == tile) {
				var cur = map.IndexToXY(i);

				if (ignore != null) {
					var foo = ignore.find(function(tile) {
						return tile.x == cur.x && tile.y == cur.y;
					});

					if (foo != null) {
						continue;
					}
				}

				return cur;
			}
		}

		return null;
	}

	public static function floodFill(map:Map2d, startX:Int, startY:Int, tile:Int = 0, diagonal:Bool = true):Array<Tile2d> {
		var closed = new IntMap<Tile2d>();
		var open = new Array<Tile2d>();
		var neighbors = new Array<Tile2d>();

		var currentTile = map.IndexToXY(map.XYtoIndex(startX, startY));
		open.push(currentTile);

		function whereHasNotBeenVisited(tile) {
			return closed.get(map.XYtoIndex(tile.x, tile.y)) == null;
		}

		function whereTileIsSameType(t) {
			return map.get(t.x, t.y) == tile;
		}

		while (open.length > 0) {
			currentTile = open.pop();
			closed.set(map.XYtoIndex(currentTile.x, currentTile.y), currentTile);

			neighbors = map.getNeighbors(currentTile.x, currentTile.y, 1, diagonal).filter(whereHasNotBeenVisited).filter(whereTileIsSameType);

			open = open.concat(neighbors);
		}

		return closed.array();
	}

	public static function distanceFill(map:Map2d, tile:Int = 0, diagonal:Bool = true, maxDepth:Int = 40) {
		var distanceMap = new Map2d(map._width, map._height);
		for (i in 0...map._mapData.length) {
			distanceMap._mapData[i] = map._mapData[i] == tile ? tile : 999;
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

	public static function expandRegions(map:Map2d, tile:Int = 2) {
		var regionmap = new Map2d(map._width, map._height, 0);
		for (i in 0...map._mapData.length) {
			regionmap._mapData[i] = map._mapData[i];
		}

		var changes = 1;

		while (changes > 0) {
			changes = 0;
			for (x in 0...regionmap._width) {
				for (y in 0...regionmap._height) {
					if (map.get(x, y) >= tile) {
						regionmap.set(x, y, tile);
						var neighbors = map.getNeighbors(x, y, 1);

						for (n in neighbors) {
							var nVal = regionmap.get(n.x, n.y);
							if (nVal != 0 && nVal != tile) {
								regionmap.set(n.x, n.y, tile);
								changes++;
							}
						}
					}
				}
			}
		}

		changes = 1;

		RegionPatterns.init();

		while (changes > 0) {
			changes = 0;
			for (x in 0...regionmap._width) {
				for (y in 0...regionmap._height) {
					var v = regionmap.get(x, y);
					if (v == 1) {
						for (pattern in RegionPatterns.patterns) {
							if (pattern.matches(regionmap, x, y)) {
								regionmap.set(x, y, 2);
								changes++;
							}
						}
					}
				}
			}
		}

		return regionmap;
	}

	// public static function getHallwayTiles(map:Map2d, tile:Int):Array<Tile2d> {
	//   var hallwayTiles = new Array<Tile2d>();
	//
	//   for (i in 0...map._height) {
	//     for (j in 0...map._width) {
	//       if (map._mapData[map.XYtoIndex(i, j)] != tile) {
	//         continue;
	//       }
	//
	//       var c = map.getNeighborCount(i, j, tile, 2);
	//       if (c < (2 * 4)) {}
	//     }
	//   }
	//
	//   return hallwayTiles;
	// }
}
// var lVal = regionmap.get(x - 1, y);
// var lBlocked = lVal != tile;
// var rVal = regionmap.get(x + 1, y);
// var rBlocked = rVal != tile;
// var nVal = regionmap.get(x, y - 1);
// var nBlocked = nVal != tile;
// var sVal = regionmap.get(x, y + 1);
// var sBlocked = sVal != tile;
//
// var openTop = (lBlocked && rBlocked) && (!nBlocked);
// var openSide = (nBlocked && sBlocked) && (!lBlocked);
// var openCount = regionmap.getNeighborCount(x, y, tile, 1, false);
// var chokecount = regionmap.getNeighborCount(x, y, 1, 1, false);
// var wallcount = regionmap.getNeighborCount(x, y, 0, 1, false);
//
// if ((openTop && !sBlocked) || (openSide && !rBlocked)) {
//   continue;
// }
//
// [>
//   0,0,0
//   2,X,2
//   2,2,2
//  */
// var alone = openCount == 3;
//
// [>
//   0,0,0
//   1,X,2
//   0,2,2
//  */
// var opendiag = (openCount == 2 && chokecount == 1);
//
// [>
//   0,0,2
//   0,X,2
//   0,1,2
//  */
// var corner = wallcount == 2 && chokecount == 1 && openCount == 1;
//
// if (openTop || openSide || alone || opendiag || corner) {
//   expanded.push(regionmap.XYtoIndex(x, y));
//   changes++;
// }
// var wallCount = regionmap.getNeighborCount(x, y, 0, 1, false);
// var wallCountAll = regionmap.getNeighborCount(x, y, 0, 1);
// var openCount = regionmap.getNeighborCount(x, y, tile, 1, false);
// var openCountAll = regionmap.getNeighborCount(x, y, tile, 1);
// var borderCount = regionmap.getNeighborCount(x, y, 1, 1, false);
// var borderCountAll = regionmap.getNeighborCount(x, y, 1, 1);
//
// var nVal = regionmap.get(x, y - 1);
// var sVal = regionmap.get(x, y + 1);
// var eVal = regionmap.get(x - 1, y);
// var wVal = regionmap.get(x + 1, y);
//
// var wallsHoriz = wVal == 0 && eVal == 0;
// var wallsVert = nVal == 0 && sVal == 0;
//
// var splitVert = nVal != tile && sVal != tile;
// var splitHoriz = wVal != tile && eVal != tile;
//
// var r1 = wallCount == 3 && openCount == 1;
// var r2 = wallCount == 1 && borderCount == 3;
// var r3 = openCount == 3 && borderCount == 1 && !splitVert && !splitHoriz;
// var r4 = openCount == 3 && wallCount == 1;
// var r5 = wallCount == 3 && borderCount == 1;
// var r6 = wallCountAll == 4 && openCountAll == 4 && !wallsHoriz && !wallsVert && false;
//
// var r7 = !splitVert && !splitHoriz && openCount == 2 && false;
//
// // surrounded by border except one.
// // var r2 = regionmap.getNeighborCount(x, y, 1, 1) == 3 && regionmap.getNeighborCount(x, y, 1, 1) == 1;
//
// if (r1 || r2 || r3 || r4 || r5 || r6 || r7) {
//   expanded.push(regionmap.XYtoIndex(x, y));
//   changes++;
// }
//
// if (splitVert && !splitHoriz && borderCount == 2) {
//   regionmap.set(x, y, tile);
//   regionmap.set(x, y + 1, tile);
// }
//
// if (splitHoriz && !splitVert && borderCount == 2) {
//   regionmap.set(x, y, tile);
//   regionmap.set(x + 1, y, tile);
// }
//
// if (!splitHoriz && !splitVert && wallCount == 2) {
//   regionmap.set(x, y, tile);
// }
