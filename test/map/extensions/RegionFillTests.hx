package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;

class RegionFillTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(8, 8, 0);
	}

	public function test_bfs_should_work() {
		map.set(2, 0, 1);
		var pathToClosestWall = map.BFS(0, 0, 1);

		Assert.equals(2, pathToClosestWall.length);
	}

	public function test_bfs_should_return_1_when_1_tile_from_given_tile_value() {
		var map = new Map2d(4, 4, 0);
		map._mapData = [
			1, 1, 0, 0,
			1, 1, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
		];

		var pathToClosestWall = map.BFS(0, 0, 0);
		Assert.equals(1, pathToClosestWall.length);
	}

	public function test_bfs_should_return_3_given_distance_diagonally_is_3() {
		var map = new Map2d(4, 4, 0);
		map._mapData = [
			1, 1, 1, 1,
			1, 1, 1, 1,
			1, 1, 1, 1,
			1, 1, 1, 0,
		];

		var pathToClosestWall = map.BFS(0, 0, 0);
		Assert.equals(3, pathToClosestWall.length);
	}

	public function test_bottom_left_corner_weird() {
		var map = new Map2d(4, 4, 0);
		map._mapData = [
			0, 0, 0, 0,
			1, 1, 1, 0,
			1, 1, 0, 0,
			1, 1, 0, 0,
		];

		var pathToClosestWall = map.BFS(0, 3, 0);
		Assert.equals(2, pathToClosestWall.length);
	}

	public function test_region_fill_should_fill_map_with_distances() {
		var map = new Map2d(4, 4, 0);
		map._mapData = [
			0, 0, 0, 0,
			1, 1, 1, 0,
			1, 1, 0, 0,
			1, 1, 0, 0,
		];

		var m = 999999;
		var expected = [
			m, m, m, m,
			0, 0, 0, m,
			1, 0, m, m,
			1, 0, m, m,
		];

		// m, m, m, m,
		// 0, 0, 0, m,
		// 1, 1, m, m,
		// 2, 1, m, m,

		var new_map = map.regionFill(0);
		Assert.same(expected, new_map._mapData);
	}

	//
	//
	//   public function test_regionfill_on_manually_filled_map_should_all_but_top_two_rows() {
	//     map.set(0, 1, 1);
	//     map.set(1, 1, 1);
	//     map.set(2, 1, 1);
	//     map.set(3, 1, 1);
	//     map.set(4, 1, 1);
	//     map.set(5, 1, 1);
	//     map.set(6, 1, 1);
	//     map.set(7, 1, 1);
	//
	//     var filledTiles = map.regionFill(0);
	//     // should region fill all but first and second row first row
	//     Assert.equals(48, filledTiles.length);
	//   }
	//
	//
	//   public function test_regionfill_with_diagonal_on_manually_filled_map_should_all_but_already_filled() {
	//     map.set(2, 0, 1);
	//     map.set(1, 1, 1);
	//     map.set(0, 2, 1);
	//
	//     var filledTiles = map.regionFill(0);
	//
	//     // should fill all, including top left corner
	//     Assert.equals(61, filledTiles.length);
	//   }
	//
	//
	//   public function test_regionfill_no_diagonal_on_manually_filled_map_should_all_but_top_left_corner() {
	//     map.set(2, 0, 1);
	//     map.set(1, 1, 1);
	//     map.set(0, 2, 1);
	//
	//     var filledTiles = map.regionFill(0);
	//
	//     // should fill all but top left corner
	//     Assert.equals(58, filledTiles.length);
	//   }
}
