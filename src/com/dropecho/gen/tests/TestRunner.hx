package com.dropecho.gen.tests;

// import com.dropecho.ai.tests.fsm.FSM_tests;
// import com.dropecho.ai.tests.fsm.State_tests;

// import com.dropecho.ai.tests.goap.Action_tests;
// import com.dropecho.ai.tests.goap.Plan_tests;
// import com.dropecho.ai.tests.goap.Planner_tests;

// import com.dropecho.ai.tests.pathfinding.AStar_tests;

class TestRunner {

    static function main(){
        var r = new haxe.unit.TestRunner();

        // r.add(new FSM_tests());
        // r.add(new State_tests());
        // r.add(new Action_tests());
        // r.add(new Plan_tests());
        // r.add(new Planner_tests());
        // r.add(new AStar_tests());

        if(!r.run()){
        	throw "Failed Tests.";
        }
    }
}
