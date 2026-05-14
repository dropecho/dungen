package generators;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.generators.CAGenerator;

class CAGeneratorTests extends Test {
	public function test_generated_map_has_correct_width() {
		var params = new CA_PARAMS();
		params.width = 32;
		params.height = 16;
		var map = CAGenerator.generate(params);
		Assert.equals(32, map._width);
	}

	public function test_generated_map_has_correct_height() {
		var params = new CA_PARAMS();
		params.width = 32;
		params.height = 16;
		var map = CAGenerator.generate(params);
		Assert.equals(16, map._height);
	}

	public function test_generated_map_contains_both_floor_and_wall_tiles() {
		var params = new CA_PARAMS();
		params.width = 32;
		params.height = 32;
		params.seed = "test";
		var map = CAGenerator.generate(params);
		var hasFloor = map._mapData.filter(t -> t == params.tile_floor).length > 0;
		var hasWall = map._mapData.filter(t -> t == params.tile_wall).length > 0;
		Assert.isTrue(hasFloor);
		Assert.isTrue(hasWall);
	}

	public function test_same_seed_produces_identical_map_data() {
		var params1 = new CA_PARAMS();
		params1.width = 32;
		params1.height = 32;
		params1.seed = "deterministic";

		var params2 = new CA_PARAMS();
		params2.width = 32;
		params2.height = 32;
		params2.seed = "deterministic";

		var map1 = CAGenerator.generate(params1);
		var map2 = CAGenerator.generate(params2);

		Assert.equals(map1._mapData.length, map2._mapData.length);
		for (i in 0...map1._mapData.length) {
			Assert.equals(map1._mapData[i], map2._mapData[i]);
		}
	}
}
