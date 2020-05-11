package dropecho.dungen.map;

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

	public function matchesIndex(map:Map2d, x:Int, y:Int):Int {
		var toMatch:Array<Int> = map.getRect(x, y, x + _width - 1, y + _height - 1);
		var match = false;

		for (p in 0...patterns.length) {
			var pattern = patterns[p];

			for (tile in 0...pattern.length) {
				match = toMatch[tile] == pattern[tile];
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
		var toMatch:Array<Int> = map.getRect(x - 1, y - 1, x + 1, y + 1);

		var match = false;
		for (p in patterns) {
			for (index in 0...p.length) {
				match = toMatch[index] == p[index];
				if (!match) {
					break;
				}
			}
			if (match) {
				return true;
			}
		}
		return match;
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

class RegionPatterns {
	static public var patterns:Array<Pattern> = new Array<Pattern>();
	static private var initialized:Bool = false;

	static public function init() {
		if (initialized) {
			return;
		} else {
			initialized = true;
		}
		var alcove = [
			-1, -4, -1,
			 0,  1,  0,
			-3, -2, -3
		];
		patterns.push(Pattern.init(3, alcove));

		var surrounded_corner = [
			-1, -4, -1,
			-4,  1,  0,
			-1,  0,  0
		];
		patterns.push(Pattern.init(3, surrounded_corner));

		var corridor = [
			 0, 0,  0,
			-1, 1, -1,
			 0, 0,  0
		];
		patterns.push(Pattern.init(3, corridor));

		var floating_door = [
			 0, -4, -4,
			-4,  1, -4,
			-4, -4, -2
		];
		patterns.push(Pattern.init(3, floating_door));

		var single_door_on_wall = [
			-2, 0, 0,
			 2, 1, 2,
			-4, 2, -4
		];
		patterns.push(Pattern.init(3, single_door_on_wall));

		var single_door_on_wall_2 = [
			 0, 2, 2,
			 2, 1, 2,
			-4, 2, -4
		];
		patterns.push(Pattern.init(3, single_door_on_wall));

		var three_way_door = [
			0, 1, 0,
			1, 1, 1,
			0, 0, 0
		];
		patterns.push(Pattern.init(3, three_way_door));

		var doubled_doors = [
			-4, -4, 1,
			-4,  1, 1,
			 0,  0, 0
		];
		patterns.push(Pattern.init(3, doubled_doors));

		var door_on_end = [
			-4, 0, -4,
			-4, 1, -4,
			-4, 2, -4
		];
		patterns.push(Pattern.init(3, door_on_end));

		var floating_door_on_end = [
			0, 2, 0,
			0, 1, 2,
			2, 1, 2
		];
		patterns.push(Pattern.init(3, floating_door_on_end));

		// TODO: try to refactor.
		var r1 = [
			1, 2, 0,
			2, 1, 0,
			2, 2, 1
		];
		patterns.push(Pattern.init(3, r1));

		var r2 = [
			2, 1, 0,
			2, 1, 1,
			0, 0, 0
		];
		patterns.push(Pattern.init(3, r2));
	}
}

// var alcove_one_open = [
//   -1, 2, 2,
//    0, 1, 0,
//    0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, alcove_one_open));
// var alcove_one_door = [
//   0, 2, 1,
//   0, 1, 0,
//   0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, alcove_one_door));
// var surrounded = [
//   0, 0, 0,
//   0, 1, 0,
//   0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, surrounded));
// var all_but_one_closed_corner = [
//   1, 1, 1,
//   1, 1, 1,
//   0, 1, 1
// ];
//
// patterns.push(Pattern.init(3, all_but_one_closed_corner));
// var all_but_one_closed_top = [
//   -1, 0, -1,
//    1, 1,  1,
//    1, 1,  1
// ];
//
// patterns.push(Pattern.init(3, all_but_one_closed_top));
// var alcove_closed = [
//   -1, 1, -1,
//    0, 1,  0,
//    0, 0,  0
// ];
//
// patterns.push(Pattern.init(3, alcove_closed));
// var alcove_corner = [
//   0, 1, 0,
//   0, 1, 1,
//   0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, alcove_corner));
// var double_door = [
//   -1, 2, 2,
//    0, 1, 1,
//    0, 1, 1
// ];
//
// patterns.push(Pattern.init(3, double_door));
// var diag_door = [
//   2, -1, -1,
//   2,  1,  0,
//   1,  1, -1
// ];
//
// patterns.push(Pattern.init(3, diag_door));
// var diag_door_2 = [
//   2, 2, 1,
//   2, 1, 1,
//   0, 2, 0
// ];
//
// patterns.push(Pattern.init(3, diag_door_2));
// var corner_door_2 = [
//    0, 0, -1,
//    0, 1,  2,
//   -1, 2, -1
// ];
//
// patterns.push(Pattern.init(3, corner_door_2));
// var corridor = [
//   0, -1, 0,
//   0,  1, 0,
//   0,  1, 0
// ];
//
// patterns.push(Pattern.init(3, corridor));
// var corridor_3_way_door = [
//   -1, 1, -1,
//    1, 1,  1,
//    0, 0,  0
// ];
//
// patterns.push(Pattern.init(3, corridor_3_way_door));
// var corridor_3_way_door_open_top = [
//   -1, 2, -1,
//    1, 1,  1,
//   -1, 0,  0
// ];
//
// patterns.push(Pattern.init(3, corridor_3_way_door_open_top));
// var corridor_duplicate_door = [
//   0, 0, 1,
//   2, 1, 2,
//   0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, corridor_duplicate_door));
// [>
//   ..#
//   .+#
//   #+#
//  */
// var extra_door_at_corridor_end = [
//   2, 2, 0,
//   2, 1, 0,
//   0, 1, 0
// ];
//
// patterns.push(Pattern.init(3, extra_door_at_corridor_end));
// [>
//   ##+
//   .+.
//   ..+
//  */
// var float_door_corner = [
//   0, 0, 1,
//   2, 1, 2,
//   2, 2, 1
// ];
//
// patterns.push(Pattern.init(3, float_door_corner));
// var float_door_corner_2 = [
//   2, 2, 2,
//   2, 1, 2,
//   1, 1, -1
// ];
//
// patterns.push(Pattern.init(3, float_door_corner_2));
// var float_door_tiny_region = [
//   0, 1, 1,
//   2, 1, 1,
//   0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, float_door_tiny_region));
// var float_door_tiny_region_2 = [
//   0, 2, 0,
//   1, 1, 2,
//   2, 1, 2
// ];
//
// patterns.push(Pattern.init(3, float_door_tiny_region_2));
// var float_door_tiny_region_corner = [
//   1, 1, 0,
//   2, 1, 0,
//   0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, float_door_tiny_region_corner));
// var float_door_against_wall = [
//   2, 2, 2,
//   2, 1, 2,
//   0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, float_door_against_wall));
// var float_door_corner_wall = [
//   2, 2, 0,
//   2, 1, 2,
//   2, 2, 2,
// ];
//
// patterns.push(Pattern.init(3, float_door_corner_wall));
// var float_door_corner_wall_corridor = [
//   0, 0, 1,
//   2, 1, 2,
//   2, 2, 2,
// ];
//
// patterns.push(Pattern.init(3, float_door_corner_wall_corridor));
// var float_door_tiny_region_open = [
//   0, 2, 0,
//   1, 1, 1,
//   2, 2, 2
// ];
//
// patterns.push(Pattern.init(3, float_door_tiny_region_open));
// var useless_double_door = [
//   0, 1, -1,
//   0, 1,  2,
//   0, 0,  0
// ];
//
// patterns.push(Pattern.init(3, useless_double_door));
// var useless_double_door_corner = [
//   2, 0, 0,
//   1, 1, 0,
//   2, 2, 0
// ];
//
// patterns.push(Pattern.init(3, useless_double_door_corner));
// var float_door_double_door_corridor_exit = [
//   1, 1, 0,
//   2, 1, 1,
//   0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, float_door_double_door_corridor_exit));
// var float_door_weird_tiny_regions = [
//   0, 2, 2,
//   2, 1, 2,
//   0, 2, 0
// ];
//
// patterns.push(Pattern.init(3, float_door_weird_tiny_regions));
// var float_door_weird_tiny_regions_2 = [
//   0, 2, 0,
//   0, 1, 2,
//   2, 2, 2
// ];
//
// patterns.push(Pattern.init(3, float_door_weird_tiny_regions_2));
// [>
//   +..##
//   #+X.#
//   +.+..
//  */
// var float_door_weird_useless = [
//   2, 2, 0,
//   1, 1, 2,
//   2, 1, 2
// ];
//
// patterns.push(Pattern.init(3, float_door_weird_useless));
// [>
//   +..
//   .X.
//   ###
//  */
// var float_door_wall_corner_door = [
//   1, 2, 2,
//   2, 1, 2,
//   0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, float_door_wall_corner_door));
// [>
//   ...
//   .X.
//   +#+
//  */
// var float_door_wall_end_doors = [
//   2, 2, 2,
//   2, 1, 2,
//   1, 0, 1
// ];
//
// patterns.push(Pattern.init(3, float_door_wall_end_doors));
// [>
//   #.+
//   .X+
//   ...
//  */
// var diag_door_not_blocking = [
//   0, 2, 1,
//   2, 1, 1,
//   2, 2, 2
// ];
//
// patterns.push(Pattern.init(3, diag_door_not_blocking));
// [>
//   .++
//   .X#
//   ...
//  */
// var wall_end_door_not_blocking = [
//   2, 1, 1,
//   2, 1, 0,
//   2, 2, 2
// ];
//
// patterns.push(Pattern.init(3, wall_end_door_not_blocking));
// [>
//   #+#
//   .X+
//   .##
//  */
// var float_door_wall_corner_door_false_corridor = [
//   0, 1, 0,
//   2, 1, 1,
//   2, 0, 0
// ];
//
// patterns.push(Pattern.init(3, float_door_wall_corner_door_false_corridor));
// [>
//   #++
//   +X.
//   ##.
//  */
// var door_useless_many_doors = [
//   0, 1, 1,
//   1, 1, 2,
//   0, 0, 2
// ];
//
// patterns.push(Pattern.init(3, door_useless_many_doors));
// [>
//   ...
//   +X.
//   #+.
//  */
// var door_useless_corner_wall = [
//   2, 2, 2,
//   1, 1, 2,
//   0, 1, 2
// ];
//
// patterns.push(Pattern.init(3, door_useless_corner_wall));
// [>
//   .++
//   +X#
//   +..
//  */
// var door_useless_end_wall = [
//   2, 1, 1,
//   1, 1, 0,
//   1, 2, 2
// ];
//
// patterns.push(Pattern.init(3, door_useless_end_wall));
// [>
//   ...
//   #X.
//   ...
//  */
// var door_at_end_of_wall = [
//   2, 2, 2,
//   0, 1, 2,
//   2, 2, 2
// ];
//
// patterns.push(Pattern.init(3, door_at_end_of_wall));
// [>
//   ...
//   #X.
//   ...
//  */
// var useless_double_door_surrounded = [
//   2, 2, 2,
//   0, 1, 1,
//   0, 0, 0
// ];
//
// patterns.push(Pattern.init(3, useless_double_door_surrounded));
// [>
//   #.+
//   .+.
//   .+.
//  */
// var door_useless_end_door = [
//   0, 2, 1,
//   2, 1, 2,
//   2, 1, 2
// ];
//
// patterns.push(Pattern.init(3, door_useless_end_door));
// [>
//   #++
//   ++.
//   ##.
//  */
// var door_useless_corner_doors_wall = [
//   0, 1, 1,
//   1, 1, 2,
//   0, 0, 1
// ];
//
// patterns.push(Pattern.init(3, door_useless_corner_doors_wall));
// [>
//   #+#
//   #X+
//   .+#
//  */
// var noise_reduction1 = [
//   0, 1, 0,
//   0, 1, 1,
//   2, 1, 0
// ];
//
// patterns.push(Pattern.init(3, noise_reduction1));
// [>
//   +++
//   .X#
//   +++
//  */
// var noise_reduction3 = [
//   1, 1, 1,
//   2, 1, 0,
//   1, 1, 1
// ];
//
// patterns.push(Pattern.init(3, noise_reduction3));
// [>
//   +.#
//   .X.
//   +++
//  */
// var noise_reduction4 = [
//   1, 2, 0,
//   2, 1, 2,
//   1, 1, 1
// ];
//
// patterns.push(Pattern.init(3, noise_reduction4));
// [>
//   +.+
//   +x+
//   .#.
//  */
// var noise_reduction5 = [
//   1, 2, 1,
//   1, 1, 1,
//   2, 0, 2
// ];
//
// patterns.push(Pattern.init(3, noise_reduction5));
// [>
//   +#+
//   +x.
//   ..#
//  */
// var noise_reduction6 = [
//   -1, 0, 1,
//    1, 1, 2,
//    2, 2, 0
// ];
//
// patterns.push(Pattern.init(3, noise_reduction6));
// [>
//   #..
//   .x.
//   ..#
//  */
// var noise_reduction7 = [
//   0, 2, 2,
//   2, 1, 2,
//   2, 2, 0
// ];
//
// patterns.push(Pattern.init(3, noise_reduction7));
// [>
//   +++
//   .x+
//   .+#
//  */
// var noise_reduction8 = [
//   1, 1, 1,
//   2, 1, 1,
//   2, 1, 0
// ];
//
// patterns.push(Pattern.init(3, noise_reduction8));
// [>
//   ++#
//   +x.
//   #..
//  */
// var noise_reduction9 = [
//   1, 1, 0,
//   1, 1, 2,
//   0, 2, 2
// ];
//
// patterns.push(Pattern.init(3, noise_reduction9));
// [>
//   #.#
//   +x#
//   +..
//  */
// var noise_reduction10 = [
//   0, 2, 0,
//   1, 1, 0,
//   1, 2, 2
// ];
//
// patterns.push(Pattern.init(3, noise_reduction10));
// [>
//   ...
//   .x.
//   #.+
//  */
// var noise_reduction11 = [
//   2, 2, 2,
//   2, 1, 2,
//   0, 2, 1
// ];
//
// patterns.push(Pattern.init(3, noise_reduction11));
// [>
//   ++#
//   .x+
//   ...
//  */
// var noise_reduction12 = [
//   1, 1, 0,
//   2, 1, 1,
//   2, 2, 2
// ];
//
// patterns.push(Pattern.init(3, noise_reduction12));
// [>
//   ++#
//   .x+
//   ...
//  */
// var noise_reduction13 = [
//   1, 0, 0,
//   2, 1, 0,
//   1, 1, 0
// ];
//
// patterns.push(Pattern.init(3, noise_reduction13));
// [>
//   ...
//   +x#
//   +##
//  */
// var noise_reduction14 = [
//   2, 2, 2,
//   1, 1, 0,
//   1, 0, 0
// ];
//
// patterns.push(Pattern.init(3, noise_reduction14));
// [>
//   ...
//   +x#
//   +##
//  */
// var noise_reduction15 = [
//   2, 0, 0,
//   1, 1, 0,
//   2, 2, 1
// ];
//
// patterns.push(Pattern.init(3, noise_reduction15));
// [>
//   #..
//   .x+
//   .+#
//  */
// var noise_reduction16 = [
//   0, 2, 2,
//   2, 1, 1,
//   2, 1, 0
// ];
//
// patterns.push(Pattern.init(3, noise_reduction16));
// [>
//   #+.
//   .x.
//   ...
//  */
// var noise_reduction17 = [
//   0, 1, 2,
//   2, 1, 2,
//   2, 2, 2
// ];
//
// patterns.push(Pattern.init(3, noise_reduction17));
// [>
//   +.#
//   .x#
//   +++
//  */
// var noise_reduction17 = [
//   1, 2, 0,
//   2, 1, 0,
//   1, 1, 1
// ];
//
// patterns.push(Pattern.init(3, noise_reduction17));
// [>
//   ...
//   #x.
//   #..
//  */
// var noise_reduction17 = [
//   2, 2, 2,
//   0, 1, 2,
//   0, 2, 2
// ];
//
// patterns.push(Pattern.init(3, noise_reduction17));
// [>
//   #+#
//   #x.
//   ##.
//  */
// var noise_reduction17 = [
//   0, 1, 0,
//   0, 1, 2,
//   0, 0, 2
// ];
// patterns.push(Pattern.init(3, noise_reduction17));
// }}
