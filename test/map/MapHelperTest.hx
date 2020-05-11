package map;

import massive.munit.Assert;
import dropecho.dungen.generators.ConvChain;
import dropecho.dungen.generators.CAGenerator;
import dropecho.dungen.Map2d;
import dropecho.dungen.map.MapHelper;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.generators.RoomGenerator;

class MapHelperTest {
	var map:Map2d;

	@Before
	public function setup() {
		map = new Map2d(8, 8, 0);
	}

	@Test
	public function get_first_empty_of_0_on_0_filled_map_should_return_non_null_tile() {
		var firstEmpty = MapHelper.getFirstEmptyTile(map, 0);
		Assert.isTrue(firstEmpty != null);
	}

	@Test
	public function get_first_empty_of_1_on_0_filled_map_should_return_null() {
		var firstEmpty = MapHelper.getFirstEmptyTile(map, 1);
		Assert.isTrue(firstEmpty == null);
	}

	// @Test
	// public function get_first_empty_of_0_on_random_0_1_filled_map_should_return_non_null_tile() {
	//   map.fillMapRandomly(1,0,50);
	//   var firstEmpty = MapHelper.getFirstEmptyTile(map, 0);
	//   Assert.isTrue(firstEmpty != null);
	// }

	@Test
	public function get_first_empty_of_1_on_manually_filled_array_without_ignore_array_should_return_non_null() {
		map.set(0, 0, 1);

		var firstEmpty = MapHelper.getFirstEmptyTile(map, 1);
		Assert.isTrue(firstEmpty != null);
	}

	@Test
	public function get_first_empty_of_1_on_manually_filled_array_with_ignore_array_should_return_null() {
		map.set(0, 0, 1);

		var ignore = map.IndexToXY(0);
		var ignoreArray = new Array<Tile2d>();

		ignoreArray.push(ignore);

		var firstEmpty = MapHelper.getFirstEmptyTile(map, 1, ignoreArray);
		Assert.isTrue(firstEmpty == null);
	}

	@Test
	public function floodfill_on_0_filled_map_should_return_array_same_as_map_size() {
		var filledTiles = MapHelper.floodFill(map, 0, 0, 0);

		Assert.areEqual(map._mapData.length, filledTiles.length);
	}

	@Test
	public function floodfill_on_manually_filled_map_should_return_top_row() {
		map.set(0, 1, 1);
		map.set(1, 1, 1);
		map.set(2, 1, 1);
		map.set(3, 1, 1);
		map.set(4, 1, 1);
		map.set(5, 1, 1);
		map.set(6, 1, 1);
		map.set(7, 1, 1);

		var filledTiles = MapHelper.floodFill(map, 0, 0, 0);

		// should flood fill only first row
		Assert.areEqual(8, filledTiles.length);
	}

	@Test
	public function floodfill_on_manually_filled_map_should_all_but_top_two_rows() {
		map.set(0, 1, 1);
		map.set(1, 1, 1);
		map.set(2, 1, 1);
		map.set(3, 1, 1);
		map.set(4, 1, 1);
		map.set(5, 1, 1);
		map.set(6, 1, 1);
		map.set(7, 1, 1);

		var filledTiles = MapHelper.floodFill(map, 2, 2, 0);

		// trace(map);
		// var filled = new Map2d(8,8,1);
		// for(tile in filledTiles) {
		//   filled.set(tile.x, tile.y, 0);
		// }
		//
		// trace(filled);

		// should flood fill all but first and second row first row
		Assert.areEqual(48, filledTiles.length);
	}

	@Test
	public function floodfill_with_diagonal_on_manually_filled_map_should_all_but_already_filled() {
		map.set(2, 0, 1);
		map.set(1, 1, 1);
		map.set(0, 2, 1);

		var filledTiles = MapHelper.floodFill(map, 2, 2, 0, true);

		// should fill all, including top left corner
		Assert.areEqual(61, filledTiles.length);
	}

