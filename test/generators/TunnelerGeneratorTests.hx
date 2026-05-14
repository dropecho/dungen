package generators;

import utest.Assert;
import utest.Test;
import dropecho.dungen.generators.TunnelerGenerator;
import dropecho.dungen.Map2d;

class TunnelerGeneratorTests extends Test {
	public function test_map_dimensions_match_params() {
		var map = TunnelerGenerator.generate({width: 32, height: 16});
		Assert.equals(32, map._width);
		Assert.equals(16, map._height);
	}

	public function test_default_dimensions_are_64x64() {
		var map = TunnelerGenerator.generate();
		Assert.equals(64, map._width);
		Assert.equals(64, map._height);
	}

	public function test_map_contains_floor_tiles() {
		var map = TunnelerGenerator.generate({seed: "42", numTunnelers: 3, lifeSpan: 200});
		var hasFloor = map._mapData.filter(t -> t == 1).length > 0;
		Assert.isTrue(hasFloor);
	}

	public function test_same_seed_produces_identical_output() {
		var map1 = TunnelerGenerator.generate({seed: "test_seed", width: 20, height: 20});
		var map2 = TunnelerGenerator.generate({seed: "test_seed", width: 20, height: 20});
		Assert.same(map1._mapData, map2._mapData);
	}

	public function test_different_seeds_produce_different_output() {
		var map1 = TunnelerGenerator.generate({seed: "seed_a", width: 20, height: 20});
		var map2 = TunnelerGenerator.generate({seed: "seed_b", width: 20, height: 20});
		Assert.isFalse(map1._mapData.join("") == map2._mapData.join(""));
	}
}
