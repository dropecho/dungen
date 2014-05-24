package com.dropecho.gen.bsp;

import com.dropecho.gen.utils.*;

class Node {
    public var width:Int = 0;
    public var height:Int = 0;
    public var parent:Node = null;
    public var left:Node = null;
    public var right:Node = null;
    public var x:Int = 0;
    public var y:Int = 0;

    public function new(ops:Dynamic){
        Extender.extend(this, ops);
    }

    function isLeaf(){
        return this.left == null && this.right == null;
    }

    function isRoot(){
        return this.parent == null;
    }

    function traversePreOrder(callback){
        callback(this);

        if(left != null){
            left.traversePreOrder(callback);
        }
        if(right != null){
            right.traversePreOrder(callback);
        }
    }

    function traverseInOrder(callback){
        if(left != null){
            left.traverseInOrder(callback);
        }

        callback(this);

        if(right != null){
            right.traverseInOrder(callback);
        }
    }

    function traversePostOrder(callback){
        if(left != null){
            left.traversePostOrder(callback);
        }
        if(right != null){
            right.traversePostOrder(callback);
        }

        callback(this);
    }
}
