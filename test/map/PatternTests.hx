package map;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.map.Pattern.Pattern;

class PatternTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(3, 3, 0);
	}

	public function test_should_rotate() {
		var pattern = Pattern.init(3, [
			0, 1, 0,
			0, 0, 0,
			0, 0, 0
		]);

		var rot_90 = [
			0, 0, 0,
			0, 0, 1,
			0, 0, 0
		];
		Assert.same(rot_90, pattern.patterns[1]);

		var rot_180 = [
			0, 0, 0,
			0, 0, 0,
			0, 1, 0
		];
		Assert.same(rot_180, pattern.patterns[2]);

		var rot_270 = [
			0, 0, 0,
			1, 0, 0,
			0, 0, 0
		];
		Assert.same(rot_270, pattern.patterns[3]);
	}

	public function test_should_reflect() {
		var pattern = Pattern.init(3, [
			0, 1, 0,
			0, 0, 0,
			0, 0, 0
		]);

		var expected_reflection_orig = [
			0, 0, 0,
			0, 0, 0,
			0, 1, 0
		];
		Assert.same(expected_reflection_orig, pattern.patterns[4]);

		var expected_reflection_rot_90 = [
			0, 0, 0,
			1, 0, 0,
			0, 0, 0
		];
		Assert.same(expected_reflection_rot_90, pattern.patterns[5]);

		var expected_reflection_rot_180 = [
			0, 1, 0,
			0, 0, 0,
			0, 0, 0
		];
		Assert.same(expected_reflection_rot_180, pattern.patterns[6]);

		var expected_reflection_rot_270 = [
			0, 0, 0,
			0, 0, 1,
			0, 0, 0
		];
		Assert.same(expected_reflection_rot_270, pattern.patterns[7]);
	}

	public function test_symmetry_should_return_all_the_same() {
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
			Assert.same(expected, pattern.patterns[e + 1]);
		}
	}
}
