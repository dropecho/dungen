package degen.map.generators;
import degen.bsp.Node;

class RoomGenerator {
    public static function buildRooms(root : Node) : Map2d {
        var map = new Map2d(root.width, root.height);

        function makeRoom(node : Node){
            if(!node.isLeaf()){
                return;
            }

            var roomStartX:Int = node.x + Std.int(Math.random() * 2) + 1;
            var roomStartY:Int = node.y + Std.int(Math.random() * 2) + 1;
            var roomEndX:Int = (node.x + node.width) - Std.int(Math.random() * 2) - 1;
            var roomEndY:Int = (node.y + node.height) - Std.int(Math.random() * 2) - 1;

            for(x in roomStartX...roomEndX){
                for(y in roomStartY...roomEndY){
                    map.set(x,y, 1);
                }
            }
        }

        function makeCorridors(node:Node){
            if(node.isLeaf()){
                return;
            }

            var leftXcenter:Int = Std.int(node.left.x + node.left.width / 2);
            var leftYcenter:Int = Std.int(node.left.y + node.left.height / 2);
            var rightXcenter:Int = Std.int(node.right.x + node.right.width / 2);
            var rightYcenter:Int = Std.int(node.right.y + node.right.height / 2);

            var startX = leftXcenter <= rightXcenter ? leftXcenter : rightXcenter;
            var endX = leftXcenter >= rightXcenter ? leftXcenter : rightXcenter;
            var startY = leftYcenter <= rightYcenter ? leftYcenter : rightYcenter;
            var endY = leftYcenter >= rightYcenter ? leftYcenter : rightYcenter;

            //draw a corridor from the center x to the center x
            for(x in startX...endX){
                map.set(x, startY, 1);
            }

            //draw a corridor from the center y to the center y
            for(y in startY...endY){
                map.set(startX, y, 1);
            }
        }

        root.traversePostOrder(makeRoom);
        root.traversePostOrder(makeCorridors);

        return map;
    }
}
