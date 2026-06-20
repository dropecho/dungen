#if macro
import haxe.macro.Expr;
import dropecho.testing.Common;
#end

/**
 * Dedicated entry point for coverage runs (`npm run coverage`, via `coverage.hxml`).
 *
 * It mirrors `dropecho.testing`'s utest auto-discovery — every `*Tests.hx`
 * class on the classpath — but, when the suite finishes, asks `instrument` to
 * write its lcov report directly. instrument otherwise only writes on
 * `Sys.exit`, which utest's Node `PrintReport` never calls, so this handler is
 * what makes `lcov.info` actually flush.
 */
class CoverageMain {
	public static function main() {
		var runner = new utest.Runner();
		addCases(runner);
		// Flush the lcov report when the suite finishes. Registered before the
		// report so it runs first (a handler added after the report's never fires).
		#if instrument
		runner.onComplete.add(_ -> instrument.coverage.Coverage.endCoverage());
		#end
		utest.ui.Report.create(runner);
		runner.run();
	}

	/** Adds `runner.addCase(new …)` for every discovered `*Tests.hx` suite. */
	macro static function addCases(runner:Expr):Expr {
		var adds:Array<Expr> = [];
		for (path in Common.extractPath()) {
			var data = Common.extractTestSuites(path, path, {suites: []});
			for (suite in data.suites) {
				var testCase = Common.extractExpr(path, suite);
				adds.push(macro $runner.addCase($testCase));
			}
		}
		return macro $b{adds};
	}
}
