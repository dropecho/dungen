package dropecho.dungen.map;

using dropecho.dungen.map.extensions.Utils;
using dropecho.dungen.map.Map2dExtensions;

@:expose("dungen.Pattern")
class Pattern extends Map2d {
	public var patterns:Array<Array<Int>> = new Array<Array<Int>>();
	public var hashes:Array<Int> = new Array<Int>();

	public function new(size:Int, initTileData:Int = 0) {
		super(size, size, initTileData);
	}

	public static function init(size:Int, pattern:Array<Int> = null, symmetry:Int = 255) {
		var p = new Pattern(size, 0);
		p._mapData = pattern;
		p.buildVariations(symmetry);
		return p;
	}

	public function indexToMap(index:Int = 0):Map2d {
		return this.clone(this.patterns[index]);
	}

	public function matchesIndex(map:Map2d, x:Int, y:Int, tileToIgnore:Int = -1):Int {
		var toMatch:Array<Int> = map.getRect({
			x: x,
			y: y,
			width: _width,
			height: _height
		});
		var match = false;

		for (p in 0...patterns.length) {
			var pattern = patterns[p];

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

	public function matches(map:Map2d, x:Int, y:Int):Bool {
		return matchesIndex(map, x, y) != -1;
	}

	public function buildVariations(symmetry:Int = 255) {
		var n = this._width;

		inline function pattern(fn:(Int, Int) -> Int) {
			return [for (y in 0...n) for (x in 0...n) fn(x, y)];
		}

		inline function rotate(p:Array<Int>) {
			return pattern((x, y) -> p[n - 1 - y + x * n]);
		}

		inline function reflect(p:Array<Int>) {
			return pattern((x, y) -> p[n - 1 - x + y * n]);
		}

		inline function hash(p:Array<Int>) {
			var result = 0;
			var power = 1;

			for (i in 0...p.length) {
				result += p[p.length - 1 - i] != 0 ? power : 0;
				power *= 2;
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

		hashes[0] = hash(variations[0]);
		patterns[0] = variations[0];

		for (i in 1...8) {
			if (symmetry & i != 0) {
				hashes[i] = hash(variations[i]);
				patterns[i] = variations[i];
			}
		}
	}
}
