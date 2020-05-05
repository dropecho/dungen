package dropecho.dungen.map.helpers;

typedef Rect = {
	var width:Int;
	var height:Int;
	var x:Int;
	var y:Int;
};

class Utils {
	// Return true if r1 overlaps r2.
	public static function checkOverlap(r1:Rect, r2:Rect):Bool {
		var r1p1 = {x: r1.x, y: r1.y};
		var r1p2 = {x: r1.x + r1.width, y: r1.y + r1.height};
		var r2p1 = {x: r2.x, y: r2.y};
		var r2p2 = {x: r2.x + r2.width, y: r2.y + r2.height};

		return !(r1p1.x > r2p2.x || r2p1.x > r1p2.x || r1p1.y > r2p2.y || r2p1.y > r1p2.y);
	}

	// Return true if r2 is contained by r1
	public static function contains(r1:Rect, r2:Rect):Bool {
		var r1p1 = {x: r1.x, y: r1.y};
		var r1p2 = {x: r1.x + r1.width, y: r1.y + r1.height};
		var r2p1 = {x: r2.x, y: r2.y};
		var r2p2 = {x: r2.x + r2.width, y: r2.y + r2.height};

		return (r2p2.x < r1p2.x && r2p2.y < r1p2.y && r2p1.x > r1p1.x && r2p1.y > r1p1.y);
	}

	public static function isOverlappingArray(r1, a:Array<Dynamic>) {
		for (r in a) {
			if (r == r1) {
				continue; // Ignore itself.
			}

			if (Utils.checkOverlap(r1, r)) {
				return true;
			}
		}

		return false;
	}
}
