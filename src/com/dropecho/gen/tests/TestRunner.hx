package com.dropecho.gen.tests;

import com.dropecho.gen.tests.utils.ExtenderTests;

class TestRunner {
    static function main(){
        var runner = new haxe.unit.TestRunner();

        runner.add(new ExtenderTests());

        if(!runner.run()){
        	throw "Failed Tests.";
        }
    }
}
