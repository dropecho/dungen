package com.dropecho.gen.bsp;

import com.dropecho.gen.utils.Extender;

@:expose("degen.bspGenerator")
class Generator {
    public var width:Int = 256;
    public var height:Int = 256;
    public var depth:Int = 10;
    public var minNodeWidth:Int = 10;
    public var minNodeHeight:Int = 10;
    public var x:Int = 0;
    public var y:Int = 0;

    public function new(?ops:Dynamic){
        Extender.extend(this, ops);
    }

    public function generate(root:Node = null){
        if(root == null){
            root = new Node({height: height, width: width, x: x, y: y});
        }
        buildTree(root);

        return root;
    }

    private function buildTree(node:Node, ?level:Int = 0){
        if(node == null || level >= depth){
            return;
        }

        makeSplit(node, Std.random(1) == 1);
        buildTree(node.left, level + 1);
        buildTree(node.right, level + 1);
    }

    private function makeSplit(node, splitVertically){
        var splitAt = 0;
        var calcWidth = node.width - minNodeWidth;
        var calcHeight = node.height - minNodeHeight;

        var notEnoughSpaceForSplit = calcWidth <= minNodeWidth || calcHeight <= minNodeHeight;

        if(notEnoughSpaceForSplit){
            splitVertically = !splitVertically; //If too small for split, flip it.

            if((!splitVertically && calcWidth <= (minNodeWidth * 2)) || (splitVertically && calcHeight <= (minNodeHeight *2))){
                return; //If still too small, just return.
            }
        }

        if(splitVertically){

            splitAt = Std.random(calcHeight - minNodeHeight) + minNodeHeight;

            node.left = new Node({height: splitAt, width: node.width, parent: node, x: node.x, y: node.y});
            var rHeight = node.height - splitAt;
            node.right = new Node({height: rHeight, width: node.width, parent: node, x: node.x, y: node.y + splitAt});
        } else {
            splitAt = Std.random(calcWidth - minNodeWidth) + minNodeWidth;

            node.left = new Node({height: node.height, width: splitAt, parent: node, x: node.x, y: node.y});
            var rWidth = node.width - splitAt;
            node.right = new Node({height: node.height, width: rWidth,parent: node, x: node.x + splitAt, y: node.y});
        }
    }
}
