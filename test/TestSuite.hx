import massive.munit.TestSuite;

import utils.ExtenderTest;
import map.Map2dTest;
import bsp.GeneratorTest;
import bsp.NodeTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(utils.ExtenderTest);
		add(map.Map2dTest);
		add(bsp.GeneratorTest);
		add(bsp.NodeTest);
	}
}
