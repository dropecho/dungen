package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.generators.RoomGenerator;
import dropecho.dungen.generators.CAGenerator;
import dropecho.dungen.map.extensions.RegionManager;

using dropecho.dungen.map.extensions.DistanceFill;
using dropecho.dungen.map.Map2dExtensions;

class RegionManagerTests extends Test {
	@Ignored
	public function test_region_tagging_only() {
		var params = new CA_PARAMS();
		params.width = 40;
		params.height = 20;
		params.start_fill_percent = 64;
		params.tile_floor = 1;
		params.tile_wall = 0;
		params.seed = "0";

		var map = CAGenerator.generate(params);

		map.setAllEdgesTo();

		var distanceMap = map.distanceFill();
		var regionmap = RegionManager.findAndTagRegions(distanceMap);
		// trace(regionmap.toPrettyString([
		//   '#', '+', '.', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'j', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
		//   'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '1', '2', '3',
		//   '4', '5', '6', '7', '8', '9'
		// ]));
	}

	@Ignored
	public function test_region_tagging_rooms() {
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

		var distanceMap = map.distanceFill();
		var regionmap = RegionManager.findAndTagRegions(distanceMap);
		regionmap = RegionManager.expandRegions(regionmap);
		// trace(regionmap.toPrettyString([
		//   '#', '+', '.', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'j', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
		//   'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '1', '2', '3',
		//   '4', '5', '6', '7', '8', '9'
		// ]));
	}

	@Ignored
	public function test_region_tagging_caves() {
		var params = new CA_PARAMS();
		params.width = 60;
		params.height = 40;
		params.start_fill_percent = 64;
		params.tile_floor = 1;
		params.tile_wall = 0;
		params.seed = "1";

		var map = CAGenerator.generate(params);

		map.setAllEdgesTo();

		// trace(map.toPrettyString());

		var distanceMap = map.distanceFill();
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

		// trace(regionmap.toPrettyString(["#", "+", "."]));
	}
}
