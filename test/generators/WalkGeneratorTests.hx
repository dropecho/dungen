package generators;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.generators.WalkGenerator;

class WalkGeneratorTests extends Test {
	public function test_generated_map_has_correct_width() {
		var map = WalkGenerator.generate({width: 32, height: 16, seed: "test"});
		Assert.equals(32, map._width);
	}

	public function test_generated_map_has_correct_height() {
		var map = WalkGenerator.generate({width: 32, height: 16, seed: "test"});
		Assert.equals(16, map._height);
	}

	public function test_generated_map_contains_at_least_one_floor_tile() {
		var map = WalkGenerator.generate({width: 32, height: 32, seed: "test"});
		var floorCount = map._mapData.filter(t -> t == 1).length;
		Assert.isTrue(floorCount > 0);
	}

	public function test_floor_tile_count_is_within_tolerance_of_start_fill_percent() {
		var width = 32;
		var height = 32;
		var fillPercent = 50;
		var map = WalkGenerator.generate({width: width, height: height, start_fill_percent: fillPercent, seed: "abc"});
		var total = width * height;
		var floorCount = map._mapData.filter(t -> t == 1).length;
		var actualPercent = (floorCount / total) * 100;
		Assert.isTrue(actualPercent >= fillPercent - 10 && actualPercent <= fillPercent + 10);
	}

	public function test_same_seed_produces_identical_map_data() {
		var map1 = WalkGenerator.generate({width: 32, height: 32, seed: "deterministic"});
		var map2 = WalkGenerator.generate({width: 32, height: 32, seed: "deterministic"});
		Assert.equals(map1._mapData.length, map2._mapData.length);
		for (i in 0...map1._mapData.length) {
			Assert.equals(map1._mapData[i], map2._mapData[i]);
		}
	}
}
