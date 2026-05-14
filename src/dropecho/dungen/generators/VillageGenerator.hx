package dropecho.dungen.generators;

import seedyrng.Random;
import dropecho.interop.Extender;
import dropecho.ds.BSPTree;
import dropecho.ds.BSPNode;
import dropecho.dungen.bsp.BSPData;
import dropecho.ds.algos.PostOrderTraversal;

typedef VillageConfigProps = {
	?tileCorridor:Int,
	?tileFloor:Int,
	?tileWall:Int,
	?padding:Int,
	?seed:String
}

class VillageParams {
	public var tileCorridor:Int = 1;
	public var tileFloor:Int = 1;
	public var tileWall:Int = 0;
	public var padding:Int = 0;
	public var seed:String = "0";

	public function new() {};
}

// TODO: MAke this basically the same as room gen
// except it should make hollow squares, and instead of connecting
// with corridors, place a random door along outside of building.
//
// Eventually, this could be improved by making the building itself
// a bsp or other gen internal to the chosen shape.

@:expose("dungen.VillageGenerator")
class VillageGenerator {
	public static function buildVillages(tree:BSPTree<BSPData>, ?opts:VillageConfigProps = null):Map2d {
		var params = Extender.defaults(new VillageParams(), opts);

		var rootvalue = tree
			.getRoot()
			.value;
		var map = new Map2d(rootvalue.width, rootvalue.height, params.tileCorridor);
		var rnd = new Random();
		rnd.setStringSeed(params.seed);

		function makeVillage(node:BSPNode<BSPData>):Bool {
			if (node.isLeaf() == false) {
				return true;
			}

			var lPad = Std.int(params.padding / 2);
			var rPad = Std.int(params.padding / 2) + params.padding % 2;

			var roomStartX:Int = node.value.x + 1 + lPad;
			var roomStartY:Int = node.value.y + 1 + lPad;
			var roomEndX:Int = (node.value.x + node.value.width) - 1 - rPad;
			var roomEndY:Int = (node.value.y + node.value.height) - 1 - rPad;

			if (roomStartX >= 4) {
				roomStartX -= 1;
			}
			if (roomStartY >= 4) {
				roomStartY -= 1;
			}

			var door = rnd.choice([true, false]) ? roomStartY : roomEndY - 1;

			for (x in roomStartX...roomEndX) {
				for (y in roomStartY...roomEndY) {
					var width = roomEndX - roomStartX;
					var center = roomStartX + Math.floor(width / 2);

					if (x == center && y == door) {
						continue;
					}

					if (x == roomStartX || x == roomEndX - 1 || y == roomStartY || y == roomEndY - 1) {
						map.set(x, y, params.tileWall);
					} else {
						map.set(x, y, params.tileFloor);
					}
				}
			}

			return true;
		}

		var visitor = new PostOrderTraversal();
		visitor.run(tree.root, makeVillage);
		return map;
	}
}
