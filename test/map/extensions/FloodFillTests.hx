package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;

class FloodFillTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(8, 8, 0);
	}

	public function test_on_0_filled_map_should_return_array_same_as_map_size() {
		var filledTiles = map.floodFill(0, 0, 0);

		Assert.equals(map._mapData.length, filledTiles.size());
	}

	public function test_on_manually_filled_map_should_return_top_row() {
		map.set(0, 1, 1);
		map.set(1, 1, 1);
		map.set(2, 1, 1);
		map.set(3, 1, 1);
		map.set(4, 1, 1);
		map.set(5, 1, 1);
		map.set(6, 1, 1);
		map.set(7, 1, 1);

		var filledTiles = map.floodFill(0, 0, 0);

		// should flood fill only first row
		Assert.equals(8, filledTiles.size());
	}

	public function test_on_manually_filled_map_should_all_but_top_two_rows() {
		map.set(0, 1, 1);
		map.set(1, 1, 1);
		map.set(2, 1, 1);
		map.set(3, 1, 1);
		map.set(4, 1, 1);
		map.set(5, 1, 1);
		map.set(6, 1, 1);
		map.set(7, 1, 1);

		var filledTiles = map.floodFill(2, 2, 0);
		// should flood fill all but first and second row first row
		Assert.equals(48, filledTiles.size());
	}

	public function test_with_diagonal_on_manually_filled_map_should_all_but_already_filled() {
		map.set(2, 0, 1);
		map.set(1, 1, 1);
		map.set(0, 2, 1);

		var filledTiles = map.floodFill(2, 2, 0, true);

		// should fill all, including top left corner
		Assert.equals(61, filledTiles.size());
	}

	public function test_no_diagonal_on_manually_filled_map_should_all_but_top_left_corner() {
		map.set(2, 0, 1);
		map.set(1, 1, 1);
		map.set(0, 2, 1);

		var filledTiles = map.floodFill(2, 2, 0, false);

		// should fill all but top left corner
		Assert.equals(58, filledTiles.size());
	}
}
