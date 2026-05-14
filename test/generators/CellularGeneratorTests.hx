package generators;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.generators.CellularGenerator;
import dropecho.dungen.generators.CellularGenerator.CellularParams;

class CellularGeneratorTests extends Test {
	public function test_generated_map_has_correct_width() {
		var params = new CellularParams();
		params.width = 32;
		params.height = 16;
		var map = CellularGenerator.generate(params);
		Assert.equals(32, map._width);
	}

	public function test_generated_map_has_correct_height() {
		var params = new CellularParams();
		params.width = 32;
		params.height = 16;
		var map = CellularGenerator.generate(params);
		Assert.equals(16, map._height);
	}

	public function test_generated_map_contains_both_floor_and_wall_tiles() {
		var params = new CellularParams();
		params.width = 32;
		params.height = 32;
		params.seed = "test";
		var map = CellularGenerator.generate(params);
		var hasFloor = map._mapData.filter(t -> t == params.tile_floor).length > 0;
		var hasWall = map._mapData.filter(t -> t == params.tile_wall).length > 0;
		Assert.isTrue(hasFloor);
		Assert.isTrue(hasWall);
	}

	public function test_passes_param_applies_multiple_iterations() {
		var params1 = new CellularParams();
		params1.width = 32;
		params1.height = 32;
		params1.seed = "test_passes";
		params1.passes = 1;

		var params3 = new CellularParams();
		params3.width = 32;
		params3.height = 32;
		params3.seed = "test_passes";
		params3.passes = 3;

		var map1 = CellularGenerator.generate(params1);
		var map3 = CellularGenerator.generate(params3);

		var same = true;
		for (i in 0...map1._mapData.length) {
			if (map1._mapData[i] != map3._mapData[i]) {
				same = false;
				break;
			}
		}
		Assert.isFalse(same);
	}

	public function test_same_seed_produces_identical_map_data() {
		var params1 = new CellularParams();
		params1.width = 32;
		params1.height = 32;
		params1.seed = "deterministic";

		var params2 = new CellularParams();
		params2.width = 32;
		params2.height = 32;
		params2.seed = "deterministic";

		var map1 = CellularGenerator.generate(params1);
		var map2 = CellularGenerator.generate(params2);

		Assert.equals(map1._mapData.length, map2._mapData.length);
		for (i in 0...map1._mapData.length) {
			Assert.equals(map1._mapData[i], map2._mapData[i]);
		}
	}
}
