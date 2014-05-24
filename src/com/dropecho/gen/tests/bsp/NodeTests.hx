package com.dropecho.gen.tests.bsp;

import com.dropecho.gen.bsp.Node;

class NodeTests extends haxe.unit.TestCase {
    var node:Node;

    public override function setup(){
        node = new Node();
    }

    public function test_is_leaf_should_return_true_when_left_and_right_are_null(){
        node.left = null;
        node.right = null;

        assertTrue(node.isLeaf());
    }

    public function test_is_root_should_return_true_when_parent_is_null(){
        node.parent = null;

        assertTrue(node.isRoot());
    }
}
