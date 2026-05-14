package generators;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.bsp.BSPBuilder;
import dropecho.dungen.generators.RoomGenerator;

class RoomGeneratorTests extends Test {
	function buildTree(width:Int = 64, height:Int = 64, seed:String = "test") {
		var bsp = new BSPBuilder({width: width, height: height, seed: seed});
		return bsp.generate();
	}

	public function test_output_map_width_matches_bsp_root_width() {
		var tree = buildTree(64, 48);
		var map = RoomGenerator.buildRooms(tree);
		Assert.equals(tree.getRoot().value.width, map._width);
	}

	public function test_output_map_height_matches_bsp_root_height() {
		var tree = buildTree(64, 48);
		var map = RoomGenerator.buildRooms(tree);
		Assert.equals(tree.getRoot().value.height, map._height);
	}

	public function test_map_contains_at_least_one_floor_tile() {
		var tree = buildTree();
		var map = RoomGenerator.buildRooms(tree, {tileFloor: 1, tileWall: 0});
		var hasFloor = map._mapData.filter(t -> t == 1).length > 0;
		Assert.isTrue(hasFloor);
	}

	public function test_tileFloor_param_value_appears_in_map_data() {
		var tree = buildTree();
		var tileFloor = 5;
		var map = RoomGenerator.buildRooms(tree, {tileFloor: tileFloor, tileWall: 0});
		var hasFloor = map._mapData.filter(t -> t == tileFloor).length > 0;
		Assert.isTrue(hasFloor);
	}

	public function test_tileWall_param_value_appears_in_map_data() {
		var tree = buildTree();
		var tileWall = 9;
		var map = RoomGenerator.buildRooms(tree, {tileFloor: 1, tileWall: tileWall});
		var hasWall = map._mapData.filter(t -> t == tileWall).length > 0;
		Assert.isTrue(hasWall);
	}

	public function test_seed_param_produces_deterministic_output() {
		var tree1 = buildTree(64, 64, "deterministic");
		var tree2 = buildTree(64, 64, "deterministic");
		var map1 = RoomGenerator.buildRooms(tree1, {seed: "deterministic"});
		var map2 = RoomGenerator.buildRooms(tree2, {seed: "deterministic"});

		Assert.equals(map1._mapData.length, map2._mapData.length);
		for (i in 0...map1._mapData.length) {
			Assert.equals(map1._mapData[i], map2._mapData[i]);
		}
	}
}
