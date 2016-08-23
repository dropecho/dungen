package degen.map.generators;

import degen.utils.Extender;
import degen.bsp.BspData;
import de.polygonal.ds.BinaryTreeNode;

typedef RoomParams = {
  tileFloor : Int,
  tileWall: Int,
  paddingRatio: Float
};

@:expose("degen.RoomGenerator")
class RoomGenerator {
  private static var _params = {
    tileFloor: 1,
    tileWall: 2,
    paddingRatio: 0.25
  }

  public static function buildRooms(root : BinaryTreeNode<BspData>, ?params:Dynamic) : Map2d {
    params = Extender.extend({}, [_params, params]);

    var rootVal = root.val;
    var map = new Map2d(rootVal.width, rootVal.height, params.tileWall);

    function makeRoom(node : BinaryTreeNode<BspData>, foo:Dynamic) : Bool{
      if(node.hasLeft() || node.hasRight()){
        return true;
      }

      var xPadding = Std.int(Math.random() * (node.val.width * params.paddingRatio));
      var yPadding = Std.int(Math.random() * (node.val.height * params.paddingRatio));

      var roomStartX:Int = node.val.x + Std.int(xPadding) + 1;
      var roomStartY:Int = node.val.y + Std.int(xPadding) + 1;
      var roomEndX:Int = (node.val.x + node.val.width) - yPadding - 1;
      var roomEndY:Int = (node.val.y + node.val.height) - yPadding - 1;

      for(x in roomStartX...roomEndX){
        for(y in roomStartY...roomEndY){
          map.set(x,y, params.tileFloor);
        }
      }

      return true;
    }

    function makeCorridors(node:BinaryTreeNode<BspData>, userData:Dynamic):Bool{
      if(!node.hasLeft() && !node.hasRight()){
        return true;
      }

      var leftXcenter:Int = Std.int(node.left.val.x + node.left.val.width / 2);
      var leftYcenter:Int = Std.int(node.left.val.y + node.left.val.height / 2);
      var rightXcenter:Int = Std.int(node.right.val.x + node.right.val.width / 2);
      var rightYcenter:Int = Std.int(node.right.val.y + node.right.val.height / 2);

      var startX = leftXcenter <= rightXcenter ? leftXcenter : rightXcenter;
      var endX = leftXcenter >= rightXcenter ? leftXcenter : rightXcenter;
      var startY = leftYcenter <= rightYcenter ? leftYcenter : rightYcenter;
      var endY = leftYcenter >= rightYcenter ? leftYcenter : rightYcenter;

      //draw a corridor from the center x to the center x
      for(x in startX...endX){
        map.set(x, startY, params.tileFloor);
      }

      //draw a corridor from the center y to the center y
      for(y in startY...endY){
        map.set(startX, y, params.tileFloor);
      }
      return true;
    }

    root.postorder(makeRoom);
    root.postorder(makeCorridors);

    return map;
  }
}
