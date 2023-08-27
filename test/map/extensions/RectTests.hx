package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;

class RectTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(2, 2, 0);
	}

	public function test_makes_pattern() {
		map._mapData = [
			0, 1,
			1, 0
		];

		var rect = map.getRect({
			x: 0,
			y: 0,
			width: 2,
			height: 2
		});

		Assert.same(map._mapData, rect);
	}
}
