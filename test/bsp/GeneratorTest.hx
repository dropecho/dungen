package bsp;

import massive.munit.Assert;
import com.dropecho.gen.bsp.Generator;

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
        generator.depth = 500;
        generator.minHeight = 10;
        var root = generator.generate();

        root.traverseInOrder(function(node){
            Assert.isTrue(node.height >= 10);
        });
    }

	@Test
    public function test_given_a_min_width_every_generated_node_should_have_a_greater_width(){
        generator.depth = 500;
        generator.minWidth = 10;
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
}
