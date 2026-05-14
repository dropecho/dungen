package map.extensions;

import dropecho.ds.Set;
import dropecho.dungen.Tile2d;
import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;

class GetFirstTileOfTypeTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(8, 8, 0);
	}

	public function test_get_first_0_on_0_filled_map_should_return_non_null_tile() {
		var firstEmpty = map.getFirstTileOfType(0);
		Assert.isTrue(firstEmpty != null);
	}

	public function test_get_first_1_on_0_filled_map_should_return_null() {
		var firstEmpty = map.getFirstTileOfType(1);
		Assert.isTrue(firstEmpty == null);
	}

	public function test_get_first_1_on_manually_filled_array_without_ignore_array_should_return_non_null() {
		map.set(0, 0, 1);

		var firstEmpty = map.getFirstTileOfType(1);
		Assert.isTrue(firstEmpty != null);
	}

	public function test_get_first_1_on_manually_filled_array_with_ignore_array_should_return_null() {
		map.set(0, 0, 1);

		var ignore = map.indexToXY(0);
		var ignoreArray = new Array<Tile2d>();

		ignoreArray.push(ignore);

		var firstEmpty = map.getFirstTileOfType(1, ignoreArray);
		Assert.isTrue(firstEmpty == null);
	}

	public function test_when_ignore_tiles_not_on_map_should_return_null() {
		var ignore = new Tile2d(100, 100, 1);
		var ignoreArray = new Array<Tile2d>();

		ignoreArray.push(ignore);

		var firstEmpty = map.getFirstTileOfType(1, ignoreArray);
		Assert.isTrue(firstEmpty == null);
	}

	public function test_when_ignore_is_null_should_return_null() {
		var ignore = map.indexToXY(0);
		var ignoreArray = new Array<Tile2d>();

		ignoreArray.push(ignore);

		var firstEmpty = map.getFirstTileOfType(1, ignoreArray);
		Assert.isTrue(firstEmpty == null);
	}

	public function test_get_first_1_on_manually_filled_array_with_ignore_set_should_return_null() {
		map.set(0, 0, 1);

		var ignore = map.indexToXY(0);
		var ignoreSet = new Set<Tile2d>();

		ignoreSet.add(ignore);

		var firstEmpty = map.getFirstTileOfTypeSet(1, ignoreSet);
		Assert.isTrue(firstEmpty == null);
	}

	public function test_get_first_0_on_manually_filled_array_with_ignore_set_should_return_tile() {
		map.set(0, 0, 1);

		var ignore = map.indexToXY(0);
		var ignoreSet = new Set<Tile2d>();

		ignoreSet.add(ignore);

		var firstEmpty = map.getFirstTileOfTypeSet(0, ignoreSet);
		Assert.isTrue(firstEmpty != null);
	}

	public function test_when_ignore_set_is_null_should_return_first_tile() {
		map.set(0, 0, 1);
		var ignore = map.indexToXY(0);

		var firstEmpty = map.getFirstTileOfTypeSet(0, null);
		Assert.isTrue(firstEmpty != null);
	}
}
