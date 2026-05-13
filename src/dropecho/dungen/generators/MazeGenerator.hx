package dropecho.dungen.generators;

@:expose("dungen.MAZE_PARAMS")
class MAZE_PARAMS {}

@:expose("dungen.MazeGenerator")
class MazeGenerator {
	public static function generate(?opts:MAZE_PARAMS = null):Map2d {
		return new Map2d(10, 10);
	}
}
