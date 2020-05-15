import massive.munit.TestSuite;

import map.PatternTest;
import map.Map2dTest;
import map.helpers.CheckConnectivityTest;
import map.helpers.DistanceFillTest;
import map.helpers.FloodFillTest;
import map.helpers.RegionManagerTest;
import map.helpers.FindAndReplaceTest;
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
		add(map.Map2dTest);
		add(map.helpers.CheckConnectivityTest);
		add(map.helpers.DistanceFillTest);
		add(map.helpers.FloodFillTest);
		add(map.helpers.RegionManagerTest);
		add(map.helpers.FindAndReplaceTest);
		add(bsp.GeneratorTest);
		add(bsp.NodeTest);
		add(export.TiledExporterTest);
	}
}
