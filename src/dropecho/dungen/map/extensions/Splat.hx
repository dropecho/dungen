package dropecho.dungen.map.extensions;

class Splat {
	public static function splat(map:Map2d, other:Map2d, x:Int, y:Int, ignoreTile:Int = -1):Void {
		for (x2 in 0...other._width) {
			for (y2 in 0...other._height) {
				var otherTile = other.get(x2, y2);
				if (otherTile != ignoreTile) {
					map.set(x2 + x, y2 + y, otherTile);
				}
			}
		}
	}
}
