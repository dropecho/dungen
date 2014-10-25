package utils;

import massive.munit.Assert;
import com.dropecho.gen.utils.Extender;

class ExtenderTest {
    var base:Dynamic;
    var ex:Dynamic;

	@Before
    public function setup(){
        base = {x: 0, y:{ z: 0}, a:{b:0}};
        ex = {x: 12, y:{z: 12}, a:{c:0}};
    }

	@Test
    public function test_extender_should_set_simple_field_on_base(){
        Extender.extend(base, ex);
        Assert.areEqual(12, base.x);
    }

	@Test
    public function test_extender_should_set_object_field_on_base(){
        Extender.extend(base, ex);
        Assert.areEqual(12, base.y.z);
    }

	@Test
    public function test_extender_should_not_overwrite_existing_field_on_subobject_when_extension_does_not_have_field(){
        Extender.extend(base, ex);
        Assert.areEqual(0, base.a.b);
    }

	@Test
    public function test_extender_should_handle_null_extension_object(){
        var good = false;
        try {
            Extender.extend(base, null);
            good = true;
        } catch(e:Dynamic) {
            good = false;
        }

        Assert.isTrue(good);
    }

	@Test
    public function test_extender_should_handle_null_base_object(){
        var good = false;
        try {
            Extender.extend(null, ex);
            good = true;
        } catch(e:Dynamic) {
            good = false;
        }

        Assert.isTrue(good);
    }
}