	@Test
	public function floodfill_no_diagonal_on_manually_filled_map_should_all_but_top_left_corner() {
		map.set(2, 0, 1);
		map.set(1, 1, 1);
		map.set(0, 2, 1);

		var filledTiles = MapHelper.floodFill(map, 2, 2, 0, false);

		// should fill all but top left corner
		Assert.areEqual(58, filledTiles.length);
	}

	@Test
	public function isMapConnected_no_diagonal_on_manually_filled_map_should_return_false() {
		map.set(2, 0, 1);
		map.set(1, 1, 1);
		map.set(0, 2, 1);

		var connected = MapHelper.isMapConnected(map, 0, false);

		Assert.isFalse(connected);
	}

	@Test
	public function isMapConnected_with_diagonal_on_manually_filled_map_should_return_true() {
		map.set(2, 0, 1);
		map.set(1, 1, 1);
		map.set(0, 2, 1);

		var connected = MapHelper.isMapConnected(map, 0, true);

		Assert.isTrue(connected);
	}

	@Test
	public function isMapConnected_on_manually_filled_map_should_return_false_with_all_but_top_two_rows() {
		map.set(0, 1, 1);
		map.set(1, 1, 1);
		map.set(2, 1, 1);
		map.set(3, 1, 1);
		map.set(4, 1, 1);
		map.set(5, 1, 1);
		map.set(6, 1, 1);
		map.set(7, 1, 1);

		var connected = MapHelper.isMapConnected(map);

		// should flood fill all but first and second row first row
		Assert.isFalse(connected);
	}

	@Test
	public function is_connected_on_splat_house_with_no_door_should_be_false() {
		var bspGen = new Generator({
			width: 10,
			height: 10,
			minWidth: 3,
			minHeight: 3,
			depth: 2,
			ratio: .95,
		});

		var map = new Map2d(16, 16, 1);

		var sample = RoomGenerator.buildRooms(bspGen.generate());
		// sample.set(Std.int(Math.random() * 7) + 1, 9, 1);
		map.splat(sample, 4, 4);

		// trace(map);
		var connected = MapHelper.isMapConnected(map, 1);

		var filledTiles = MapHelper.floodFill(map, 0, 0, 1);

		var filled = new Map2d(16, 16, 1);
		for (tile in filledTiles) {
			filled.set(tile.x, tile.y, 0);
		}

		// trace(filled);

		// should flood fill all but first and second row first row
		Assert.isFalse(connected);
	}

	@Test
	public function is_connected_on_splat_house_with_door_should_be_true() {
		var bspGen = new Generator({
			width: 10,
			height: 10,
			minWidth: 3,
			minHeight: 3,
			depth: 2,
			ratio: .95,
		});

		var map = new Map2d(16, 16, 1);

		var sample = RoomGenerator.buildRooms(bspGen.generate());
		for (i in 0...9) {
			if (sample.get(i, 8) == 1) {
				sample.set(i, 9, 1);
				break;
			}
		}
		map.splat(sample, 4, 4);

		// trace(map);
		var connected = MapHelper.isMapConnected(map, 1);

		var filledTiles = MapHelper.floodFill(map, 0, 0, 1);

		var filled = new Map2d(16, 16, 1);
		for (tile in filledTiles) {
			filled.set(tile.x, tile.y, 0);
		}

		// trace(filled);

		// should flood fill all but first and second row first row
		Assert.isTrue(connected);
	}

	@Test
	public function distanceMap_on_splat_house_with_no_door_should_be_false() {
    // var bspGen = new Generator({
    //   width: 80,
    //   height: 40,
    //   minWidth: 6,
    //   minHeight: 6,
    //   depth: 10,
    //   ratio: .95
    // });
    //
    // var map = RoomGenerator.buildRooms(bspGen.generate());
    //
    var map = CAGenerator.generate({
      width: 80,
      height: 40,
      start_fill_percent: 64,
      tile_floor: 1,
      tile_wall: 0,
      seed: "1"
    });

    // trace(map);

		var distanceMap = MapHelper.distanceFill(map);
		// trace("distanceMap:" + distanceMap);

    var regionmap = MapHelper.expandRegions(distanceMap);
    // trace(regionmap.toPrettyString(['#', '+', '.']));
	}
}
