package map.helpers;

import massive.munit.Assert;
import dropecho.dungen.generators.ConvChain;
import dropecho.dungen.generators.CAGenerator;
import dropecho.dungen.Map2d;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.generators.RoomGenerator;

using dropecho.dungen.map.helpers.GetFirstTileOfType;

class GetFirstTileOfType {
	var map:Map2d;

	@Before
	public function setup() {
		map = new Map2d(8, 8, 0);
	}

	@Test
	public function get_first_empty_of_0_on_0_filled_map_should_return_non_null_tile() {
		var firstEmpty = map.getFirstTileOfType(0);
		Assert.isTrue(firstEmpty != null);
	}

	@Test
	public function get_first_empty_of_1_on_0_filled_map_should_return_null() {
		var firstEmpty = map.getFirstTileOfType(1);
		Assert.isTrue(firstEmpty == null);
	}

	// @Test
	// public function get_first_empty_of_0_on_random_0_1_filled_map_should_return_non_null_tile() {
	//   map.fillMapRandomly(1, 0, 50);
	//   var firstEmpty = map.getFirstTileOfType(0);
	//   Assert.isTrue(firstEmpty != null);
	// }

	@Test
	public function get_first_empty_of_1_on_manually_filled_array_without_ignore_array_should_return_non_null() {
		map.set(0, 0, 1);

		var firstEmpty = map.getFirstTileOfType(1);
		Assert.isTrue(firstEmpty != null);
	}

	@Test
	public function get_first_empty_of_1_on_manually_filled_array_with_ignore_array_should_return_null() {
		map.set(0, 0, 1);

		var ignore = map.IndexToXY(0);
		var ignoreArray = new Array<Tile2d>();

		ignoreArray.push(ignore);

		var firstEmpty = map.getFirstTileOfType(1, ignoreArray);
		Assert.isTrue(firstEmpty == null);
	}
}
