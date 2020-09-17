package dropecho.dungen;

using Lambda;

typedef Tile2d = {
	x:Int,
	y:Int,
	onMap:Bool,
	?val:Int
}

@:expose("dungen.Map2d")
class Map2d {
	public var _width:Int = 0;
	public var _height:Int = 0;
	public var _mapData:Array<Int>;

	public function new(width:Int, height:Int, initTileData:Int = 0) {
		_width = width;
		_height = height;
		_mapData = new Array<Int>();
		this.initializeData(initTileData);
	}

	private function initializeData(initTileData:Int):Void {
		if (initTileData == -1) {
			return;
		}

		for (i in 0..._height * _width) {
			_mapData[i] = initTileData;
		}
	}

	public function ensureEdgesAreWalls(tileType:Int = 0) {
		for (x in 0..._width) {
			_mapData[XYtoIndex(x, 0)] = tileType;
			_mapData[XYtoIndex(x, _height - 1)] = tileType;
		}

		for (y in 0..._height) {
			_mapData[XYtoIndex(0, y)] = tileType;
			_mapData[XYtoIndex(_width - 1, y)] = tileType;
		}
	}

	/**
	 * Get count of neighbors within distance matching neighborType.
	 *
	 * @param {Int} x - The x position of the tile.
	 * @param {Int} y - The y position of the tile.
	 * @param {Int} neighborType - The integer representing the type of tile to find.
	 * @param {Int} [dist] - The distance to search within.
	 * @return {Int} The count of matching neighbors.
	 */
	public function getNeighborCount(x:Int, y:Int, neighborType:Int, dist:Int = 1, diagonal:Bool = true):Int {
		function isNeighborType(tile) {
			return get(tile.x, tile.y) == neighborType;
		}

		return getNeighbors(x, y, dist, diagonal).count(isNeighborType);
	}

	public function getNeighbors(x:Int, y:Int, dist:Int = 1, diagonal:Bool = true):Array<Tile2d> {
		var neighbors = new Array<Tile2d>(),
			isSelf = false,
			isNotOnMap = false;

		for (i in -dist...dist + 1) {
			for (j in -dist...dist + 1) {
				isSelf = (i == 0 && j == 0);
				isNotOnMap = x + i < 0 || x + i >= (_width) || y + j < 0 || y + j >= (_height);

				if (isSelf || isNotOnMap) {
					continue;
				}

				if (!diagonal && ((i == j) || (i == -dist && j == dist) || (j == -dist && i == dist))) {
					continue;
				}

				var val = get(x + i, y + j);

				neighbors.push({
					x: x + i,
					y: y + j,
					onMap: true,
					val: val
				});
			}
		}

		return neighbors;
	}

	inline public function XYtoIndex(x:Int, y:Int):Int {
		return (_width * y) + x;
	}

	public function IndexToXY(index:Int):Tile2d {
		var x = Std.int(index % _width), y = Std.int(index / _width);

		return {
			x: x,
			y: y,
			onMap: x >= 0 && y >= 0 && x < _width && y < _height
		}
	}

	inline public function set(x:Int, y:Int, data:Int):Void {
		_mapData[XYtoIndex(x, y)] = data;
	}

	public function setRect(x:Int, y:Int, x2:Int, y2:Int, data:Int):Void {
		for (i in x...x2) {
			for (j in y...y2) {
				this.set(i, j, data);
			}
		}
	}

	public function splat(other:Map2d, x:Int, y:Int, ignoreTile:Int = -1) {
		for (i in 0...other._width) {
			for (j in 0...other._height) {
				var otherTile = other.get(i, j);
				if (otherTile != ignoreTile) {
					this.set(i + x, j + y, otherTile);
				}
			}
		}
	}

	inline public function get(x:Int, y:Int):Int {
		return _mapData[XYtoIndex(x, y)];
	}

	public function getRect(x:Int, y:Int, x2:Int, y2:Int, wrap:Bool = false):Array<Int> {
		return [
			for (j in y...y2 + 1) {
				for (i in x...x2 + 1) {
					if (wrap) {
						this.get(i % _width, j % _height);
					} else {
						this.get(i, j);
					}
				}
			}
		];
	}

	public function toPrettyString(char:Array<String> = null) {
		if (char == null) {
			char = ["#", "."];
		}
		var output = "\n MAP2d: \n\n";

		for (y in 0..._height) {
			for (x in 0..._width) {
				output += char[_mapData[XYtoIndex(x, y)]];
			}

			output += "\n";
		}

		return output;
	}

	public function toString(ascii:Bool = false):String {
		var output = "\n MAP2d: \n\n";

		for (y in 0..._height) {
			for (x in 0..._width) {
				var val = _mapData[XYtoIndex(x, y)];
				output += val;
			}
			output += "\n";
		}

		return output;
	}
}
