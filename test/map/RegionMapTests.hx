package map;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.generators.CAGenerator;
import dropecho.dungen.RegionMap;
import dropecho.dungen.bsp.BSPBuilder;
import dropecho.dungen.generators.RoomGenerator;

using dropecho.dungen.map.extensions.DistanceFill;
using dropecho.dungen.map.extensions.Utils;
using dropecho.dungen.map.Map2dExtensions;

class RegionMapTests extends Test {
	public function test_manualTest() {
		var map = new Map2d(8, 8);

		map._mapData = [
			0, 0, 0, 0, 0, 1, 1, 1,
			0, 1, 1, 1, 0, 1, 1, 1,
			0, 1, 1, 1, 1, 1, 1, 1,
			0, 1, 1, 1, 1, 1, 1, 1,
			0, 1, 1, 0, 0, 0, 0, 0,
			0, 1, 1, 1, 0, 0, 0, 0,
			0, 1, 1, 1, 0, 0, 0, 0,
			0, 1, 1, 1, 0, 0, 0, 0
		];

		var regionMap = new RegionMap(map, 2, false);

		// var borderMap = RegionManager.findAndTagBorders(map, 1);

		//     trace(regionMap.toPrettyString(['`', '.', '1', '2', '3', '4', '5', '6', '7', '8', '9']));
		//     trace(regionMap.toRegionBorderString());
		// trace(borderMap.toPrettyString([' ', '.', '1', '2', '3', '4','5', '6', '7', '8', '9']));
		// trace(borderMap);

		//     trace(regionMap.toRegionBorderIdString());
		// trace(regionMap.graph);

		Assert.isTrue(regionMap != null);
	}

	public function test_bspMapTest() {
		var bsp = new BSPBuilder({
			width: 32,
			height: 24,
			minWidth: 3,
			minHeight: 3,
			depth: 3,
			ratio: .95,
		})
			.generate();

		var map = RoomGenerator.buildRooms(bsp, {
			tileCorridor: 1,
			tileFloor: 2,
			padding: 1
		});
		//     trace(map.toPrettyString());

		var regionMap = new RegionMap(map, 2, false);

		// var borderMap = RegionManager.findAndTagBorders(map, 1);

		// trace(regionMap.toPrettyString([' ', '.', '1', '2', '3', '4','5', '6', '7', '8', '9']));
		//     trace(regionMap.toRegionBorderString());
		// trace(borderMap.toPrettyString([' ', '.', '1', '2', '3', '4','5', '6', '7', '8', '9']));
		// trace(borderMap);

		//     trace(regionMap.toRegionBorderIdString());
		// trace(regionMap.graph);

		Assert.isTrue(regionMap != null);
	}

	public function test_CATest() {
		var params = new CA_PARAMS();
		params.width = 64;
		params.height = 32;
		params.start_fill_percent = 60;
		params.tile_floor = 1;
		params.tile_wall = 0;
		params.seed = "1";

		var map = CAGenerator.generate(params);

		map.setAllEdgesTo();

		var regionmap = new RegionMap(map, 2);

		//     for (i in 0...regionmap._mapData.length) {
		//       if (regionmap._mapData[i] > 0) {
		//         regionmap._mapData[i] = 2;
		//       }
		//     }

		//     trace(regionmap.borders.keys());
		//     trace(regionmap.toPrettyString([
		//       "█", '1', '2', '3', '4', '5', '6', '7', '8', '9', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
		//     ]));
		//     trace(regionmap.toRegionBorderString());
		//     trace(regionmap.toRegionBorderIdString());
		//
		//     trace(regionmap.toStringSingleRegion(5));

		//     trace(regionmap.graph);
		Assert.notNull(regionmap);
	}
}
