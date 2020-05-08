package map;

import massive.munit.Assert;
import dropecho.dungen.Map2d;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.generators.ConvChain;
import dropecho.dungen.bsp.BspData;
import dropecho.dungen.generators.RoomGenerator;
import dropecho.dungen.generators.MixedGenerator;
import dropecho.dungen.generators.RandomGenerator;
import dropecho.dungen.generators.CAGenerator;

class Map2dTest {
	@Test
	public function bspMapTest() {
		// var sample = CAGenerator.generate({
		//   width: 24,
		//   height: 12,
		//   start_fill_percent: 64,
		//   tile_floor: 1,
		//   tile_wall: 0
		// });

		// var bsp = new Generator({
		//   width: 12,
		//   height: 8,
		//   minWidth: 3,
		//   minHeight: 3,
		//   depth: 1,
		//   ratio: .95
		// }).generate();
		//
		// var sample = RoomGenerator.buildRooms(bsp);

		// var sample = new Map2d(4, 4);
		// sample._mapData = [
		//   1, 1, 1, 1,
		//   1, 0, 0, 0,
		//   1, 0, 1, 0,
		//   1, 0, 0, 0,
		// ];

    var sample = new Map2d(5, 5);
    sample._mapData = [
      1, 1, 0, 1, 1,
      1, 0, 0, 0, 1,
      0, 0, 0, 0, 0,
      1, 0, 0, 0, 1,
      1, 1, 0, 1, 1,
    ];

		trace(sample);
		var gen = new ConvChain(sample);
		var map = gen.generate(80, 40, 3, 0.1, 10);

		trace(map);
		Assert.isTrue(true);
	}

	@Test
	public function get_neighbors_should_return_all_neighbors_of_tile() {
		var map = new Map2d(4, 4);

		var neighbors = map.getNeighbors(0, 0);
		Assert.areEqual(neighbors.length, 3);
	}

	@Test
	public function get_neighbors_should_return_all_neighbors_of_tile_2() {
		var map = new Map2d(4, 4);

		var neighbors = map.getNeighbors(2, 2);
		Assert.areEqual(neighbors.length, 8);
	}

	@Test
	public function get_rect_should_return_correct_tiles() {
		var sample = new Map2d(8, 8);
		sample._mapData = [
			0, 0, 0, 0, 0, 0, 0, 0,
			1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0
		];

		var tiles = sample.getRect(0, 1, 1, 2);

		Assert.areEqual(4, tiles.length);
	}
}
