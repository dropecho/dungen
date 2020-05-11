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
	public function ArraysEqual(expected:Array<Int>, value:Array<Int>) {
		var equal = false;
		for (i in 0...expected.length) {
			equal = expected[i] == value[i];
		}

		return equal;
	}

	@Test
	public function bspMapTest() {
    var sample = CAGenerator.generate({
      width: 30,
      height: 15,
      start_fill_percent: 65,
      tile_floor: 1,
      tile_wall: 0,
      seed: "0"
    });

    // var bsp = new Generator({
    //   width: 12,
    //   height: 8,
    //   minWidth: 3,
    //   minHeight: 3,
    //   depth: 1,
    //   ratio: .95
    // }).generate();

    // var sample = RoomGenerator.buildRooms(bsp);

		// var sample = new Map2d(4, 4);
		// sample._mapData = [
		//   1, 1, 1, 1,
		//   1, 0, 0, 0,
		//   1, 0, 1, 0,
		//   1, 0, 0, 0,
		// ];

		// var sample = new Map2d(3, 3);
		// sample._mapData = [0, 1, 1, 1, 1, 1, 1, 1, 1];
		// sample._mapData = [1, 1, 1, 0, 0, 0, 0, 0, 0];
    // var sample = new Map2d(5, 5);
    // sample._mapData = [
    //   0, 0, 1, 0, 0,
    //   0, 1, 1, 1, 0,
    //   1, 1, 1, 1, 1,
    //   0, 1, 1, 1, 0,
    //   0, 0, 1, 0, 0
    // ];

		// trace(sample.toPrettyString());
		var gen = new ConvChain(sample);
		var map = gen.generate(80, 40, 3, 0.1, 4);

		// trace(map.toPrettyString());
		Assert.isTrue(true);
	}

	@Test
	public function get_neighbors_should_return_all_neighbors_of_tile() {
		var map = new Map2d(4, 4);

		var neighbors = map.getNeighbors(0, 0);
		Assert.areEqual(neighbors.length, 3);
	}

	@Test
	public function get_neighbors_should_return_all_nondiagonal_neighbors_of_tile() {
		var map = new Map2d(4, 4);

		var neighbors = map.getNeighbors(0, 0, 1, false);
		Assert.areEqual(neighbors.length, 2);
	}

	@Test
	public function get_neighbors_should_return_all_neighbors_of_tile_2() {
		var map = new Map2d(4, 4);

		var neighbors = map.getNeighbors(2, 2);
		Assert.areEqual(neighbors.length, 8);
	}

	@Test
	public function get_neighbors_should_return_all_non_diagonal_neighbors_of_tile_2() {
		var map = new Map2d(4, 4);

		var neighbors = map.getNeighbors(2, 2, 1, false);
		Assert.areEqual(4, neighbors.length);
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

	@Test
	public function get_rect_on_edge_should_return_wrapped() {
		var sample = new Map2d(2, 2);
		sample._mapData = [
			1, 0,
			0, 1
		];

		var tiles = sample.getRect(0, 0, 1, 1, true);
		var tiles2 = sample.getRect(0, 1, 1, 2, true);
		var tiles3 = sample.getRect(1, 1, 2, 2, true);

		Assert.areEqual(4, tiles.length);
		Assert.areEqual(4, tiles2.length);

		Assert.isTrue(ArraysEqual(sample._mapData, tiles));

		var tile_2_expected = [
			0, 1,
			1, 0
		];
		Assert.isTrue(ArraysEqual(tile_2_expected, tiles2));
		Assert.isTrue(ArraysEqual(sample._mapData, tiles3));
		// for (t in 0...tiles2.length) {
		//   Assert.areEqual(tile_2_expected[t], tiles2[t]);
		// }
	}

	@Test
	public function splat_should_place_sub_map_within_map() {
		var bspGen = new Generator({
			width: 10,
			height: 10,
			minWidth: 3,
			minHeight: 3,
			depth: 2,
			ratio: .95,
		});

		var map = new Map2d(32, 32, 1);

		for (i in 0...3) {
			for (j in 0...2) {
				var seed = Std.int(Math.random() * 99999);
				bspGen.seed = Std.string(seed);
				var sample = RoomGenerator.buildRooms(bspGen.generate());
				sample.set(Std.int(Math.random() * 7) + 1, 9, 1);
				map.splat(sample, i * 11, j * 16);
			}
		}
		// trace(map);
	}
}
