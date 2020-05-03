package dropecho.dungen.map.generators;

import dropecho.dungen.utils.Extender;
import dropecho.dungen.bsp.BspData;
import dropecho.ds.BSPTree;
import dropecho.ds.BSPNode;
import dropecho.ds.algos.PostOrderTraversal;

typedef RoomParams = {
	tileFloor:Int,
	tileWall:Int,
	paddingRatio:Float
};

@:expose("dungen.RoomGenerator")
class RoomGenerator {
	private static var _params = {
		tileFloor: 1,
		tileWall: 0,
		paddingRatio: 0.001
	}

	public static function buildRooms(tree:BSPTree, ?params:Dynamic = null):Map2d {
		params = Extender.extend({}, [_params, params]);

		var rootvalue = tree.getRoot().value;
		var map = new Map2d(rootvalue.width, rootvalue.height, params.tileWall);

		function makeRoom(node:BSPNode):Bool {
			if (node.hasLeft() || node.hasRight()) {
				return true;
			}

			var xPadding = Std.int(Math.random() * (node.value.width * params.paddingRatio));
			var yPadding = Std.int(Math.random() * (node.value.height * params.paddingRatio));

			var roomStartX:Int = node.value.x + Std.int(xPadding) + 1;
			var roomStartY:Int = node.value.y + Std.int(xPadding) + 1;
			var roomEndX:Int = (node.value.x + node.value.width) - yPadding - 1;
			var roomEndY:Int = (node.value.y + node.value.height) - yPadding - 1;

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
				map.set(x, startY, params.tileFloor);
			}

			// draw a corridor from the center y to the center y
			for (y in startY...endY) {
				map.set(startX, y, params.tileFloor);
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
