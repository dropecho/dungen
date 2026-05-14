package generators;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.generators.ConvChain;

class ConvChainTests extends Test {
	function buildSample():Map2d {
		var sample = new Map2d(4, 4, 0);
		sample._mapData = [
			1, 0, 1, 0,
			0, 1, 0, 1,
			1, 0, 1, 0,
			0, 1, 0, 1
		];
		return sample;
	}

	public function test_generate_returns_map_with_requested_width() {
		var sample = buildSample();
		var gen = new ConvChain(sample);
		var map = gen.generate(16, 12, 2, 1.0, 2);
		Assert.equals(16, map._width);
	}

	public function test_generate_returns_map_with_requested_height() {
		var sample = buildSample();
		var gen = new ConvChain(sample);
		var map = gen.generate(16, 12, 2, 1.0, 2);
		Assert.equals(12, map._height);
	}

	public function test_output_only_contains_tile_values_present_in_sample() {
		var sample = buildSample();
		var uniqueSampleValues:Array<Int> = [];
		for (v in sample._mapData) {
			if (uniqueSampleValues.indexOf(v) == -1) {
				uniqueSampleValues.push(v);
			}
		}

		var gen = new ConvChain(sample);
		var map = gen.generate(16, 16, 2, 1.0, 3);

		for (i in 0...map._mapData.length) {
			Assert.isTrue(uniqueSampleValues.indexOf(map._mapData[i]) != -1);
		}
	}

	public function test_same_seed_produces_identical_output() {
		var sample = buildSample();

		var gen1 = new ConvChain(sample);
		gen1.rng.setStringSeed("seed");
		var map1 = gen1.generate(16, 16, 2, 1.0, 3);

		var gen2 = new ConvChain(sample);
		gen2.rng.setStringSeed("seed");
		var map2 = gen2.generate(16, 16, 2, 1.0, 3);

		Assert.equals(map1._mapData.length, map2._mapData.length);
		for (i in 0...map1._mapData.length) {
			Assert.equals(map1._mapData[i], map2._mapData[i]);
		}
	}
}
