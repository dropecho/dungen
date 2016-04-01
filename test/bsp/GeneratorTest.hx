package bsp;

import massive.munit.Assert;
import degen.bsp.Generator;

class GeneratorTest {
    var generator:Generator;

	@Before
    public function setup(){
        generator = new Generator();
    }

	@Test
    public function test_given_a_depth_of_0_it_should_generate_a_single_node(){
        generator.depth = 0;
        var root = generator.generate();

        Assert.isTrue(root.isLeaf());
    }

	@Test
	public function test_given_a_depth_of_1_it_should_generate_a_single_level_tree(){
		generator.depth = 1;
		var root = generator.generate();

		Assert.isFalse(root.isLeaf());
		Assert.isTrue(root.right.isLeaf());
		Assert.isTrue(root.left.isLeaf());
	}

	@Test
	public function test_given_a_min_height_every_generated_node_should_have_a_greater_height(){
		generator.depth = 50;
		generator.minHeight = 10;
		generator.ratio = 1;
		var root = generator.generate();

		root.traverseInOrder(function(node){
			Assert.isTrue(node.height >= 10);
		});
	}

	@Test
	public function test_given_a_min_width_every_generated_node_should_have_a_greater_width(){
		generator.depth = 50;
		generator.minWidth = 10;
		generator.ratio = 1;
		var root = generator.generate();

		root.traverseInOrder(function(node){
			Assert.isTrue(node.width >= 10);
		});
	}

	@Test
	public function test_given_a_min_width_every_generated_node_should_have_a_ratio_greater_than_given(){
		generator.depth = 4;
		var root = generator.generate();

		root.traverseInOrder(function(node){
			Assert.isTrue(node.width/node.height >= generator.ratio || node.height/node.width >= generator.ratio);
		});
	}

	@Test
	public function given_a_tree_every_set_of_child_nodes_should_add_up_to_the_height_and_width_of_their_parents(){
		for(i in 0...100){
			generator.depth = 4;
			var root = generator.generate();
			root.traverseInOrder(function(node){
				if(!node.isLeaf()){
					//vertical split
					if(node.left.height == node.height){
						var childWidths = node.left.width + node.right.width;

						Assert.areEqual(node.width, childWidths);
						Assert.areEqual(node.height, node.right.height);
						Assert.areEqual(node.height, node.left.height);
					}
					else {
						var childHeights = node.left.height + node.right.height;
						Assert.areEqual(node.height, childHeights);
						Assert.areEqual(node.width, node.left.width);
						Assert.areEqual(node.width, node.right.width);
					}
				}
			});
		}
	}

	@Test
	public function given_a_tree_every_leafs_area_should_add_up_to_root_area(){
		for(i in 0...100){
			generator.depth = 4;
			var root = generator.generate();
			var rootArea = root.height * root.width;
			var leafArea = 0;

			root.traverseInOrder(function(node){
				if(node.isLeaf()){
					leafArea += node.height * node.width;
				}
			});

			Assert.areEqual(rootArea, leafArea);
		}
	}

	@Test
	public function given_a_tree_every_non_leaf_should_have_2_children(){
		for(i in 0...100){
			generator.depth = 4;
			var root = generator.generate();

			root.traverseInOrder(function(node){
				if(!node.isLeaf()){
					Assert.isTrue(node.left != null);
					Assert.isTrue(node.right != null);
				}
			});
		}
	}
}
