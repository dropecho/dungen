package map;

import dropecho.dungen.map.extensions.RegionManager;
import massive.munit.Assert;
import dropecho.dungen.generators.CAGenerator;
import dropecho.dungen.RegionMap;
import dropecho.dungen.Map2d;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.bsp.BspData;
import dropecho.dungen.generators.RoomGenerator;

using dropecho.dungen.map.extensions.DistanceFill;
using dropecho.dungen.map.extensions.Utils;
using dropecho.dungen.map.Map2dExtensions;

class RegionMapTest {
	@Test
	public function bspMapTest() {
		var bsp = new Generator({
			width: 32,
			height: 24,
			minWidth: 3,
			minHeight: 3,
			depth: 3,
			ratio: .95,
		}).generate();

		var map = RoomGenerator.buildRooms(bsp, {
			tileCorridor: 1,
			tileFloor: 2,
			padding: 1
		});
		// trace(map.toPrettyString());

		var regionMap = new RegionMap(map, 2, false, false);

		// var borderMap = RegionManager.findAndTagBorders(map, 1);

		// trace(regionMap.toPrettyString([' ', '.', '1', '2', '3', '4','5', '6', '7', '8', '9']));
		// trace(regionMap.toRegionBorderString());
		// trace(borderMap.toPrettyString([' ', '.', '1', '2', '3', '4','5', '6', '7', '8', '9']));
		// trace(borderMap);

		// trace(regionMap.toRegionBorderIdString());
		// trace(regionMap.graph);

		Assert.isTrue(true);
	}

	@Test
	public function CATest() {
		var map = CAGenerator.generate({
			width: 64,
			height: 32,
			start_fill_percent: 60,
			tile_floor: 1,
			tile_wall: 0,
			seed: "1",
		});

		map.setAllEdgesTo();

		var regionmap = new RegionMap(map, 2);

		// for (i in 0...regionmap._mapData.length) {
		//   if (regionmap._mapData[i] > 0) {
		//     regionmap._mapData[i] = 2;
		//   }
		// }


		// trace(regionmap.borders.keys());
		// trace(regionmap.toPrettyString(["█", '1', '2', '3', '4','5', '6', '7', '8', '9', ' ', ' ', ' ', ' ',' ', ' ', ' ', ' ',' ', ' ', ' ', ' ',' ', ' ', ' ', ' ',]));
		// trace(regionmap.toRegionBorderString());
		// trace(regionmap.toRegionBorderIdString());

		// trace(regionmap.toStringSingleRegion(5));

		// trace(regionmap.graph);
		Assert.isTrue(true);
	}
}
