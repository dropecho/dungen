package map.extensions;

import dropecho.dungen.Map2d;
import utest.Assert;
import utest.Test;

class BresenhamLineTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(8, 8, 0);
	}

	public function test_draws_horizontal_line() {
		map.setLine(0, 0, 3, 0, 1);

		var expected = [
			1, 1, 1, 1, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
		];

		Assert.same(expected, map._mapData);
	}

	public function test_draws_horizontal_line_to_left() {
		map.setLine(4, 0, 1, 0, 1);

		var expected = [
			0, 1, 1, 1, 1, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
		];

		Assert.same(expected, map._mapData);
	}

	public function test_draws_vertical_line() {
		map.setLine(0, 0, 0, 5, 1);
		var expected = [
			1, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
		];
		Assert.same(expected, map._mapData);
	}

	public function test_draws_vertical_line_inverse() {
		map.setLine(0, 6, 0, 1, 1);
		var expected = [
			0, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
		];
		Assert.same(expected, map._mapData);
	}

	public function test_draws_diagonal_line() {
		map.setLine(0, 0, 7, 7, 1);
		var expected = [
			1, 0, 0, 0, 0, 0, 0, 0,
			0, 1, 0, 0, 0, 0, 0, 0,
			0, 0, 1, 0, 0, 0, 0, 0,
			0, 0, 0, 1, 0, 0, 0, 0,
			0, 0, 0, 0, 1, 0, 0, 0,
			0, 0, 0, 0, 0, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 1,
		];
		Assert.same(expected, map._mapData);
	}

	public function test_draws_diagonal_line_inverse() {
		map.setLine(7, 7, 0, 0, 1);
		var expected = [
			1, 0, 0, 0, 0, 0, 0, 0,
			0, 1, 0, 0, 0, 0, 0, 0,
			0, 0, 1, 0, 0, 0, 0, 0,
			0, 0, 0, 1, 0, 0, 0, 0,
			0, 0, 0, 0, 1, 0, 0, 0,
			0, 0, 0, 0, 0, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 1,
		];
		Assert.same(expected, map._mapData);
	}

	public function test_draws_diagonal_line_bottom() {
		map.setLine(7, 0, 0, 7, 1);
		var expected = [
			0, 0, 0, 0, 0, 0, 0, 1,
			0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0,
			0, 0, 0, 0, 1, 0, 0, 0,
			0, 0, 0, 1, 0, 0, 0, 0,
			0, 0, 1, 0, 0, 0, 0, 0,
			0, 1, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
		];
		Assert.same(expected, map._mapData);
	}

	public function test_draws_diagonal_line_bottom_inverse() {
		map.setLine(0, 7, 7, 0, 1);
		var expected = [
			0, 0, 0, 0, 0, 0, 0, 1,
			0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0,
			0, 0, 0, 0, 1, 0, 0, 0,
			0, 0, 0, 1, 0, 0, 0, 0,
			0, 0, 1, 0, 0, 0, 0, 0,
			0, 1, 0, 0, 0, 0, 0, 0,
			1, 0, 0, 0, 0, 0, 0, 0,
		];

		Assert.same(expected, map._mapData);
	}

	public function test_draws_diagonal_line_half_height() {
		map.setLine(0, 0, 7, 4, 1);
		//     trace(map.toPrettyString(['0', '1']));
		var expected = [
			1, 0, 0, 0, 0, 0, 0, 0,
			0, 1, 1, 0, 0, 0, 0, 0,
			0, 0, 0, 1, 1, 0, 0, 0,
			0, 0, 0, 0, 0, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 1,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0,
		];
		Assert.same(expected, map._mapData);
	}
}
