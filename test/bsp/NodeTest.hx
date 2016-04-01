package bsp;

import massive.munit.Assert;
import degen.bsp.Node;

class NodeTest {
    var node:Node;

	@Before
    public function setup(){
        node = new Node();
    }

	@Test
    public function test_is_leaf_should_return_true_when_left_and_right_are_null(){
        node.left = null;
        node.right = null;

        Assert.isTrue(node.isLeaf());
    }

	@Test
    public function test_is_root_should_return_true_when_parent_is_null(){
        node.parent = null;

        Assert.isTrue(node.isRoot());
    }
}
