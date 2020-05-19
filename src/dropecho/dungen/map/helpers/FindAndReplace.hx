package dropecho.dungen.map.helpers;

import dropecho.dungen.Map2d;
import dropecho.dungen.map.Pattern;

@:expose("dungen.FindAndReplace")
class FindAndReplace {
	public static function findAndReplace(map:Map2d, pattern1:Pattern, pattern2:Pattern, ignoreTile:Int = -1):Map2d {
		for (x in 0...map._width) {
			for (y in 0...map._height) {
				var matchesIndex = pattern1.matchesIndex(map, x, y);

				if (matchesIndex != -1) {
					var m = new Map2d(pattern1._width, pattern1._height);
					m._mapData = pattern1.patterns[matchesIndex];

					var splat = new Map2d(pattern2._width, pattern2._height);
					splat._mapData = pattern2.patterns[matchesIndex];
					map.splat(splat, x, y, ignoreTile);
				}
			}
		}

		return map;
	}
}
