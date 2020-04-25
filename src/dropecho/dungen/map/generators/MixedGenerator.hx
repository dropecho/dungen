package dropecho.dungen.map.generators;

import dropecho.dungen.bsp.BspData;
import dropecho.dungen.ca.Generator as CAGen;
import dropecho.dungen.utils.Extender;
import dropecho.ds.BSPNode;
import dropecho.ds.BSPTree;
import dropecho.ds.algos.InOrderTraversal;
import dropecho.ds.algos.PostOrderTraversal;

class MixedGenerator {
	public static function buildRooms(tree:BSPTree, userData:Dynamic):Map2d { // tile_floor:Int = 1, tile_wall:Int = 0) : Map2d {

		userData = Extender.extend({tile_wall: 0, tile_floor: 1}, userData);

		var rootvalue = tree.root.value;
		var map = new Map2d(rootvalue.width, rootvalue.height, userData.tile_wall);

		function makeRooms(node:BSPNode):Bool {
			if (node.hasLeft() || node.hasRight()) {
				return true;
			}

			var roomStartX:Int = node.value.x + Std.int(Math.random() * 2) + 1;
			var roomStartY:Int = node.value.y + Std.int(Math.random() * 2) + 1;
			var roomEndX:Int = (node.value.x + node.value.width) - Std.int(Math.random() * 2) - 1;
			var roomEndY:Int = (node.value.y + node.value.height) - Std.int(Math.random() * 2) - 1;

			for (x in roomStartX...roomEndX) {
				for (y in roomStartY...roomEndY) {
					map.set(x, y, userData.tile_floor);
				}
			}

			return true;
		}

		function makeCaveFromCA(node:BSPNode):Bool {
			if ((node.hasLeft() || node.hasRight())
				&& (node.right.hasRight() || node.right.hasLeft() || node.left.hasRight() || node.left.hasLeft())) {
				return true;
			}

			var roomStartX:Int = node.value.x + Std.int(Math.random() * 2);
			var roomStartY:Int = node.value.y + Std.int(Math.random() * 2);

			var cave = CAGen.generate({height: node.value.height, width: node.value.width});

			for (x in 0...cave._width) {
				for (y in 0...cave._height) {
					map.set(x + roomStartX, y + roomStartY, cave.get(x, y));
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
				map.set(x, startY, userData.tile_floor);
			}

			// draw a corridor from the center y to the center y
			for (y in startY...endY) {
				map.set(startX, y, userData.tile_floor);
			}
			return true;
		}

		function chooseRoomOrCave(node:BSPNode):Bool {
			if (Std.random(10) > 2) {
				return makeRooms(node);
			} else {
				return makeCaveFromCA(node);
			}
		}

		function closeEdges(node:BSPNode):Bool {
			if (!node.isRoot()) {
				return true;
			}

			for (x in 0...node.value.width) {
				map.set(x, 0, userData.tile_wall);
				map.set(x, node.value.height, userData.tile_wall);
			}

			for (y in 0...node.value.height) {
				map.set(0, y, userData.tile_wall);
				map.set(node.value.width, y, userData.tile_wall);
			}

			return false;
		}

		var povisitor = new PostOrderTraversal();
		var invisitor = new InOrderTraversal();

		povisitor.run(tree.root, chooseRoomOrCave);
		povisitor.visited.resize(0);

		invisitor.run(tree.root, closeEdges);
		povisitor.run(tree.root, makeCorridors);

		// root.postorder(chooseRoomOrCave, false, userData);
		// root.inorder(closeEdges, false, userData);
		// root.postorder(makeCorridors, false, userData);
		//
		return map;
	}
}
