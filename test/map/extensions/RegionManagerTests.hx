package map.extensions;

import dropecho.dungen.regions.RegionManager;
import utest.Assert;
import utest.Test;
import dropecho.dungen.bsp.BSPBuilder;
import dropecho.dungen.generators.RoomGenerator;
import dropecho.dungen.generators.CAGenerator;

class RegionManagerTests extends Test {
	public function test_region_tagging_only() {
		var params = new CAParams();
		params.width = 100;
		params.height = 100;
		params.start_fill_percent = 64;
		params.tile_floor = 1;
		params.tile_wall = 0;
		params.seed = "0";

		var map = CAGenerator.generate(params);
		map.setMapBorderTo();

		var distanceMap = map.distanceFill();
		var regionmap = RegionManager.findAndTagRegions(distanceMap);
		regionmap = RegionManager.expandRegions(regionmap);

		Assert.notNull(regionmap);
		Assert.equals(100, regionmap._width);
		Assert.equals(100, regionmap._height);
		Assert.isTrue(regionmap._mapData.filter(v -> v > 2).length > 0);
	}

	public function test_region_tagging_rooms() {
		var bspGen = new BSPBuilder({
			width: 64,
			height: 64,
			minWidth: 6,
			minHeight: 6,
			depth: 4,
			ratio: .95
		});

		var map = RoomGenerator.buildRooms(bspGen.generate());

		var distanceMap = map.distanceFill();
		var regionmap = RegionManager.findAndTagRegions(distanceMap);
		regionmap = RegionManager.expandRegions(regionmap);

		Assert.notNull(regionmap);
		Assert.equals(64, regionmap._width);
		Assert.equals(64, regionmap._height);
		Assert.isTrue(regionmap._mapData.filter(v -> v > 2).length > 0);
	}

	public function test_region_tagging_caves() {
		var params = new CAParams();
		params.width = 60;
		params.height = 40;
		params.start_fill_percent = 64;
		params.tile_floor = 1;
		params.tile_wall = 0;
		params.seed = "1";

		var map = CAGenerator.generate(params);
		map.setMapBorderTo();

		var distanceMap = map.distanceFill();
		var regionmap = RegionManager.findAndTagRegions(distanceMap);
		regionmap = RegionManager.expandRegions(regionmap);

		Assert.notNull(regionmap);
		Assert.equals(60, regionmap._width);
		Assert.equals(40, regionmap._height);
		Assert.isTrue(regionmap._mapData.filter(v -> v > 2).length > 0);
	}
}
