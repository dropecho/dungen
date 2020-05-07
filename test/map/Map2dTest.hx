package map;

import massive.munit.Assert;
import dropecho.dungen.map.Map2d;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.convchain.ConvChain;
import dropecho.dungen.bsp.BspData;
import dropecho.dungen.map.generators.RoomGenerator;
import dropecho.dungen.map.generators.MixedGenerator;
import dropecho.dungen.map.generators.RandomGenerator;
import dropecho.dungen.ca.Generator as CaGen;

class Map2dTest {
	@Test
	public function bspMapTest() {
		var sample = CaGen.generate({
			width: 24,
			height: 12,
			start_fill_percent: 64,
			tile_floor: 1,
			tile_wall: 0
		});

		// var bsp = new Generator({
		//   width: 16,
		//   height: 16,
		//   minWidth: 3,
		//   minHeight: 3,
		//   depth: 1,
		//   ratio: .95
		// }).generate();

		// var sample = RoomGenerator.buildRooms(bsp);
		trace(sample);

		var gen = new ConvChain(sample);
		var map = gen.generate(80, 40, 4, 0.1, 10);

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
