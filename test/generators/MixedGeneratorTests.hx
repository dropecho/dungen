package generators;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.generators.MixedGenerator;
import dropecho.dungen.bsp.BSPBuilder;

class MixedGeneratorTests extends Test {
	var builder:BSPBuilder;

	public function setup() {
		builder = new BSPBuilder({width: 60, height: 40, depth: 4, seed: "test"});
	}

	public function test_does_not_crash_with_default_params() {
		var tree = builder.generate();
		var map = MixedGenerator.buildRooms(tree, {seed: "test"});
		Assert.notNull(map);
	}

	public function test_generated_map_width_matches_bsp_root_width() {
		var tree = builder.generate();
		var map = MixedGenerator.buildRooms(tree, {seed: "test"});
		Assert.equals(tree.root.value.width, map._width);
	}

	public function test_generated_map_height_matches_bsp_root_height() {
		var tree = builder.generate();
		var map = MixedGenerator.buildRooms(tree, {seed: "test"});
		Assert.equals(tree.root.value.height, map._height);
	}
}
