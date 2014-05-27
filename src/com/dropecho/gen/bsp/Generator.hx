package com.dropecho.gen.bsp;

import com.dropecho.gen.utils.Extender;

@:expose("degen.bspGenerator")
class Generator {
    public var width:Int = 256;
    public var height:Int = 256;
    public var minHeight:Int = 10;
    public var minWidth:Int = 10;
    public var depth:Int = 10;
    public var ratio:Float = .45;
    public var x:Int = 0;
    public var y:Int = 0;

    public function new(?ops:Dynamic){
        Extender.extend(this, ops);
    }

    public function generate(root:Node = null):Node{
        if(root == null){
            root = new Node({height: height, width: width, x: x, y: y});
        }
        buildTree(root);

        return root;
    }

    private function buildTree(node:Node, ?level:Int = 0):Void{
        if(node == null || level >= depth){
            return;
        }

        makeSplit(node);
        buildTree(node.left, level + 1);
        buildTree(node.right, level + 1);
    }

    private function makeSplit(node:Node):Void{
        var splitAt = 0;
        var vertical = Std.random(2) == 1;

        if(node.width > node.height * ratio){
            vertical = false;
        } else if(node.height > node.width * ratio){
            vertical = true;
        } else {
            return;
        }

        if(node.width < minWidth * 2 || node.height < minHeight * 2){
            return;
        }

        if(vertical){
            splitAt = Std.random(node.height - (minHeight * 2)) + minHeight;
            var rHeight = node.height - splitAt;

            node.left = new Node({height: splitAt, width: node.width, parent: node, x: node.x, y: node.y});
            node.right = new Node({height: rHeight, width: node.width, parent: node, x: node.x, y: node.y + splitAt});
        } else {
            splitAt = Std.random(node.width - (minWidth * 2)) + minWidth;
            var rWidth = node.width - splitAt;

            node.left = new Node({height: node.height, width: splitAt, parent: node, x: node.x, y: node.y});
            node.right = new Node({height: node.height, width: rWidth, parent: node, x: node.x + splitAt, y: node.y});
        }
    }
}
