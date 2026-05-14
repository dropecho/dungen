package dropecho.dungen.generators;

import seedyrng.Random;
import dropecho.interop.Extender;
import dropecho.dungen.Map2d;

typedef MazeConfigProps = {
	var ?width:Int;
	var ?height:Int;
	var ?tile_floor:Int;
	var ?tile_wall:Int;
	var ?seed:String;
}

@:noDoc
class MAZE_PARAMS {
	public var width:Int = 64;
	public var height:Int = 64;
	public var tile_floor:Int = 1;
	public var tile_wall:Int = 0;
	public var seed:String = "0";

	public function new() {}
}

@:expose("dungen.MazeGenerator")
class MazeGenerator {
	public static function generate(?opts:MazeConfigProps = null):Map2d {
		var params:MAZE_PARAMS = Extender.defaults(new MAZE_PARAMS(), opts);
		var random:Random = new Random();
		random.setStringSeed(params.seed);

		var map = new Map2d(params.width, params.height, params.tile_wall);

		var visited = new Array<Bool>();
		for (i in 0...params.width * params.height) {
			visited.push(false);
		}

		function idx(x:Int, y:Int):Int {
			return y * params.width + x;
		}

		function inBounds(x:Int, y:Int):Bool {
			return x >= 0 && x < params.width && y >= 0 && y < params.height;
		}

		// Maze cells are at odd coordinates; walls between them are at even coords.
		// Start at a random odd-coordinate cell.
		var startCX = random.randomInt(0, Std.int((params.width - 1) / 2)) * 2 + 1;
		var startCY = random.randomInt(0, Std.int((params.height - 1) / 2)) * 2 + 1;

		var stack = new Array<{x:Int, y:Int}>();
		stack.push({x: startCX, y: startCY});
		visited[idx(startCX, startCY)] = true;
		map.set(startCX, startCY, params.tile_floor);

		// Directions: up, right, down, left — step 2 cells to reach the next maze cell.
		var dirs = [{dx: 0, dy: -2}, {dx: 2, dy: 0}, {dx: 0, dy: 2}, {dx: -2, dy: 0}];

		while (stack.length > 0) {
			var current = stack[stack.length - 1];

			// Collect unvisited neighbors.
			var neighbors = new Array<{x:Int, y:Int, wx:Int, wy:Int}>();
			for (d in dirs) {
				var nx = current.x + d.dx;
				var ny = current.y + d.dy;
				if (inBounds(nx, ny) && !visited[idx(nx, ny)]) {
					neighbors.push({x: nx, y: ny, wx: current.x + Std.int(d.dx / 2), wy: current.y + Std.int(d.dy / 2)});
				}
			}

			if (neighbors.length == 0) {
				stack.pop();
			} else {
				var chosen = neighbors[random.randomInt(0, neighbors.length - 1)];
				visited[idx(chosen.x, chosen.y)] = true;
				map.set(chosen.wx, chosen.wy, params.tile_floor);
				map.set(chosen.x, chosen.y, params.tile_floor);
				stack.push({x: chosen.x, y: chosen.y});
			}
		}

		return map;
	}
}
