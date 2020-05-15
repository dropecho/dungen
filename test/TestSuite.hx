import massive.munit.TestSuite;

import map.PatternTest;
import map.Map2dTest;
import map.helpers.DistanceFillTest;
import map.helpers.GetFirstEmptyTileTest;
import map.helpers.FloodFillTest;
import map.helpers.FindAndReplaceTest;
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
		add(map.Map2dTest);
		add(map.helpers.DistanceFillTest);
		add(map.helpers.GetFirstEmptyTileTest);
		add(map.helpers.FloodFillTest);
		add(map.helpers.FindAndReplaceTest);
		add(map.helpers.ConnectivityCheckerTest);
		add(bsp.GeneratorTest);
		add(bsp.NodeTest);
		add(export.TiledExporterTest);
	}
}
