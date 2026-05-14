package dropecho.dungen.map_extensions;

import dropecho.dungen.Map2d;
import dropecho.dungen.Pattern;

using dropecho.dungen.map_extensions.Splat;

@:expose("dungen.FindAndReplace")
class FindAndReplace {
	public static function findAndReplace(
		map:Map2d,
		pattern1:Pattern,
		pattern2:Pattern,
		ignoreTile:Int = -1
	):Map2d {
		for (x in 0...map._width) {
			for (y in 0...map._height) {
				var patternIndex = pattern1.getMatchingVariationIndex(map, x, y);

				if (patternIndex != -1) {
					var splat = pattern2.variationToMap(patternIndex);
					map.splat(splat, x, y, ignoreTile);
				}
			}
		}

		return map;
	}
}
