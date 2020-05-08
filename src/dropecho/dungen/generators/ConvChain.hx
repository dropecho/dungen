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

		inline function pattern(fn:(Int, Int) -> Int) {
			return [for (y in 0...n) for (x in 0...n) fn(x, y)];
		}

		inline function rotate(p:Array<Int>) {
			return pattern((x, y) -> p[n - 1 - y + x * n]);
		}

		inline function reflect(p:Array<Int>) {
			return pattern((x, y) -> p[n - 1 - x + y * n]);
		}

		inline function index(p:Array<Int>):Int {
			var result = 0;
			var power = 1;

			for (i in 0...p.length) {
				result += p[p.length - 1 - i] != 0 ? power : 0;
				power *= 2;
			}

			return result;
		};

		for (y in 0...sample._height) {
			for (x in 0...sample._width) {
				function initial(dx, dy) {
					var a = ((x + dx) % sample._width);
					var b = ((y + dy) % sample._height);
					return sample.get(a, b);
				}

				var p0 = pattern(initial);
				var p1 = rotate(p0);
				var p2 = rotate(p1);
				var p3 = rotate(p2);
				var p4 = reflect(p0);
				var p5 = reflect(p1);
				var p6 = reflect(p2);
				var p7 = reflect(p3);

				weights[index(p0)] += 1;
				weights[index(p1)] += 1;
				weights[index(p2)] += 1;
				weights[index(p3)] += 1;
				weights[index(p4)] += 1;
				weights[index(p5)] += 1;
				weights[index(p6)] += 1;
				weights[index(p7)] += 1;
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
		var x;
		var y;
		var ind;
		var difference;

		for (_ in 0...changes) {
			q = 1.0;
			r = rng.randomInt(0, field._mapData.length);
			x = Std.int(r % field._width);
			y = Std.int(r / field._width);

			for (sy in (y - n + 1)...(y + n)) {
				for (sx in (x - n + 1)...(x + n)) {
					ind = 0;
					difference = 0;

					for (dy in 0...n) {
						for (dx in 0...n) {
							var power = 1 << (dy * n + dx);
							var X = sx + dx;
							var Y = sy + dy;
							var value;

							if (X < 0) {
								X += field._width;
							} else if (X >= field._width) {
								X -= field._width;
							}

							if (Y < 0) {
								Y += field._height;
							} else if (Y >= field._height) {
								Y -= field._height;
							}

							value = field.get(X, Y);
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
