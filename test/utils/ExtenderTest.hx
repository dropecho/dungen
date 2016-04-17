package utils;

import massive.munit.Assert;
import degen.utils.Extender;

class ExtenderTest {
    var base:Dynamic;
    var ex:Dynamic;

	@Before
    public function setup(){
        base =	{x: 0, y:{ z: 0}, a:{b:0}};
        ex =	{x: 1, y:{ z: 1}, a:{c:0}, add: 1};
    }

	@Test
    public function test_extender_should_set_simple_field_on_base(){
        Extender.extend(base, ex);
        Assert.areEqual(1, base.x);
    }

	@Test
    public function test_extender_should_set_object_field_on_base(){
        Extender.extend(base, ex);
        Assert.areEqual(1, base.y.z);
    }

	@Test
    public function test_extender_should_add_simple_field_on_base(){
        Extender.extend(base, ex);
        Assert.areEqual(1, base.add);
    }

	@Test
    public function test_extender_should_not_overwrite_existing_field_on_subobject_when_extension_does_not_have_field(){
        Extender.extend(base, ex);
        Assert.areEqual(0, base.a.b);
    }

	@Test
    public function test_extender_should_add_non_existing_field_on_subobject_when_extension_has_field(){
        Extender.extend(base, ex);
        Assert.areEqual(0, base.a.c);
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

	@Test
	public function test_extender_should_extend_all_for_empty_base_object(){
		var empty = Extender.extend({},ex);

		Assert.areEqual(ex.x, empty.x);	
		Assert.areEqual(ex.y, empty.y);	
		Assert.areEqual(ex.a, empty.a);	
		Assert.areEqual(ex.add, empty.add);	
	}

	@Test
	public function test_extender_should_extend_by_multiple_extensions(){
		var empty = Extender.extend({},[{x:1},{y:2}]);

		Assert.areEqual(1,empty.x);
		Assert.areEqual(2,empty.y);
	}
}
