package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;

class BFSTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(8, 8, 0);
	}

	public function test_should_work() {
		map.set(2, 0, 1);
		var pathToClosestWall = map.BFS(0, 0, 1);

		Assert.equals(2, pathToClosestWall.length);
	}

	public function test_should_return_1_when_1_tile_from_given_tile_value() {
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

	public function test_should_return_3_given_distance_diagonally_is_3() {
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
}
