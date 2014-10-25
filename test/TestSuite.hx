import massive.munit.TestSuite;

import bsp.GeneratorTest;
import bsp.NodeTest;
import utils.ExtenderTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(bsp.GeneratorTest);
		add(bsp.NodeTest);
		add(utils.ExtenderTest);
	}
}
