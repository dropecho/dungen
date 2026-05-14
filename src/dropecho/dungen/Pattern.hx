package dropecho.dungen;

@:expose("dungen.Pattern")
class Pattern extends Map2d {
	public var _variations:Array<Array<Int>> = new Array<Array<Int>>();
	public var _hashes:Array<Int> = new Array<Int>();

	public function new(size:Int, initTileData:Int = 0) {
		super(size, size, initTileData);
	}

	public static function init(size:Int, pattern:Array<Int> = null, symmetry:Int = 255):Pattern {
		var p = new Pattern(size, 0);
		p._mapData = pattern;
		p.buildVariations(symmetry);
		return p;
	}

	/**
	 * Convert the variation at index to a Map2d.
	 *
	 * @param [index] - The variation index to convert.
	 * @returns The converted variation.
	 */
	public function variationToMap(index:Int = 0):Map2d {
		return this.clone(this._variations[index]);
	}

	/**
	 * Find the matching variation index.
	 *
	 * @param map - The map to find the match on.
	 * @param x - The x position to test on the given map.
	 * @param y - The y position to test on the given map.
	 * @param [tileToIgnore] - A tile type to ignore, i.e. a "wildcard" on the map.
	 * @returns The matching index if found, otherwise -1.
	 */
	public function getMatchingVariationIndex(map:Map2d, x:Int, y:Int, tileToIgnore:Int = -1):Int {
		var toMatch:Array<Int> = map.getRect({
			x: x,
			y: y,
			width: _width,
			height: _height
		});

		for (p in 0...this._variations.length) {
			var match = false;
			var pattern = this._variations[p];

			for (tile in 0...pattern.length) {
				match = toMatch[tile] == pattern[tile] || pattern[tile] == tileToIgnore;
				if (!match) {
					break;
				}
			}

			if (match) {
				return p;
			}
		}

		return -1;
	}

	/**
	 * Check if a pattern matches the "rect" of the map at x,y.
	 *
	 * @param map - The map to check.
	 * @param x - The x position on the map to check.
	 * @param y - The y position on the map to check.
	 */
	public function matches(map:Map2d, x:Int, y:Int):Bool {
		return getMatchingVariationIndex(map, x, y) != -1;
	}

	public function buildVariations(symmetry:Int = 255) {
		var width = this._width;
		var length = this._mapData.length;

		inline function pattern(fn:(Int, Int) -> Int) {
			return [for (y in 0...width) for (x in 0...width) fn(x, y)];
		}

		inline function rotate(p:Array<Int>) {
			return pattern((x, y) -> p[(width - x - 1) * width + y]);
		}

		inline function reflect(p:Array<Int>) {
			return pattern((x, y) -> p[length - (width * y + 1) - x]);
		}

		inline function hash(p:Array<Int>) {
			var result = 0;
			var power = 1;

			for (i in 0...p.length) {
				var val = p[p.length - 1 - i];
				result += val << i + 1;
			}

			return result;
		}

		var variations = new Array<Array<Int>>();
		variations[0] = this._mapData;
		variations[1] = rotate(variations[0]);
		variations[2] = rotate(variations[1]);
		variations[3] = rotate(variations[2]);
		variations[4] = reflect(variations[0]);
		variations[5] = reflect(variations[1]);
		variations[6] = reflect(variations[2]);
		variations[7] = reflect(variations[3]);

		_hashes[0] = hash(variations[0]);
		_variations[0] = variations[0];

		for (i in 1...8) {
			if (symmetry & i != 0) {
				_hashes[i] = hash(variations[i]);
				_variations[i] = variations[i];
			}
		}
	}
}
