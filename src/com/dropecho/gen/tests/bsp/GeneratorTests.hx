package com.dropecho.gen.tests.bsp;

import com.dropecho.gen.bsp.Generator;

class GeneratorTests extends haxe.unit.TestCase {
    var generator:Generator;

    public override function setup(){
        generator = new Generator();
    }

    public function test_given_a_depth_of_0_it_should_generate_a_single_node(){
        generator.depth = 0;
        var root = generator.generate();

        assertTrue(root.isLeaf());
    }

    public function test_given_a_depth_of_1_it_should_generate_a_single_level_tree(){
        generator.depth = 1;
        var root = generator.generate();

        assertFalse(root.isLeaf());
        assertTrue(root.right.isLeaf());
        assertTrue(root.left.isLeaf());
    }

    public function test_given_a_min_height_every_generated_node_should_have_a_greater_height(){
        generator.depth = 500;
        generator.minHeight = 10;
        var root = generator.generate();

        root.traverseInOrder(function(node){
            assertTrue(node.height >= 10);
        });
    }

    public function test_given_a_min_width_every_generated_node_should_have_a_greater_width(){
        generator.depth = 500;
        generator.minWidth = 10;
        var root = generator.generate();

        root.traverseInOrder(function(node){
            assertTrue(node.width >= 10);
        });
    }

    public function test_given_a_min_width_every_generated_node_should_have_a_ratio_greater_than_given(){
        generator.depth = 4;
        var root = generator.generate();

        root.traverseInOrder(function(node){
            assertTrue(node.width/node.height >= generator.ratio || node.height/node.width >= generator.ratio);
        });
    }
}
