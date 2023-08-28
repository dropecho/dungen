package bsp;

import utest.Assert;
import utest.Test;
import dropecho.dungen.bsp.BSPBuilder;
import dropecho.dungen.bsp.BSPData;
import dropecho.ds.BSPNode;
import dropecho.ds.algos.InOrderTraversal;

class BSPBuilderTests extends Test {
	var builder:BSPBuilder;
	var visitor:InOrderTraversal;
	var testCount:Int = 1;

	public function setup() {
		builder = new BSPBuilder();
		visitor = new InOrderTraversal();
		visitor.visited.resize(0);
	}

	public function test_given_a_depth_of_0_it_should_generate_a_single_node() {
		builder.depth = 0;
		var root = builder
			.generate()
			.root;

		Assert.isTrue(!root.hasLeft() && !root.hasRight());
	}

	public function test_given_a_depth_of_1_it_should_generate_a_single_level_tree() {
		builder.depth = 1;
		var root = builder
			.generate()
			.root;

		Assert.isFalse(!root.hasLeft() && !root.hasRight());
		Assert.isTrue(!root.right.hasLeft());
		Assert.isTrue(!root.left.hasLeft());
	}

	public function test_given_a_min_height_every_generated_node_should_have_a_greater_height() {
		builder.depth = 50;
		builder.minHeight = 10;
		builder.ratio = 1;
		var root = builder
			.generate()
			.root;

		visitor.run(root, (node:BSPNode<BSPData>) -> {
			Assert.isTrue(node.value.height >= 10);
			return true;
		});
	}

	public function test_given_a_min_width_every_generated_node_should_have_a_greater_width() {
		builder.depth = 50;
		builder.minWidth = 10;
		builder.ratio = 1;
		var tree = builder.generate();

		visitor.run(tree.root, function(node:BSPNode<BSPData>) {
			Assert.isTrue(node.value.width >= 10);
			return true;
		});
	}

	public function test_given_a_min_width_every_generated_node_should_have_a_ratio_greater_than_given() {
		builder.depth = 4;
		var root = builder
			.generate()
			.root;

		visitor.run(root, function(node:BSPNode<BSPData>) {
			Assert.isTrue(node.value.width / node.value.height >= builder.ratio || node.value.height / node.value.width >= builder.ratio);
			return true;
		});
	}

	public function test_given_a_tree_every_set_of_child_nodes_should_add_up_to_the_height_and_width_of_their_parents() {
		for (_ in 0...testCount) {
			builder.depth = 4;
			var tree = builder.generate();

			visitor.run(tree.root, function(node:BSPNode<BSPData>) {
				if (node.hasLeft() && node.hasRight()) {
					// vertical split
					if (node.left.value.height == node.value.height) {
						var childWidths = node.left.value.width + node.right.value.width;

						Assert.equals(node.value.width, childWidths);
						Assert.equals(node.value.height, node.right.value.height);
						Assert.equals(node.value.height, node.left.value.height);
					} else {
						var childHeights = node.left.value.height + node.right.value.height;
						Assert.equals(node.value.height, childHeights);
						Assert.equals(node.value.width, node.left.value.width);
						Assert.equals(node.value.width, node.right.value.width);
					}
				}
				return true;
			});
		}
	}

	public function test_given_a_tree_every_leafs_area_should_add_up_to_root_area() {
		for (_ in 0...testCount) {
			builder.depth = 4;
			var tree = builder.generate();
			var rootArea = tree.root.value.height * tree.root.value.width;
			var leafArea:Float = 0;

			visitor.run(tree.root, function(node:BSPNode<BSPData>) {
				if (node.isLeaf()) {
					var foo = node.value.height * node.value.width;
					leafArea += foo;
				}
				return true;
			});
			Assert.equals(rootArea, leafArea);
		}
	}

	public function test_given_a_tree_every_non_leaf_should_have_2_children() {
		for (_ in 0...testCount) {
			builder.depth = 4;
			var tree = builder.generate();

			visitor.run(tree.root, function(node:BSPNode<BSPData>) {
				if (node.hasLeft() && node.hasRight()) {
					Assert.isTrue(node.right != null);
					Assert.isTrue(node.left != null);
				}

				return true;
			});
		}
	}
}
