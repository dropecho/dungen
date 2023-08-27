package dropecho.dungen.map.extensions;

import dropecho.dungen.Map2d.Tile2d;

// FROM: https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
class BresenhamLine {
	public static function getLine(
		map:Map2d,
		startX:Int = 0,
		startY:Int = 0,
		endX:Int = 0,
		endY:Int = 0
	):Array<Tile2d> {
		var dx = Math.abs(endX - startX);
		var sx = startX < endX ? 1 : -1;
		var dy = -Math.abs(endY - startY);
		var sy = startY < endY ? 1 : -1;
		var error = dx + dy;

		var x = startX;
		var y = startY;

		var tiles = new Array<Tile2d>();

		while (true) {
			tiles.push(new Tile2d(x, y, map.get(x, y)));
			if (x == endX && y == endY) {
				break;
			}
			var e2 = 2 * error;
			if (e2 >= dy) {
				if (x == endX) {
					break;
				}
				error = error + dy;
				x = x + sx;
			}
			if (e2 <= dx) {
				if (y == endY) {
					break;
				}
				error = error + dx;
				y = y + sy;
			}
		}
		return tiles;
	}

	public static function setLine(
		map:Map2d,
		startX:Int = 0,
		startY:Int = 0,
		endX:Int = 0,
		endY:Int = 0,
		value:Int = 0
	):Void {
		for (tile in getLine(map, startX, startY, endX, endY)) {
			map.set(tile.x, tile.y, value);
		}
	}
}
