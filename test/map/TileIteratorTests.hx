package map;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.Tile2d;

class TileIteratorTests extends Test {
	public function test_should_iterate_through_tiles() {
		var map = new Map2d(4, 4);
		var itr = new TileIterator(map);

		var count = 0;
		for (tile in itr) {
			count++;
		}

		Assert.equals(count, map._mapData.length);
	}

	public function test_should_iterate_through_tiles_from_map_func() {
		var map = new Map2d(4, 4);

		var count = 0;
		for (tile in map) {
			count++;
		}

		Assert.equals(count, map._mapData.length);
	}
}
