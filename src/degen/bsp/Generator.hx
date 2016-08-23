package degen.bsp;

import degen.utils.Extender;
import de.polygonal.ds.BinaryTreeNode;

@:expose("degen.BSPGenerator")
class Generator {
  public var width:Int = 120;
  public var height:Int = 60;
  public var minHeight:Int = 10;
  public var minWidth:Int = 10;
  public var depth:Int = 10;
  public var ratio:Float = .45;
  public var x:Int = 0;
  public var y:Int = 0;

  public function new(?ops:Dynamic){
    Extender.extend(this, ops);
  }

  public function generate(root:BinaryTreeNode<BspData> = null):BinaryTreeNode<BspData>{
    if(root == null){
      var rootData = new BspData({height: height, width: width, x: x, y: y});
      root = new BinaryTreeNode<BspData>(rootData);
    }

    buildTree(root);

    return root;
  }

  private function buildTree(node:BinaryTreeNode<BspData>, ?level:Int = 0):Void{
    if(node == null || level >= depth){
      return;
    }

    makeSplit(node);
    buildTree(node.left, level + 1);
    buildTree(node.right, level + 1);
  }

  private function makeSplit(node:BinaryTreeNode<BspData>):Void{
    var val = node.val;
    var lData : BspData;
    var rData : BspData;

    //Times two because you need to fit two child nodes into this one.
    if(val.width < minWidth * 2 && val.height < minHeight * 2){
      return;
    }

    var splitAt = 0;
    var vertical : Bool;

    if(val.height < 2 * minHeight || val.width > val.height * ratio){
      vertical = false;
    } else if(val.width < 2 * minWidth || val.height > val.width * ratio){
      vertical = true;
    } else {
      return;
    }

    if(vertical){
      splitAt = Std.random(val.height - (minHeight * 2)) + minHeight;
      var rHeight = val.height - splitAt;

      lData = new BspData({height: splitAt, width: val.width, parent: val, x: val.x, y: val.y});
      rData = new BspData({height: rHeight, width: val.width, parent: val, x: val.x, y: val.y + splitAt});
    } else {
      splitAt = Std.random(val.width - (minWidth * 2)) + minWidth;
      var rWidth = val.width - splitAt;

      lData = new BspData({height: val.height, width: splitAt, parent: val, x: val.x, y: val.y});
      rData = new BspData({height: val.height, width: rWidth, parent: val, x: val.x + splitAt, y: val.y});
    }

    node.left = new BinaryTreeNode<BspData>(lData);
    node.right = new BinaryTreeNode<BspData>(rData);

    return;
  }
}
