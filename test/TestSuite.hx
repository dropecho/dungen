import massive.munit.TestSuite;

import utils.ExtenderTest;
import map.MapHelperTest;
import map.Map2dTest;
import bsp.GeneratorTest;
import bsp.NodeTest;
import export.TiledExporterTest;

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
		add(map.MapHelperTest);
		add(map.Map2dTest);
		add(bsp.GeneratorTest);
		add(bsp.NodeTest);
		add(export.TiledExporterTest);
	}
}
