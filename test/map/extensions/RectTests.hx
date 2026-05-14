package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.map_extensions.Rect;

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

	public function test_set_rect_should_set_correct_tiles() {
		var sample = new Map2d(8, 8);
		sample._mapData = [
			0, 0, 0, 0, 0, 0, 0, 0,
			1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0
		];

		sample.setRect({
			x: 0,
			y: 0,
			width: 2,
			height: 2
		}, 2);

		var expected = [
			2, 2, 0, 0, 0, 0, 0, 0,
			2, 2, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0
		];

		Assert.same(expected, sample._mapData);
	}

	public function test_set_rect_should_set_correct_tiles_with_offset() {
		var sample = new Map2d(8, 8);
		sample._mapData = [
			0, 0, 0, 0, 0, 0, 0, 0,
			1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0
		];

		sample.setRect({
			x: 5,
			y: 5,
			width: 2,
			height: 2
		}, 2);

		var expected = [
			0, 0, 0, 0, 0, 0, 0, 0,
			1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 2, 2, 0,
			0, 0, 0, 0, 0, 2, 2, 0,
			0, 0, 0, 0, 0, 0, 0, 0
		];

		Assert.same(expected, sample._mapData);
	}

	public function test_get_rect_should_return_correct_tiles() {
		var sample = new Map2d(8, 8);
		sample._mapData = [
			0, 0, 0, 0, 0, 0, 0, 0,
			1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0
		];

		var tiles = sample.getRect({
			x: 0,
			y: 1,
			width: 2,
			height: 2
		});

		Assert.equals(4, tiles.length);
	}

	public function test_get_rect_on_edge_should_return_wrapped() {
		var sample = new Map2d(2, 2);
		sample._mapData = [
			1, 0,
			0, 1
		];

		var tiles = sample.getRect({
			x: 0,
			y: 0,
			width: 2,
			height: 2
		}, true);
		var tiles2 = sample.getRect({
			x: 0,
			y: 1,
			width: 2,
			height: 2
		}, true);
		var tiles3 = sample.getRect({
			x: 1,
			y: 1,
			width: 2,
			height: 2
		}, true);

		Assert.equals(4, tiles.length);
		Assert.equals(4, tiles2.length);

		Assert.same(sample._mapData, tiles);

		var tile_2_expected = [
			0, 1,
			1, 0
		];
		Assert.same(tile_2_expected, tiles2);
		Assert.same(sample._mapData, tiles3);
		for (t in 0...tiles2.length) {
			Assert.equals(tile_2_expected[t], tiles2[t]);
		}
	}

	public function test_get_rect_big_should_return_correct() {
		var sample = new Map2d(4, 4);
		sample._mapData = [
			0, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 2, 0,
			0, 0, 0, 3,
		];

		var tiles = sample.getRect({
			x: 0,
			y: 0,
			width: 4,
			height: 4
		}, true);

		var tiles_expected = [
			0, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 2, 0,
			0, 0, 0, 3,
		];
		Assert.same(tiles_expected, tiles);
	}

	public function test_check_overlap() {
		var rect1 = {
			x: 0,
			y: 0,
			width: 2,
			height: 2
		};
		var rect2 = {
			x: 1,
			y: 1,
			width: 2,
			height: 2
		};
		var rect3 = {
			x: 3,
			y: 3,
			width: 2,
			height: 2
		};

		Assert.isTrue(checkOverlap(rect1, rect2));
		Assert.isFalse(checkOverlap(rect1, rect3));
	}

	public function test_check_contains() {
		var rect1 = {
			x: 0,
			y: 0,
			width: 3,
			height: 3
		};
		var rect2 = {
			x: 1,
			y: 1,
			width: 2,
			height: 2
		};
		var rect3 = {
			x: 2,
			y: 2,
			width: 2,
			height: 2
		};

		Assert.isTrue(contains(rect1, rect2));
		Assert.isFalse(contains(rect1, rect3));
	}
}
