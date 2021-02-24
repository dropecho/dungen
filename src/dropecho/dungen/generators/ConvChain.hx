package dropecho.dungen.generators;

/**
 * ConvChain constructor
 * @param {Array|Uint8Array} sample Sample pattern as a flat array or a 2D array
 * @param {int|Array} [sampleSize] Indicate the width and height of the sample when used with a flat array, if omitted assume the sample is a square
 * @constructor
 */
import seedyrng.Random;
import dropecho.dungen.generators.RandomGenerator;
import dropecho.dungen.Map2d;
import dropecho.dungen.map.Pattern;

using dropecho.dungen.map.Map2dExtensions;
using dropecho.dungen.map.extensions.Utils;

@:expose("dungen.ConvChain")
class ConvChain {
	public var sample:Map2d;
	public var cachedN:Int;
	public var cachedWeights:Array<Float>;
	public var rng:Random;
	public var seed:String = "0";

	public function new(sample:Map2d) {
		this.sample = sample;
		this.cachedN = -1;
		this.cachedWeights = null;
		this.rng = new Random();
		this.rng.setStringSeed(this.seed);
	};

	public function processWeights(sample:Map2d, n:Int):Array<Float> {
		var size = Std.int(Math.pow(2, n * n));
		var weights = [for (_ in 0...(size)) 0.0];

		for (x in 0...sample._height) {
			for (y in 0...sample._width) {
				var rect = sample.getRect({
					x: x,
					y: y,
					width: n,
					height: n
				}, true);
				var p = Pattern.init(n, rect);
				for (h in 0...p.hashes.length) {
					weights[p.hashes[h]] += 1;
				}
			}
		}

		for (k in 0...weights.length) {
			weights[k] = weights[k] <= 0 ? 0.1 : weights[k];
		}

		return weights;
	}

	/**
	 * Get the weights for given receptor size n.
	 * @param {Int} n - The receptor size.
	 * @return {Array<Float>} The weights.
	 */
	public function getWeights(n:Int) {
		if (cachedN != n) {
			cachedN = n;
			cachedWeights = processWeights(sample, n);
		}
		return cachedWeights;
	}

	/**
	 * Generate a random beginning bitmap.
	 *
	 * @param {Int} width - The width of the bitmap.
	 * @param {Int} height - The height of the bitmap.
	 * @return {Map2d} The bitmap.
	 */
	public function generateBaseField(width, height):Map2d {
		return RandomGenerator.generate({height: height, width: width, seed: seed});
	}

	/**
	 * Apply the changes to the generated bitmap per "tick" of the convolution.
	 *
	 * @param {Map2d} field - The bitmap we are generating.
	 * @param {Array} weights - The array of weights from the sampled bitmap
	 * @param {Int} n - The receptor size.
	 * @param {Float} temperature - No idea.
	 * @param {Int} changes - How many rounds of changes to apply.
	 * @return {Void}
	 */
	public function applyChanges(field:Map2d, weights:Array<Float>, n:Int, temperature:Float, changes:Int):Void {
		var r:Int;
		var q:Float;
		var x:Int;
		var y:Int;
		var ind:Int;
		var difference:Int;

		for (_ in 0...changes) {
			q = 1.0;
			r = rng.randomInt(0, field._mapData.length);
			x = Std.int(r % field._width);
			y = Std.int(r / field._width);

			// Check similarity
			for (sy in (y - n + 1)...(y + n)) {
				for (sx in (x - n + 1)...(x + n)) {
					ind = 0;
					difference = 0;

					for (dy in 0...n) {
						for (dx in 0...n) {
							var power = 1 << (dy * n + dx);
							var X = sx + dx;
							var Y = sy + dy;

							X = Std.int(Math.abs(X % field._width));
							Y = Std.int(Math.abs(Y % field._height));

							var value = field.get(X, Y);
							ind += value != 0 ? power : 0;

							if (X == x && Y == y) {
								difference = value != 0 ? power : -power;
							}
						}
					}

					var a = weights[ind - difference];
					var b = weights[ind];
					q *= a / b;
				}
			}

			if (q >= 1) {
				field.set(x, y, field.get(x, y) != 1 ? 1 : 0);
			} else {
				if (temperature != 1) {
					q = Math.pow(q, 1.0 / temperature);
				}

				if (q > rng.random()) {
					field.set(x, y, field.get(x, y) != 1 ? 1 : 0);
				}
			}
		}
	}

	/**
	 * Generate a pattern based on the sample pattern
	 * @param {int} width Width of the generated pattern
	 * @param {int} height Height of the generated pattern
	 * @param {int} n Receptor size, an integer greater than 0
	 * @param {float} temperature Temperature
	 * @param {int} iterations Number of iterations
	 * @returns {Uint8Array} Generated pattern, returned as a flat Uint8Array
	 */
	public function generate(width, height, n, temperature:Float, iterations) {
		var changesPerIterations = width * height;

		var field = generateBaseField(width, height);
		var weights = getWeights(n);
		for (_ in 0...iterations) {
			applyChanges(field, weights, n, temperature, changesPerIterations);
		}
		return field;
	}
}
