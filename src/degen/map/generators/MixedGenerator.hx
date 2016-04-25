package degen.map.generators;

import degen.bsp.BspData;
import de.polygonal.ds.BinaryTreeNode;
import degen.ca.Generator as CAGen;
import degen.utils.Extender;

class MixedGenerator {
    public static function buildRooms(root : BinaryTreeNode<BspData>, userData:Dynamic) :Map2d { //tile_floor:Int = 1, tile_wall:Int = 0) : Map2d {

			userData = Extender.extend({tile_wall: 0, tile_floor: 1}, userData);


			var rootVal = root.val;
			var map = new Map2d(rootVal.width, rootVal.height, userData.tile_wall);

			function makeRooms(node : BinaryTreeNode<BspData>, foo:Dynamic) : Bool{
				if(node.hasL() || node.hasR()){
					return true;
				}

				var roomStartX:Int = node.val.x + Std.int(Math.random() * 2) + 1;
				var roomStartY:Int = node.val.y + Std.int(Math.random() * 2) + 1;
				var roomEndX:Int = (node.val.x + node.val.width) - Std.int(Math.random() * 2) - 1;
				var roomEndY:Int = (node.val.y + node.val.height) - Std.int(Math.random() * 2) - 1;

				for(x in roomStartX...roomEndX){
					for(y in roomStartY...roomEndY){
						map.set(x,y, userData.tile_floor);
					}
				}

				return true;
			}

			function makeCaveFromCA(node: BinaryTreeNode<BspData>, userData:Dynamic) : Bool{
				if((node.hasL() || node.hasR()) && (node.r.hasR() || node.r.hasL() || node.l.hasR() || node.r.hasL())){
					return true;
				}

				var roomStartX:Int = node.val.x + Std.int(Math.random() * 2);
				var roomStartY:Int = node.val.y + Std.int(Math.random() * 2);

				var cave = CAGen.generate({height: node.val.height, width: node.val.width});

				for(x in 0...cave._width){
					for(y in 0...cave._height){
						map.set(x + roomStartX, y + roomStartY, cave.get(x,y));
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
					map.set(x, startY, userData.tile_floor);
				}

				//draw a corridor from the center y to the center y
				for(y in startY...endY){
					map.set(startX, y, userData.tile_floor);
				}
				return true;
			}

			function chooseRoomOrCave(node:BinaryTreeNode<BspData>, userData:Dynamic):Bool{
				if(Std.random(10) > 2){
					return makeRooms(node, null);
				}
				else{
					return makeCaveFromCA(node, null);
				}
			}
			
			function closeEdges(node:BinaryTreeNode<BspData>, userData:Dynamic):Bool{
				if(!node.isRoot()){
					return true;
				}

				for(x in 0...node.val.width){
					map.set(x, 0, userData.tile_wall);
					map.set(x, node.val.height, userData.tile_wall);
				}
				
				for(y in 0...node.val.height){
					map.set(0, y, userData.tile_wall);
					map.set(node.val.width, y, userData.tile_wall);
				}

				return false;
			}

			//root.postorder(makeRoom);
			//root.postorder(makeCaveFromCA);
			root.postorder(chooseRoomOrCave,false, userData);
			root.inorder(closeEdges,false, userData);
			root.postorder(makeCorridors,false, userData);

			return map;
    }
}
