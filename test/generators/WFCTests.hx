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

	public function test_makes_pattern() {
		map._mapData = [
			1, 2, 3, 4,
			5, 6, 7, 8,
			1, 2, 3, 4,
			5, 6, 7, 8
		];

		var foo = new WFC(map, 2);
		var bar = foo.getPossibilities();

		Assert.isTrue(bar.keys().hasNext());

		for (key in bar.keys()) {
			Assert.isTrue(Std.isOfType(key, Int));
			var value = bar.get(key);
			Assert.notNull(value);
			Assert.equals(4, value.length);
		}
	}
}
