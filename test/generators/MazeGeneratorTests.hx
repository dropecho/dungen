package generators;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.generators.MazeGenerator;

class MazeGeneratorTests extends Test {
	public function test_map_dimensions_match_params() {
		var map = MazeGenerator.generate({width: 21, height: 21, seed: "test"});
		Assert.equals(21, map._width);
		Assert.equals(21, map._height);
	}

	public function test_map_contains_floor_tiles() {
		var map = MazeGenerator.generate({width: 21, height: 21, seed: "test"});
		var hasFloor = false;
		for (i in 0...map._mapData.length) {
			if (map._mapData[i] == 1) {
				hasFloor = true;
				break;
			}
		}
		Assert.isTrue(hasFloor);
	}

	public function test_same_seed_produces_identical_output() {
		var map1 = MazeGenerator.generate({width: 21, height: 21, seed: "deterministic"});
		var map2 = MazeGenerator.generate({width: 21, height: 21, seed: "deterministic"});
		Assert.same(map1._mapData, map2._mapData);
	}

	public function test_different_seeds_produce_different_output() {
		var map1 = MazeGenerator.generate({width: 21, height: 21, seed: "seed_a"});
		var map2 = MazeGenerator.generate({width: 21, height: 21, seed: "seed_b"});
		var same = true;
		for (i in 0...map1._mapData.length) {
			if (map1._mapData[i] != map2._mapData[i]) {
				same = false;
				break;
			}
		}
		Assert.isFalse(same);
	}

	public function test_default_params_produce_correct_dimensions() {
		var map = MazeGenerator.generate();
		Assert.equals(64, map._width);
		Assert.equals(64, map._height);
	}
}
