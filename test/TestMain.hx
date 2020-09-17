import massive.munit.client.PrintClient;
import massive.munit.client.RichPrintClient;
import massive.munit.client.JUnitReportClient;
import massive.munit.TestRunner;

/**
 * Auto generated Test Application.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestMain {
	static function main() {
		new TestMain();
	}

	public function new() {
		var suites = new Array<Class<massive.munit.TestSuite>>();
		suites.push(TestSuite);

		#if MCOVER
		var client = new mcover.coverage.munit.client.MCoverPrintClient();
		#else
		var client = new RichPrintClient();
		#end

		var runner:TestRunner = new TestRunner(client);

		runner.completionHandler = completionHandler;
		runner.run(suites);
	}

	/*
		updates the background color and closes the current browser
		for flash and html targets (useful for continous integration servers)
	 */
	function completionHandler(successful:Bool):Void {
		try {
			Sys.exit(0);
		}
		// if run from outside browser can get error which we can ignore
		catch (e:Dynamic) {}
	}
}
