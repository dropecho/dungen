package degen.map.generators;
import degen.bsp.BspData;
import de.polygonal.ds.BinaryTreeNode;

class RoomGenerator {
    public static function buildRooms(root : BinaryTreeNode<BspData>, tile_floor:Int = 1, tile_wall:Int = 2) : Map2d {
        var rootVal = root.val;
        var map = new Map2d(rootVal.width, rootVal.height, tile_wall);

		function makeRoom(node : BinaryTreeNode<BspData>, foo:Dynamic) : Bool{
			if(node.hasL() || node.hasR()){
				return true;
			}

			var roomStartX:Int = node.val.x + Std.int(Math.random() * 2) + 1;
			var roomStartY:Int = node.val.y + Std.int(Math.random() * 2) + 1;
			var roomEndX:Int = (node.val.x + node.val.width) - Std.int(Math.random() * 2) - 1;
			var roomEndY:Int = (node.val.y + node.val.height) - Std.int(Math.random() * 2) - 1;

			for(x in roomStartX...roomEndX){
				for(y in roomStartY...roomEndY){
					map.set(x,y, tile_floor);
				}
			}

			return true;
		}

		function makeCorridors(node:BinaryTreeNode<BspData>, userData:Dynamic):Bool{
			if(!node.hasL() && !node.hasR()){
				return true;
			}

			var leftXcenter:Int = Std.int(node.l.val.x + node.l.val.width / 2);
			var leftYcenter:Int = Std.int(node.l.val.y + node.l.val.height / 2);
			var rightXcenter:Int = Std.int(node.r.val.x + node.r.val.width / 2);
			var rightYcenter:Int = Std.int(node.r.val.y + node.r.val.height / 2);

			var startX = leftXcenter <= rightXcenter ? leftXcenter : rightXcenter;
			var endX = leftXcenter >= rightXcenter ? leftXcenter : rightXcenter;
			var startY = leftYcenter <= rightYcenter ? leftYcenter : rightYcenter;
			var endY = leftYcenter >= rightYcenter ? leftYcenter : rightYcenter;

			//draw a corridor from the center x to the center x
			for(x in startX...endX){
				map.set(x, startY, tile_floor);
			}

			//draw a corridor from the center y to the center y
			for(y in startY...endY){
				map.set(startX, y, tile_floor);
			}
			return true;
		}

		root.postorder(makeRoom);
		root.postorder(makeCorridors);

        return map;
    }
}
