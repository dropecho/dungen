package map.helpers;

import massive.munit.Assert;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.generators.RoomGenerator;
import dropecho.dungen.Map2d;
import dropecho.dungen.map.Pattern;

using dropecho.dungen.map.helpers.FindAndReplace;

class FindAndReplaceTest {
	@Test
	public function find_and_replace_simple() {
		var map = new Map2d(2, 2);
		map._mapData = [
			0, 0,
			1, 0,
		];
		var matcher = Pattern.init(2, [
			0, 0,
			1, 0,

		]);
		var splat = Pattern.init(2, [
			0, 0,
			2, 0,
		]);

		map.findAndReplace(matcher, splat);
		for (i in 0...map._mapData.length) {
			Assert.areEqual(splat._mapData[i], map._mapData[i]);
		}
	}

	@Test
	public function find_and_replace_ignore_tile() {
		var map = new Map2d(2, 2);
		map._mapData = [
			0, 0,
			1, 2,
		];
		var matcher = Pattern.init(2, [
			0, 0,
			1, 2,

		]);
		var splat = Pattern.init(2, [
			0, 0,
			2, -1,
		]);

		map.findAndReplace(matcher, splat);

    Assert.areEqual(0, map._mapData[0]);
    Assert.areEqual(0, map._mapData[1]);
    Assert.areEqual(2, map._mapData[2]);
    Assert.areEqual(2, map._mapData[3]);
	}

	@Test
	public function find_and_replace_bsp() {
		var bspGen = new Generator({
			width: 10,
			height: 10,
			minWidth: 3,
			minHeight: 3,
			depth: 10,
			ratio: .95
		});

		var map = RoomGenerator.buildRooms(bspGen.generate());

		var matcher = Pattern.init(3, [
			1, 1, 1,
			0, 1, 0,
			1, 1, 1,

		]);
		var splat = Pattern.init(3, [
			1, 1, 1,
			0, 2, 0,
			1, 1, 1,
		]);
		var matcher3 = Pattern.init(3, [
			1, 1, 0,
			0, 1, 0,
			1, 1, 1,

		]);
		var splat3 = Pattern.init(3, [
			1, 1, 0,
			0, 2, 0,
			1, 1, 1,
		]);

		var matcher2 = Pattern.init(4, [
			1, 1, 1, 1,
			0, 1, 1, 0,
			1, 1, 1, 1,
			1, 1, 1, 1

		]);
		var splat2 = Pattern.init(4, [
			1, 1, 1, 1,
			0, 2, 2, 0,
			1, 1, 1, 1,
			1, 1, 1, 1
		]);
		// trace('before: ' + map.toPrettyString(["#", ".", "+"]));

		map = map.findAndReplace(matcher, splat);
		map = map.findAndReplace(matcher3, splat3);
		map = map.findAndReplace(matcher2, splat2);

		// trace('after: ' + map.toPrettyString(["#", ".", "+"]));
	}
}
