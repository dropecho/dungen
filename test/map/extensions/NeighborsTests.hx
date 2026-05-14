package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;

class NeighborsTests extends Test {
	public function test_get_neighbors_should_return_all_neighbors_of_tile() {
		var map = new Map2d(4, 4);

		var neighbors = map.getNeighbors(0, 0);
		Assert.equals(neighbors.length, 3);
	}

	public function test_get_neighbors_should_return_all_nondiagonal_neighbors_of_tile() {
		var map = new Map2d(4, 4);

		var neighbors = map.getNeighbors(0, 0, 1, false);
		Assert.equals(neighbors.length, 2);
	}

	public function test_get_neighbors_should_return_all_neighbors_of_tile_2() {
		var map = new Map2d(4, 4);

		var neighbors = map.getNeighbors(2, 2);
		Assert.equals(neighbors.length, 8);
	}

	public function test_get_neighbors_should_return_all_non_diagonal_neighbors_of_tile_2() {
		var map = new Map2d(4, 4);

		var neighbors = map.getNeighbors(2, 2, 1, false);
		Assert.equals(4, neighbors.length);
	}

	public function test_should_return_neighbors() {
		var map = new Map2d(2, 2);
		map._mapData = [
			0, 1,
			1, 0
		];

		var neighbors = map.getNeighbors(0, 0);

		var expected = [1, 1, 0];

		Assert.same(expected, neighbors.map(x -> x.val));
	}

	public function test_should_return_neighbors_with_dist_1() {
		var map = new Map2d(3, 3);
		map._mapData = [
			0, 1, 2,
			1, 1, 2,
			2, 2, 2
		];

		var neighbors = map.getNeighbors(0, 0);

		var expected = [1, 1, 1];

		Assert.same(expected, neighbors.map(x -> x.val));
	}

	public function test_should_return_neighbors_with_max_dist_2() {
		var map = new Map2d(3, 3);
		map._mapData = [
			0, 1, 2,
			1, 1, 2,
			2, 2, 2
		];

		var neighbors = map.getNeighbors(0, 0, 2);

		var expected = [1, 2, 1, 1, 2, 2, 2, 2];

		Assert.same(expected, neighbors.map(x -> x.val));
	}

	public function test_should_return_neighbors_at_dist_2() {
		var map = new Map2d(3, 3);
		map._mapData = [
			0, 1, 2,
			1, 1, 2,
			2, 2, 2
		];

		var neighbors = map.getNeighborsAtDist(0, 0, 2);

		var expected = [2, 2, 2, 2, 2];

		Assert.same(expected, neighbors.map(x -> x.val));
	}
}
