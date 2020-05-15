package map.helpers;

import massive.munit.Assert;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.generators.RoomGenerator;
import dropecho.dungen.Map2d;
import dropecho.dungen.map.Pattern;

using dropecho.dungen.map.helpers.DistanceFill;

class DistanceFillTest {
	var map:Map2d;

	@Before
	public function setup() {
		map = new Map2d(4, 4, 0);
	}

	@Test
	public function distance_fill() {
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

    // trace(distanceMap);

		for (i in 0...distanceMap._mapData.length) {
			Assert.areEqual(expected[i], distanceMap._mapData[i]);
		}
	}
}
