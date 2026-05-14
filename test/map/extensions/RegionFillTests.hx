package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;

class RegionFillTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(8, 8, 0);
	}

	public function test_should_fill_map_with_distances() {
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
			1, 1, 1, m,
			2, 1, m, m,
			2, 1, m, m,
		];

		var new_map = map.regionFill(0);
		Assert.same(expected, new_map._mapData);
	}

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
	//     var regionMap = map.regionFill(0);
	//     trace(regionMap.toString());
	//     // should region fill all but first and second row first row
	//     var tilesOfType = 0;
	//     for (tile in regionMap) {
	//       if (tile.val == 0) {
	//         tilesOfType++;
	//       }
	//     }
	//     Assert.equals(48, tilesOfType);
	//     //     Assert.equals(48, filledTiles.length);
	//   }
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
