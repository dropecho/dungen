package map.extensions;

import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.map_extensions.CheckConnectivity;

class CheckConnectivityTests extends Test {
	var map:Map2d;

	public function setup() {
		map = new Map2d(8, 8, 0);
	}

	public function test_isMapConnected_no_diagonal_on_manually_filled_map_should_return_false() {
		map.set(2, 0, 1);
		map.set(1, 1, 1);
		map.set(0, 2, 1);

		var connected = CheckConnectivity.checkConnectivity(map, 0, false);

		Assert.isFalse(connected);
	}

	public function test_isMapConnected_with_diagonal_on_manually_filled_map_should_return_true() {
		map.set(2, 0, 1);
		map.set(1, 1, 1);
		map.set(0, 2, 1);

		var connected = CheckConnectivity.checkConnectivity(map, 0, true);

		Assert.isTrue(connected);
	}

	public function test_isMapConnected_on_manually_filled_map_should_return_false_with_all_but_top_two_rows() {
		map.set(0, 1, 1);
		map.set(1, 1, 1);
		map.set(2, 1, 1);
		map.set(3, 1, 1);
		map.set(4, 1, 1);
		map.set(5, 1, 1);
		map.set(6, 1, 1);
		map.set(7, 1, 1);

		var connected = CheckConnectivity.checkConnectivity(map);

		// should flood fill all but first and second row first row
		Assert.isFalse(connected);
	}
}
