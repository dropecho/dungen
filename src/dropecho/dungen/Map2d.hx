package dropecho.dungen;

@:expose("dungen.Tile2d")
@:struct
class Tile2d {
	public var x:Int;
	public var y:Int;
	public var val:Int;

	public function new(x:Int, y:Int, ?val:Int) {
		this.x = x;
		this.y = y;
		this.val = val;
	};
}

@:expose("dungen.Map2d")
@:nativeGen
@:using(dropecho.dungen.map.Map2dExtensions)
@:using(dropecho.dungen.map.extensions.CheckConnectivity)
@:using(dropecho.dungen.map.extensions.DistanceFill)
@:using(dropecho.dungen.map.extensions.FindAndReplace)
@:using(dropecho.dungen.map.extensions.FloodFill)
@:using(dropecho.dungen.map.extensions.GetFirstTileOfType)
@:using(dropecho.dungen.map.extensions.Neighbors)
@:using(dropecho.dungen.map.extensions.RegionFill)
@:using(dropecho.dungen.map.extensions.RegionManager)
@:using(dropecho.dungen.map.extensions.Splat)
@:using(dropecho.dungen.map.extensions.Utils)
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

		var length:Int = _height * _width;

		for (i in 0...length) {
			_mapData[i] = initTileData;
		}
	}

	/**
	 * Returns the array index representing the x,y coord of a tile.
	 *
	 * @param x The x coord to get the index for.
	 * @param y The y coord to get the index for.
	 * @return The index of the x,y coord.
	 */
	inline public function XYtoIndex(x:Int, y:Int):Int {
		return (_width * y) + x;
	}

	/**
	 * Return a Tile2d ({x,y} object), for the given array index.
	 * @param index The index to change into an x,y position.
	 * @return The object with the x,y coords.
	 */
	public inline function IndexToXY(index:Int):Tile2d {
		var x = Std.int(index % _width);
		var y = Std.int(index / _width);
		return new Tile2d(x, y);
	}

	/**
	 * Set an individual tile, by the x,y coord.
	 * @param x - The x coord of the tile to set.
	 * @param y - The y coord of the tile to set.
	 * @param data - The value to set as the tile.
	 */
	inline public function set(x:Int, y:Int, data:Int):Void {
		var index = XYtoIndex(x, y);
		// if (index < _mapData.length) {
		_mapData[index] = data;
		// }
	}

	/**
	 * Get the value of a tile by the x,y coord.
	 * @param x - The x coord of the tile to get.
	 * @param y - The y coord of the tile to get.
	 * @return The value of the tile at x,y.
	 */
	inline public function get(x:Int, y:Int):Int {
		return _mapData[XYtoIndex(x, y)];
	}

	/**
	 * Outputs the map as an ascii string (i.e. 0=#, 1=.)
	 * @param [char] - The characters to use for each tile type by index. 
	 * @return A string representing the map. 
	 */
	public function toPrettyString(char:Array<String> = null) {
		if (char == null) {
			char = [" ", ".", ",", "`"];
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

	/**
	 * Returns the map as a string.
	 * @return a string representing the map. 
	 */
	public function toString():String {
		//     var output = "\n MAP2d: \n\n";
		var output = "\n";

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
