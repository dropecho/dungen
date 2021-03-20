package dropecho.dungen;

import dropecho.ds.GraphNode;
import dropecho.ds.Graph;
import dropecho.dungen.Map2d.Tile2d;
import dropecho.interop.AbstractMap;

import dropecho.ds.graph.Traversal;
import dropecho.ds.graph.Search;

using Lambda;
using dropecho.dungen.map.Map2dExtensions;
using dropecho.dungen.map.extensions.DistanceFill;
using dropecho.dungen.map.extensions.RegionManager;
using dropecho.dungen.map.extensions.Neighbors;

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
	#if cs
	public var regions:AbstractMap<Int, Region> = new AbstractMap<Int, Region>();
	public var borders:AbstractMap<Int, Region> = new AbstractMap<Int, Region>();
	#else
	public var regions:Map<Int, Region> = new Map<Int, Region>();
	public var borders:Map<Int, Region> = new Map<Int, Region>();
	#end

	public var graph:Graph<Region, Region> = new Graph<Region, Region>();

	public function new(map:Map2d, depth:Int = 2, expand:Bool = true) {
		super(map._width, map._height, 0);

		var regionmap = map.clone();
		// TODO: Allow options passed for island size min/max/removal?
		// regionmap = regionmap.removeIslandsBySize(256);

		regionmap = regionmap.distanceFill(0, false);
		regionmap = regionmap.findAndTagRegions(depth);
		if (expand) {
			regionmap = regionmap.expandRegions(depth + 1);
		} else {
			if (depth > 1) {
				regionmap = regionmap.expandRegionsByOne(depth);
			}
		}

		buildRegions(regionmap, depth);
		buildBorders(RegionManager.findAndTagBorders(regionmap, 1, 128));
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

				region.tiles.push(regionmap.IndexToXY(tile));
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
				var tileData = bordermap.IndexToXY(tile);
				border.tiles.push(tileData);
			}
		}
	}

	public function toStringSingleRegion(regionId:Int) {
		var chars = new Array<String>();
		for (i in 0...255) {
			chars[i] = i - 1 == regionId ? '.' : ' ';
		}

		return toPrettyString(chars);
	}

	public function toRegionBorderIdString() {
		var output = "\n MAP2d: \n\n";

		for (y in 0..._height) {
			for (x in 0..._width) {
				var val = _mapData[XYtoIndex(x, y)];

				if (regions.exists(val)) {
					var tiles = regions.get(val).tiles;
					for (i in 0...tiles.length) {
						if (tiles[i].x == x && tiles[i].y == y) {
							output += val;
						}
					}
				} else if (borders.exists(val)) {
					for (tile in borders.get(val).tiles) {
						if (tile.x == x && tile.y == y) {
							output += (val - 127);
						}
					}
				} else {
					output += val == 0 ? ' ' : cast val;
				}
			}
			output += "\n";
		}

		return output;
	}

	public function toRegionBorderString() {
		var output = "\n MAP2d: \n\n";

		for (y in 0..._height) {
			for (x in 0..._width) {
				var isBorder = false;
				var isRegion = false;

				var val = _mapData[XYtoIndex(x, y)];

				if (regions.exists(val)) {
					var tiles = regions.get(val).tiles;
					for (i in 0...tiles.length) {
						if (tiles[i].x == x && tiles[i].y == y) {
							isRegion = true;
						}
					}
				}
				if (borders.exists(val)) {
					for (tile in borders.get(val).tiles) {
						if (tile.x == x && tile.y == y) {
							isBorder = true;
						}
					}
				}

				// output += isBorder ? '1' : '0';
				output += isBorder ? 'b' : isRegion ? 'r' : ' ';
				// output += val;
			}
			output += "\n";
		}

		return output;
	}
}
