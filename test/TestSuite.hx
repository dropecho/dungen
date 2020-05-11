import massive.munit.TestSuite;

import map.PatternTest;
import map.MapHelperTest;
import map.Map2dTest;
import map.helpers.ConnectivityCheckerTest;
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

		add(map.PatternTest);
		add(map.MapHelperTest);
		add(map.Map2dTest);
		add(map.helpers.ConnectivityCheckerTest);
		add(bsp.GeneratorTest);
		add(bsp.NodeTest);
		add(export.TiledExporterTest);
	}
}
