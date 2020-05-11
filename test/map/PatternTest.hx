package map;

import massive.munit.Assert;
import dropecho.dungen.Map2d;
import dropecho.dungen.map.Pattern.Pattern;
import dropecho.dungen.map.Pattern.RegionPatterns;

class PatternTest {
	var map:Map2d;

	@Before
	public function setup() {
		map = new Map2d(3, 3, 0);
		RegionPatterns.init();
	}

	public function ArraysEqual(expected:Array<Int>, value:Array<Int>) {
		var equal = false;
		for (i in 0...expected.length) {
			equal = expected[i] == value[i];
		}

		return equal;
	}

	@Test
	public function should_rotate() {
		var pattern = Pattern.init(3, [
			0, 1, 0,
			0, 0, 0,
			0, 0, 0
		]);

		var expected = new Array<Array<Int>>();

		expected.push([
			0, 0, 0,
			1, 0, 0,
			0, 0, 0
		]);
		expected.push([
			0, 0, 0,
			0, 0, 0,
			0, 1, 0
		]);
		expected.push([
			0, 0, 0,
			0, 0, 1,
			0, 0, 0
		]);

		for (e in 0...3) {
			Assert.isTrue(ArraysEqual(expected[e], pattern.patterns[e + 1]));
		}
	}

	@Test
	public function should_reflect() {
		var pattern = Pattern.init(3, [
			0, 1, 0,
			0, 0, 0,
			0, 0, 0
		]);

		var expected_ref_1 = [
			0, 0, 0,
			0, 0, 0,
			0, 1, 0
		];

		Assert.isTrue(ArraysEqual(expected_ref_1, pattern.patterns[4]));
		var expected_ref_2 = [
			0, 0, 0,
			0, 0, 1,
			0, 0, 0
		];
		Assert.isTrue(ArraysEqual(expected_ref_2, pattern.patterns[5]));
		var expected_ref_3 = [
			0, 1, 0,
			0, 0, 0,
			0, 0, 0
		];
		Assert.isTrue(ArraysEqual(expected_ref_3, pattern.patterns[6]));
		var expected_ref_4 = [
			0, 0, 0,
			1, 0, 0,
			0, 0, 0
		];
		Assert.isTrue(ArraysEqual(expected_ref_4, pattern.patterns[7]));
	}

	@Test
	public function symmetry_should_return_all_the_same() {
		var pattern = Pattern.init(3, [
			0, 1, 0,
			1, 1, 1,
			0, 1, 0
		]);

		var expected = [
			0, 1, 0,
			1, 1, 1,
			0, 1, 0
		];

		for (e in 0...7) {
			Assert.isTrue(ArraysEqual(expected, pattern.patterns[e + 1]));
		}
	}
}
// @Test
// public function same_should_match() {
//   var alcovePattern = RegionPatterns.patterns[0];
//   map._mapData = [
//     2, 2, 2,
//     0, 1, 0,
//     0, 0, 0
//   ];
//
//   Assert.isTrue(alcovePattern.matches(map, 1, 1));
// }
//
// @Test
// public function rot_should_match() {
//   var alcovePattern = RegionPatterns.patterns[0];
//   map._mapData = [
//     0, 0, 2,
//     0, 1, 2,
//     0, 0, 2
//   ];
//
//   Assert.isTrue(alcovePattern.matches(map, 1, 1));
// }
//
// @Test
// public function should_not_match() {
//   var alcovePattern = RegionPatterns.patterns[0];
//   map._mapData = [
//     2, 2, 2,
//     0, 1, 0,
//     0, 0, 0
//   ];
//
//   Assert.isTrue(alcovePattern.matches(map, 1, 1));
// }
//
// @Test
// public function should_match_wild() {
//   var testPattern = Pattern.init(3, [
//      1, 1, 0,
//      1, 1, 0,
//     -4, 0, 0
//   ]);
//
//   map._mapData = [
//     1, 1, 0,
//     1, 1, 0,
//     1, 0, 0
//   ];
//   Assert.isTrue(testPattern.matches(map, 1, 1));
//
//   map._mapData = [
//     1, 1, 0,
//     1, 1, 0,
//     2, 0, 0
//   ];
//   Assert.isTrue(testPattern.matches(map, 1, 1));
// }
// }
