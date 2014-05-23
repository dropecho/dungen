package com.dropecho.gen.bsp;

class Generator {
    public var width:Int = 256;
    public var height:Int = 256;
    public var depth:Int = 10;
    public var minNodeWidth:Int = 10;
    public var minNodeHeight:Int = 10;
    public var x:Int = 0;
    public var y:Int = 0;

    public function generate(root:Node = null){
        buildTree(new Node({height: height, width: width, x: x, y: y}));
        return root;
    }

    public function buildTree(node:Node, ?level:Int = 0){
        if(node == null || level >= depth){
            return;
        }

        makeSplit(node, true); //DE.Math.RandBool());
        buildTree(node.left, level + 1);
        buildTree(node.right, level + 1);
    }

    function makeSplit(node, vertical){
        var splitAt = 0;
        var calcWidth = node.width - minNodeWidth;
        var calcHeight = node.height - minNodeHeight;

        if(calcWidth <= minNodeWidth || calcHeight <= minNodeHeight){
            vertical = !vertical; //If too small for split, flip it.
            if((!vertical && calcWidth <= (minNodeWidth * 2)) || (vertical && calcHeight <= (minNodeHeight  *2))){
                return; //If still too small, just return.
            }
        }

        if(vertical){
            splitAt = 0;//Math.round(DE.Math.Rand(minNodeHeight, calcHeight));

            node.left = new Node({height: splitAt, width: node.width, parent: node, x: node.x, y: node.y});
            var rHeight = node.height - splitAt;
            node.right = new Node({height: rHeight, width: node.width, parent: node, x: node.x, y: node.y + splitAt});
        } else {
            splitAt = 0; //Math.round(DE.Math.Rand(minNodeWidth, calcWidth));

            node.left = new Node({height: node.height, width: splitAt, parent: node, x: node.x, y: node.y});
            var rWidth = node.width - splitAt;
            node.right = new Node({height: node.height, width: rWidth,parent: node, x: node.x + splitAt, y: node.y});
        }
    }
}
