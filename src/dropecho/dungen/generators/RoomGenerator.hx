package dropecho.dungen.generators;

import dropecho.interop.Extender;
import dropecho.ds.BSPTree;
import dropecho.ds.BSPNode;
import dropecho.ds.algos.PostOrderTraversal;

class RoomParams {
	public var tileCorridor:Int = 1;
	public var tileFloor:Int = 1;
	public var tileWall:Int = 0;
	public var padding:Int = 0;

	public function new() {};
}

@:expose("dungen.RoomGenerator")
class RoomGenerator {
	public static function buildRooms(tree:BSPTree, ?opts:Dynamic = null):Map2d {
		var params = Extender.defaults(new RoomParams(), opts);

		var rootvalue = tree.getRoot().value;
		var map = new Map2d(rootvalue.width, rootvalue.height, params.tileWall);

		function makeRoom(node:BSPNode):Bool {
			if (node.hasLeft() || node.hasRight()) {
				return true;
			}

			var lPad = Std.int(params.padding / 2);
			var rPad = Std.int(params.padding / 2) + params.padding % 2;

			var roomStartX:Int = node.value.x + 1 + lPad;
			var roomStartY:Int = node.value.y + 1 + lPad;
			var roomEndX:Int = (node.value.x + node.value.width) - 1 - rPad;
			var roomEndY:Int = (node.value.y + node.value.height) - 1 - rPad;

			if (roomStartX != 1) {
				roomStartX -= 1;
			}
			if (roomStartY != 1) {
				roomStartY -= 1;
			}

			for (x in roomStartX...roomEndX) {
				for (y in roomStartY...roomEndY) {
					map.set(x, y, params.tileFloor);
				}
			}

			return true;
		}

		function makeCorridors(node:BSPNode):Bool {
			if (!node.hasLeft() && !node.hasRight()) {
				return true;
			}

			var leftXcenter:Int = Std.int(node.left.value.x + node.left.value.width / 2);
			var leftYcenter:Int = Std.int(node.left.value.y + node.left.value.height / 2);
			var rightXcenter:Int = Std.int(node.right.value.x + node.right.value.width / 2);
			var rightYcenter:Int = Std.int(node.right.value.y + node.right.value.height / 2);

			var startX = leftXcenter <= rightXcenter ? leftXcenter : rightXcenter;
			var endX = leftXcenter >= rightXcenter ? leftXcenter : rightXcenter;
			var startY = leftYcenter <= rightYcenter ? leftYcenter : rightYcenter;
			var endY = leftYcenter >= rightYcenter ? leftYcenter : rightYcenter;

			// draw a corridor from the center x to the center x
			for (x in startX...endX) {
				if (map.get(x, startY) != params.tileFloor) {
					map.set(x, startY, params.tileCorridor);
				}
			}

			// draw a corridor from the center y to the center y
			for (y in startY...endY) {
				if (map.get(startX, y) != params.tileFloor) {
					map.set(startX, y, params.tileCorridor);
				}
			}
			return true;
		}

		var visitor = new PostOrderTraversal();

		visitor.run(tree.root, makeRoom);
		visitor.visited.resize(0);
		visitor.run(tree.root, makeCorridors);

		return map;
	}
}
