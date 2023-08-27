package bsp;

import utest.Assert;
import utest.Test;
import dropecho.dungen.bsp.Generator;
import dropecho.dungen.bsp.BSPData;
import dropecho.ds.BSPNode;
import dropecho.ds.algos.InOrderTraversal;

class GeneratorTests extends Test {
	var generator:Generator;
	var visitor:InOrderTraversal;
	var testCount:Int = 1;

	public function setup() {
		generator = new Generator();
		visitor = new InOrderTraversal();
		visitor.visited.resize(0);
	}

	public function test_given_a_depth_of_0_it_should_generate_a_single_node() {
		generator.depth = 0;
		var root = generator
			.generate()
			.root;

		Assert.isTrue(!root.hasLeft() && !root.hasRight());
	}

	public function test_given_a_depth_of_1_it_should_generate_a_single_level_tree() {
		generator.depth = 1;
		var root = generator
			.generate()
			.root;

		Assert.isFalse(!root.hasLeft() && !root.hasRight());
		Assert.isTrue(!root.right.hasLeft());
		Assert.isTrue(!root.left.hasLeft());
	}

	public function test_given_a_min_height_every_generated_node_should_have_a_greater_height() {
		generator.depth = 50;
		generator.minHeight = 10;
		generator.ratio = 1;
		var root = generator
			.generate()
			.root;

		visitor.run(root, (node:BSPNode<BSPData>) -> {
			Assert.isTrue(node.value.height >= 10);
			return true;
		});
	}

	public function test_given_a_min_width_every_generated_node_should_have_a_greater_width() {
		generator.depth = 50;
		generator.minWidth = 10;
		generator.ratio = 1;
		var tree = generator.generate();

		visitor.run(tree.root, function(node:BSPNode<BSPData>) {
			Assert.isTrue(node.value.width >= 10);
			return true;
		});
	}

	public function test_given_a_min_width_every_generated_node_should_have_a_ratio_greater_than_given() {
		generator.depth = 4;
		var root = generator
			.generate()
			.root;

		visitor.run(root, function(node:BSPNode<BSPData>) {
			Assert.isTrue(node.value.width / node.value.height >= generator.ratio
				|| node.value.height / node.value.width >= generator.ratio);
			return true;
		});
	}

	public function test_given_a_tree_every_set_of_child_nodes_should_add_up_to_the_height_and_width_of_their_parents() {
		for (_ in 0...testCount) {
			generator.depth = 4;
			var tree = generator.generate();

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
			generator.depth = 4;
			var tree = generator.generate();
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
			generator.depth = 4;
			var tree = generator.generate();

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
