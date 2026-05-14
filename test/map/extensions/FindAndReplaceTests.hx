package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.bsp.BSPBuilder;
import dropecho.dungen.generators.RoomGenerator;
import dropecho.dungen.Map2d;
import dropecho.dungen.Pattern;

class FindAndReplaceTests extends Test {
	public function test_find_and_replace_simple() {
		var map = new Map2d(2, 2);
		map._mapData = [
			0, 0,
			1, 0
		];
		var matcher = Pattern.init(2, [
			0, 0,
			1, 0
		]);
		var splat = Pattern.init(2, [
			0, 0,
			2, 0
		]);

		map.findAndReplace(matcher, splat);
		for (i in 0...map._mapData.length) {
			var splatTile = splat._mapData[i];
			var mapTile = map._mapData[i];
			Assert.equals(splatTile, mapTile);
		}
	}

	public function test_find_and_replace_ignore_tile() {
		var map = new Map2d(2, 2);
		map._mapData = [
			0, 0,
			1, 2,
		];
		var matcher = Pattern.init(2, [
			0, 0,
			1, -1,
		]);
		var splat = Pattern.init(2, [
			0, 0,
			2, -1,
		]);

		map.findAndReplace(matcher, splat);

		Assert.equals(0, map._mapData[0]);
		Assert.equals(0, map._mapData[1]);
		Assert.equals(2, map._mapData[2]);
		Assert.equals(2, map._mapData[3]);
	}

	@Ignored
	public function test_find_and_replace_bsp() {
		var bspGen = new BSPBuilder({
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
