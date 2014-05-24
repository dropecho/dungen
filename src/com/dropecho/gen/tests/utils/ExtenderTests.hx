package com.dropecho.gen.tests.utils;

import com.dropecho.gen.utils.Extender;

class ExtenderTests extends haxe.unit.TestCase {
    var base:Dynamic;
    var ex:Dynamic;

    public override function setup(){
        base = {x: 0, y:{ z: 0}, a:{b:0}};
        ex = {x: 12, y:{z: 12}, a:{c:0}};
    }

    public function test_extender_should_set_simple_field_on_base(){
        Extender.extend(base, ex);
        assertEquals(12, base.x);
    }

    public function test_extender_should_set_object_field_on_base(){
        Extender.extend(base, ex);
        assertEquals(12, base.y.z);
    }

    public function test_extender_should_not_overwrite_existing_field_on_subobject_when_extension_does_not_have_field(){
        Extender.extend(base, ex);
        assertEquals(0, base.a.b);
    }

    public function test_extender_should_handle_null_extension_object(){
        var good = false;
        try {
            Extender.extend(base, null);
            good = true;
        } catch(e:Dynamic) {
            good = false;
        }

        assertTrue(good);
    }

    public function test_extender_should_handle_null_base_object(){
        var good = false;
        try {
            Extender.extend(null, ex);
            good = true;
        } catch(e:Dynamic) {
            good = false;
        }

        assertTrue(good);
    }
}
