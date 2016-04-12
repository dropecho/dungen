package bsp;

import massive.munit.Assert;
import degen.bsp.Generator;
import degen.bsp.BspData;
import de.polygonal.ds.BinaryTreeNode;

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

        Assert.isTrue(!root.hasL() && !root.hasR());
    }

	@Test
	public function test_given_a_depth_of_1_it_should_generate_a_single_level_tree(){
		generator.depth = 1;
		var root = generator.generate();

		Assert.isFalse(!root.hasL() && !root.hasR());
		Assert.isTrue(!root.r.hasL());
		Assert.isTrue(!root.l.hasL());
	}

	@Test
	public function test_given_a_min_height_every_generated_node_should_have_a_greater_height(){
		generator.depth = 50;
		generator.minHeight = 10;
		generator.ratio = 1;
		var root = generator.generate();

		root.inorder(function(node:BinaryTreeNode<BspData>, foo:Dynamic) : Bool{
			Assert.isTrue(node.val.height >= 10);
			return true;
		});
	}

	@Test
	public function test_given_a_min_width_every_generated_node_should_have_a_greater_width(){
		generator.depth = 50;
		generator.minWidth = 10;
		generator.ratio = 1;
		var root = generator.generate();

		root.inorder(function(node:BinaryTreeNode<BspData>, foo:Dynamic) : Bool{
			Assert.isTrue(node.val.width >= 10);
			return true;
		});
	}

	@Test
	public function test_given_a_min_width_every_generated_node_should_have_a_ratio_greater_than_given(){
		generator.depth = 4;
		var root = generator.generate();

		root.inorder(function(node:BinaryTreeNode<BspData>, foo:Dynamic) : Bool{
			Assert.isTrue(node.val.width/node.val.height >= generator.ratio || node.val.height/node.val.width >= generator.ratio);
			return true;
		});
	}

	@Test
	public function given_a_tree_every_set_of_child_nodes_should_add_up_to_the_height_and_width_of_their_parents(){
		for(i in 0...100){
			generator.depth = 4;
			var root = generator.generate();

			root.inorder(function(node:BinaryTreeNode<BspData>, foo:Dynamic) : Bool{
				if(node.hasL() && node.hasR()){
					//vertical split
					if(node.l.val.height == node.val.height){
						var childWidths = node.l.val.width + node.r.val.width;

						Assert.areEqual(node.val.width, childWidths);
						Assert.areEqual(node.val.height, node.r.val.height);
						Assert.areEqual(node.val.height, node.l.val.height);
					}
					else {
						var childHeights = node.l.val.height + node.r.val.height;
						Assert.areEqual(node.val.height, childHeights);
						Assert.areEqual(node.val.width, node.l.val.width);
						Assert.areEqual(node.val.width, node.r.val.width);
					}
				}
				return true;
			});
		}
	}

	@Test
	public function given_a_tree_every_leafs_area_should_add_up_to_root_area(){
		for(i in 0...100){
			generator.depth = 4;
			var root = generator.generate();
			var rootArea = root.val.height * root.val.width;
			var leafArea = 0;

			var findLeafArea = function(node:BinaryTreeNode<BspData>, foo:Dynamic) : Bool{
				if(!node.hasL() && !node.hasR()){
					leafArea += node.val.height * node.val.width;
				}
				return true;
			}

			root.inorder(findLeafArea);

			Assert.areEqual(rootArea, leafArea);
		}
	}

	@Test
	public function given_a_tree_every_non_leaf_should_have_2_children(){
		for(i in 0...100){
			generator.depth = 4;
			var root = generator.generate();

			root.inorder(function(node:BinaryTreeNode<BspData>, foo:Dynamic) : Bool{
				if(node.hasL() && node.hasR()){
					Assert.isTrue(node.r != null);
					Assert.isTrue(node.l != null);
				}

				return true;
			});
		}
	}
}
