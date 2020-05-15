package map.helpers;

import massive.munit.Assert;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.generators.RoomGenerator;
import dropecho.dungen.Map2d;
import dropecho.dungen.map.Pattern;
import dropecho.dungen.map.helpers.FindAndReplace;

class FindAndReplaceTest {
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

		// var map = CAGenerator.generate({
		//   width: 80,
		//   height: 40,
		//   start_fill_percent: 64,
		//   tile_floor: 1,
		//   tile_wall: 0,
		//   seed: "1"
		// });

		// var map = new Map2d(6, 6);
		// var testData = [
		//   0, 2, 2, 0, 0, 0,
		//   0, 2, 2, 0, 2, 0,
		//   0, 0, 2, 2, 2, 0,
		//   0, 2, 2, 0, 2, 0,
		//   0, 0, 2, 0, 2, 0,
		//   0, 2, 2, 0, 0, 0,
		// ];
		// map._mapData = testData;

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

		map = FindAndReplace.run(map, matcher, splat);
		map = FindAndReplace.run(map, matcher3, splat3);
		map = FindAndReplace.run(map, matcher2, splat2);

		// trace('after: ' + map.toPrettyString(["#", ".", "+"]));
	}
}
