package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;

class DistanceFillTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(4, 4, 0);
	}

	public function test_small() {
		var map2 = new Map2d(4, 1, 0);
		map2._mapData = [0, 1, 0, 0,];

		var distanceMap = map2.distanceFill(1);
		var expected = [1, 0, 1, 2,];

		Assert.same(expected, distanceMap._mapData);
	}

	public function test_should_fill_map_with_distances() {
		map._mapData = [
			0, 0, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 0,
			0, 0, 0, 0
		];

		var expected = [
			2, 1, 1, 1,
			2, 1, 0, 1,
			2, 1, 1, 1,
			2, 2, 2, 2
		];

		var distanceMap = map.distanceFill(1);
		Assert.same(expected, distanceMap._mapData);
	}

	public function test_walls() {
		map._mapData = [
			0, 0, 0, 0,
			0, 1, 1, 0,
			0, 1, 1, 1,
			0, 1, 1, 1
		];

		var expected = [
			0, 0, 0, 0,
			0, 1, 1, 0,
			0, 1, 1, 1,
			0, 1, 2, 2
		];

		var distanceMap = map.distanceFill(0);
		Assert.same(expected, distanceMap._mapData);
	}
}
