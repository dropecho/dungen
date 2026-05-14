package dropecho.dungen.regions;

import dropecho.interop.AbstractMap;
import dropecho.ds.Graph;
import dropecho.ds.GraphNode;
import dropecho.dungen.Tile2d;

using Lambda;

@:expose("dungen.Region")
@:struct
@:nativeGen
class Region {
	public var id:Int;
	public var tiles:Array<Tile2d> = new Array<Tile2d>();

	public function new(id:Int) {
		this.id = id;
		this.tiles = new Array<Tile2d>();
	}
}

@:expose("dungen.RegionMap")
@:nativeGen
class RegionMap extends Map2d {
	public var regions:AbstractMap<Int, Region> = new AbstractMap<Int, Region>();
	public var borders:AbstractMap<Int, Region> = new AbstractMap<Int, Region>();

	public var graph:Graph<Region, Region> = new Graph<Region, Region>();

	public function new(map:Map2d, depth:Int = 2, expand:Bool = true) {
		super(map._width, map._height, 0);

		var regionMap = map.clone();
		// TODO: Allow options passed for island size min/max/removal?
		// regionmap = regionmap.removeIslandsBySize(256);

		regionMap = regionMap.distanceFill(0);
		regionMap = regionMap.findAndTagRegions(depth);
		//     trace(regionmap.toString());

		//     if (expand) {
		//       regionMap = regionMap.expandRegions(depth);
		//     } else if (depth > 1) {
		for (_ in 0...depth + 1) {
			regionMap = regionMap.expandRegionsByOne(depth);
		}

		//     regionMap = regionMap.fillAlcoves(depth);
		//       regionMap = regionMap.expandRegionsByOne(depth);
		//     }

		buildRegions(regionMap, depth);
		buildBorders(RegionManager.findAndTagBorders(regionMap, 1, 128));
		buildGraph();
	}

	private function buildGraph() {
		// Add all regions as nodes.
		for (region in regions) {
			graph.addNode(new GraphNode<Region, Region>(region, cast region.id));
		}

		// Find all regions touching each border, create edges between those.
		for (border in borders) {
			var borderRegions = new Array<Region>();

			for (tile in border.tiles) {
				var neighbors = this.getNeighbors(tile.x, tile.y);
				for (n in neighbors) {
					if (regions.exists(n.val)) {
						var region = regions.get(n.val);
						if (!borderRegions.has(region)) {
							borderRegions.push(region);
						}
					}
				}
			}

			for (region in borderRegions) {
				for (region2 in borderRegions) {
					if (region.id == region2.id) {
						continue;
					}
					graph.addUniEdge(cast region.id, cast region2.id, border);
				}
			}
		}
	}

	private function buildRegions(regionmap:Map2d, depth:Int = 2) {
		for (tile in 0...regionmap._mapData.length) {
			var regionTileId = regionmap._mapData[tile];
			var isRegion = regionTileId > depth;
			_mapData[tile] = regionmap._mapData[tile];

			if (isRegion) {
				var region;

				if (regions.exists(regionTileId) == false) {
					region = new Region(regionTileId);
					regions.set(region.id, region);
				} else {
					region = regions.get(regionTileId);
				}

				region.tiles.push(regionmap.indexToXY(tile));
			}
		}
	}

	private function buildBorders(bordermap:Map2d) {
		for (tile in 0...bordermap._mapData.length) {
			var borderTile = bordermap._mapData[tile];
			var isBorder = borderTile != 0;
			_mapData[tile] = isBorder ? borderTile : _mapData[tile];

			if (isBorder) {
				var border;

				if (borders.exists(borderTile) == false) {
					border = new Region(borderTile);
					borders.set(border.id, border);
				} else {
					border = borders.get(borderTile);
				}
				var tileData = bordermap.indexToXY(tile);
				border.tiles.push(tileData);
			}
		}
	}

	@ignoreInstrument
	public function toStringSingleRegion(regionId:Int) {
		var chars = new Array<String>();
		for (i in 0...255) {
			chars[i] = i - 1 == regionId ? '.' : ' ';
		}

		return toPrettyString(chars);
	}

	@ignoreInstrument
	public function toRegionBorderIdString() {
		var output = "\n MAP2d: \n\n";

		for (y in 0..._height) {
			for (x in 0..._width) {
				var val = _mapData[XYtoIndex(x, y)];

				if (regions.exists(val)) {
					var tiles = regions
						.get(val)
						.tiles;

					for (i in 0...tiles.length) {
						if (tiles[i].x == x && tiles[i].y == y) {
							output += val;
						}
					}
				} else if (borders.exists(val)) {
					var tiles = borders
						.get(val)
						.tiles;

					for (tile in tiles) {
						if (tile.x == x && tile.y == y) {
							output += (val - 127);
						}
					}
				} else {
					output += val == 0 ? '.' : cast val;
				}
			}
			output += "\n";
		}

		return output;
	}

	@ignoreInstrument
	public function toRegionBorderString() {
		var output = "\n MAP2d: \n\n";

		for (y in 0..._height) {
			for (x in 0..._width) {
				var isBorder = false;
				var isRegion = false;

				var val = _mapData[XYtoIndex(x, y)];

				if (regions.exists(val)) {
					var tiles = regions
						.get(val)
						.tiles;

					for (i in 0...tiles.length) {
						if (tiles[i].x == x && tiles[i].y == y) {
							isRegion = true;
						}
					}
				}
				if (borders.exists(val)) {
					var tiles = borders
						.get(val)
						.tiles;

					for (tile in tiles) {
						if (tile.x == x && tile.y == y) {
							isBorder = true;
						}
					}
				}

				output += isBorder ? 'b' : isRegion ? 'r' : '.';
			}
			output += "\n";
		}

		return output;
	}
}
