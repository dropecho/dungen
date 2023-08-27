package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;

using dropecho.dungen.map.extensions.DistanceFill;

class DistanceFillTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(4, 4, 0);
	}

	public function test_distance_fill_small() {
		var map2 = new Map2d(4, 1, 0);
		map2._mapData = [0, 1, 0, 0,];

		var expected = [1, 0, 1, 2,];

		var distanceMap = map2.distanceFill(1);

		for (i in 0...distanceMap._mapData.length) {
			Assert.equals(expected[i], distanceMap._mapData[i]);
		}
	}

	public function test_distance_fill() {
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

		for (i in 0...distanceMap._mapData.length) {
			Assert.equals(expected[i], distanceMap._mapData[i]);
		}
	}
}
