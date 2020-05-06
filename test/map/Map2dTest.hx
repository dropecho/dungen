package map;

import massive.munit.Assert;
import dropecho.dungen.map.Map2d;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.bsp.BspData;
import dropecho.dungen.map.generators.RoomGenerator;
import dropecho.dungen.map.generators.MixedGenerator;
import dropecho.dungen.map.generators.RandomGenerator;
import dropecho.dungen.ca.Generator as CaGen;

class Map2dTest {
	@Test
	public function bspMapTest() {
		// var map = RandomGenerator.generate({
		//   width: 80,
		//   height: 40,
		//   start_fill_percent: 52,
		//   tile_floor: 46,
		//   tile_wall: 35
		// });
		var map = CaGen.generate({
			width: 80,
			height: 40,
			start_fill_percent: 52,
			tile_floor: 46,
			tile_wall: 35,
			steps: [
				{
					reps: 2,
					r1_cutoff: 5,
					r2_cutoff: 2
				},
				{
					reps: 2,
					r1_cutoff: 5,
					r2_cutoff: 0
				},
				{
					reps: 2,
					r1_cutoff: 5,
					r2_cutoff: 2
				},
				{
					reps: 2,
					r1_cutoff: 5,
					r2_cutoff: 0
				}
			]
		});

		// var bsp = new Generator({
		//   width: 64,
		//   height: 32,
		//   minWidth: 8,
		//   minHeight: 8,
		//   depth: 6,
		//   ratio: .95
		// }).generate();
		//
		// var map = RoomGenerator.buildRooms(bsp, {tileFloor: 46, tileWall: 35});
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
}
