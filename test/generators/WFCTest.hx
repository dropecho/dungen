package generators;

import utest.Assert;
import utest.Test;
import dropecho.dungen.generators.WFC;
import dropecho.dungen.Map2d;

class WFCTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(4, 4, 0);
	}

	@Ignored
	public function test_makes_pattern() {
		map._mapData = [
			1, 2, 3, 4,
			5, 6, 7, 8,
			1, 2, 3, 4,
			5, 6, 7, 8
		];

		var foo = new WFC(map, 2);
		var bar = foo.getPossibilities();

		//     trace(bar);

		//     for (i in 0...bar[0].patterns.length) {
		//       trace(bar[0]
		//         .indexToMap(i)
		//         .toPrettyString()
		//       );
		//     }
	}
}
