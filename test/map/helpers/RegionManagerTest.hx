package map.helpers;

import massive.munit.Assert;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.generators.RoomGenerator;
import dropecho.dungen.generators.CAGenerator;
import dropecho.dungen.map.MapHelper;
import dropecho.dungen.map.helpers.RegionManager;

class RegionManagerTest {
	@Test
	public function region_tagging_only() {
		var map = CAGenerator.generate({
			width: 40,
			height: 20,
			start_fill_percent: 64,
			tile_floor: 1,
			tile_wall: 0,
			seed: "0",
		});

		map.ensureEdgesAreWalls();

		var distanceMap = MapHelper.distanceFill(map);
		var regionmap = RegionManager.findAndTagRegions(distanceMap);
    // trace(regionmap.toPrettyString([
    //   '#', '+', '.', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'j', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    //   'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '1', '2', '3',
    //   '4', '5', '6', '7', '8', '9'
    // ]));
	}

	@Test
	public function region_tagging_rooms() {
		var bspGen = new Generator({
			width: 40,
			height: 20,
			minWidth: 6,
			minHeight: 6,
			depth: 4,
			ratio: .95
		});

		var map = RoomGenerator.buildRooms(bspGen.generate());

		// trace(map.toPrettyString());

		var distanceMap = MapHelper.distanceFill(map);
		var regionmap = RegionManager.findAndTagRegions(distanceMap);
		regionmap = RegionManager.expandRegions(regionmap);
		// trace(regionmap.toPrettyString([
		//   '#', '+', '.', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'j', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
		//   'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '1', '2', '3',
		//   '4', '5', '6', '7', '8', '9'
		// ]));
	}

	@Test
	public function region_tagging_caves() {
		var map = CAGenerator.generate({
			width: 120,
			height: 60,
			start_fill_percent: 64,
			tile_floor: 1,
			tile_wall: 0,
			seed: "1",
		});

		map.ensureEdgesAreWalls();

		// trace(map.toPrettyString());

		var distanceMap = MapHelper.distanceFill(map);
		var regionmap = RegionManager.findAndTagRegions(distanceMap);
		regionmap = RegionManager.expandRegions(regionmap);
    // trace(regionmap.toPrettyString([
    //   '#', '+', '.', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'j', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    //   'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '1', '2', '3',
    //   '4', '5', '6', '7', '8', '9'
    // ]));

		for (i in 0...regionmap._mapData.length) {
			if (regionmap._mapData[i] > 1) {
				regionmap._mapData[i] = 2;
			}
		}

    // trace(regionmap.toPrettyString(["#","+","."]));
	}
}
