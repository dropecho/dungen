package com.dropecho.gen.tests;

import com.dropecho.gen.tests.utils.ExtenderTests;

import com.dropecho.gen.tests.bsp.NodeTests;

class TestRunner {
    static function main(){
        var runner = new haxe.unit.TestRunner();

        runner.add(new ExtenderTests());
        runner.add(new NodeTests());

        if(!runner.run()){
        	throw "Failed Tests.";
        }
    }
}
