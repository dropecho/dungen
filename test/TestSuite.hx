import massive.munit.TestSuite;

import map.PatternTest;
import map.extensions.CheckConnectivityTest;
import map.extensions.DistanceFillTest;
import map.extensions.FloodFillTest;
import map.extensions.RegionManagerTest;
import map.extensions.FindAndReplaceTest;
import map.RegionMapTest;
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

		add(map.PatternTest);
		add(map.extensions.CheckConnectivityTest);
		add(map.extensions.DistanceFillTest);
		add(map.extensions.FloodFillTest);
		add(map.extensions.RegionManagerTest);
		add(map.extensions.FindAndReplaceTest);
		add(map.RegionMapTest);
		add(map.Map2dTest);
		add(bsp.GeneratorTest);
		add(bsp.NodeTest);
		add(export.TiledExporterTest);
	}
}
