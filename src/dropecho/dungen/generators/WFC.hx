package dropecho.dungen.generators;

import dropecho.dungen.generators.RandomGenerator;
import dropecho.dungen.Map2d;
import dropecho.dungen.map.Pattern;

@:expose("dungen.WFC")
class WFC {
	public var sample:Map2d;
	public var n:Int;

	public function new(sample:Map2d, n:Int) {
		this.sample = sample;
		this.n = n;
	}

	// loop through sample and get NxN chunks.
	public function getPossibilities() {
		var patterns = [];

		for (x in 0...sample._width - this.n + 1) {
			for (y in 0...sample._height - this.n + 1) {
				var data = sample.getRect({
					x: x,
					y: y,
					width: 2,
					height: 2
				});

				patterns.push(Pattern.init(2, data));
			}
		}

		// filter possibilities down to unique ones.
		var hashedPatterns = new Map<Int, Array<Int>>();

		for (pattern in patterns) {
			for (i in 0...pattern.patterns.length) {
				var hash = pattern.hashes[i];
				var variation = pattern.patterns[i];

				//         if (hashedPatterns.exists(hash)) {
				//           var old = hashedPatterns.get(hash);
				//           if (old != variation) {
				//             throw "hash collision: " + old + " " + variation;
				//           }
				//         }

				hashedPatterns.set(hash, variation);
			}
		}

		return hashedPatterns;
	}

	public function generate(width, height, n) {}
}
