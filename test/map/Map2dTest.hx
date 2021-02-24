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
import dropecho.dungen.generators.WalkGenerator;

using dropecho.dungen.map.Map2dExtensions;
using dropecho.dungen.map.extensions.Neighbors;
using dropecho.dungen.map.extensions.Splat;
using dropecho.dungen.map.extensions.Utils;

class Map2dTest {
	public function ArraysEqual(expected:Array<Int>, value:Array<Int>) {
		var equal = false;
		for (i in 0...expected.length) {
			equal = expected[i] == value[i];
		}

		return equal;
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

		var tiles = sample.getRect({
			x: 0,
			y: 1,
			width: 2,
			height: 2
		});

		Assert.areEqual(4, tiles.length);
	}

	@Test
	public function get_rect_on_edge_should_return_wrapped() {
		var sample = new Map2d(2, 2);
		sample._mapData = [
			1, 0,
			0, 1
		];

		var tiles = sample.getRect({
			x: 0,
			y: 0,
			width: 2,
			height: 2
		}, true);
		var tiles2 = sample.getRect({
			x: 0,
			y: 1,
			width: 2,
			height: 2
		}, true);
		var tiles3 = sample.getRect({
			x: 1,
			y: 1,
			width: 2,
			height: 2
		}, true);

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
	public function get_rect_big_should_return_correct() {
		var sample = new Map2d(4, 4);
		sample._mapData = [
			0, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 2, 0,
			0, 0, 0, 3,
		];

		var tiles = sample.getRect({
			x: 0,
			y: 0,
			width: 4,
			height: 4
		}, true);
		// var tiles = sample.getRect(1, 1, 3, 3, true);

		var tiles_expected = [
			0, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 2, 0,
			0, 0, 0, 3,
		];
		Assert.isTrue(ArraysEqual(tiles_expected, tiles));
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

	// @Test
	// public function bspMapTest() {
	//   var opts = {
	//     width: 24,
	//     height: 12,
	//     start_fill_percent: 64,
	//     // tile_floor: 1,
	//     // tile_wall: 0,
	//     seed: "0"
	//   };
	//   var sample = WalkGenerator.generate(opts);
  //
	//   // var bsp = new Generator({
	//   //   width: 12,
	//   //   height: 8,
	//   //   minWidth: 3,
	//   //   minHeight: 3,
	//   //   depth: 1,
	//   //   ratio: .95
	//   // }).generate();
  //
	//   // var sample = RoomGenerator.buildRooms(bsp);
  //
	//   // var sample = new Map2d(4, 4);
	//   // sample._mapData = [
	//   //   1, 1, 1, 1,
	//   //   1, 0, 0, 0,
	//   //   1, 0, 1, 0,
	//   //   1, 0, 0, 0,
	//   // ];
  //
	//   // var sample = new Map2d(3, 3);
	//   // sample._mapData = [0, 1, 1, 1, 1, 1, 1, 1, 1];
	//   // sample._mapData = [1, 1, 1, 0, 0, 0, 0, 0, 0];
	//   // var sample = new Map2d(5, 5);
	//   // sample._mapData = [
	//   //   0, 0, 1, 0, 0,
	//   //   0, 1, 1, 1, 0,
	//   //   1, 1, 1, 1, 1,
	//   //   0, 1, 1, 1, 0,
	//   //   0, 0, 1, 0, 0
	//   // ];
  //
	//   trace(sample.toPrettyString());
	//   var gen = new ConvChain(sample);
	//   var map = gen.generate(80, 40, 3, 0.1, 4);
  //
	//   // trace(map.toPrettyString());
	//   Assert.isTrue(true);
	// }
  //
  //
