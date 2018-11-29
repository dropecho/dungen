package degen.map.generators;

import degen.ca.Generator as CAGen;
import degen.utils.Extender;
import degen.map.helpers.Utils;

//All rooms are rectangles for now.
typedef Room = {
	var width: Int;
	var height: Int;
	var weight: Int;
};


@:expose("degen.FloorPlanGenerator")
class FloorPlanGenerator {
	public static function generate(?params:Dynamic) : Map2d {
		var width:Int = params.width;
		var height:Int = params.height;

		var tile_floor:Int = params.tile_floor;
		var tile_wall:Int = params.tile_wall;

		var map = new Map2d(width, height);

		var rooms = new Array<Room>();
		rooms.push({
			width: 20,
			height: 20,
			x: -999999,
			y: -999999,
		});
		rooms.push({
			width: 20,
			height: 20,
			x: -999999,
			y: -999999,
		});
		rooms.push({
			width: 20,
			height: 30,
			x: -999999,
			y: -999999,
		});
		rooms.push({
			width: 30,
			height: 20,
			x: -999999,
			y: -999999,
		});

		arrangeRooms(map, rooms);

		return map;
	}

	// private static shrinkRoomsByWeight(totalSize, rooms) {
	//   while( sum(rooms.size) > totalSize) {
	//     rooms.pickRandomByWeight().shrink();
	//   }
	// }

	private static function scaleFloorPlan(map, rooms) {
		//scale all rooms, by weight, until floorplan fits in space.
		//Take into account minimum sizes for rooms.
		//If all rooms hit minimum size based on weight, pop off lowest priority
		//rooms until floor plan fits in map/lot size.
	}

	private static function arrangeRooms(map, rooms) {
		var mapMidX = map.width / 2;
		var mapMidY = map.height / 2;

		var randomRooms = Utils.shuffleArray(rooms);

		//place other rooms "outside" map, and move towards centroid.
		for(r in randomRooms) {
			r.x = 500; //some random number outside of map.
			r.y = 500; //some random number outside of map.

			var isRight = r.x > mapMidX;
			var isAbove = r.y > mapMidY;

			while(!r.isOverlappingArray(r, rooms)) {
				r.x += isRight ? -1 : 1;
				r.y += isAbove ? -1 : 1;

        if(r.x == 0 && r.y == 0) {
          break;
        }
			}

      //assign room to map, actually set floor tiles.
		}
	}
}
