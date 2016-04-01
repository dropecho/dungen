package degen.ca;

import degen.map.Map2d;

typedef CA_PARAM_STEP = {
	reps: Int,
	r1_cutoff: Int,
	r2_cutoff: Int
};

typedef CA_PARAMS = {
	steps: Array<CA_PARAM_STEP>,
	height: Int,
	width: Int,
	tile_floor: Int,
	tile_wall: Int
};

class Generator {
	public static function generate(params : CA_PARAMS) : Map2d {
		var map = new Map2d(params.width, params.height, -1);
		map.fillMapRandomly(params.tile_floor, params.tile_wall);
		map.ensureEdgesAreWalls();

		var steps:Array<Dynamic> = params.steps;

		for(step in steps){
			for(rep in 0...step.reps){
				buildFromCA(map, params, step);
			}
		}

		map.ensureEdgesAreWalls();
		return map;
	}
    
    private static function buildFromCA(map : Map2d, params : CA_PARAMS, step : CA_PARAM_STEP) : Void {
		var temp = new Map<Int, Int>();

        for(x in 1...params.width - 1){
            for(y in 1...params.height - 1){
                var nCount = map.getNeighborCount(x, y, params.tile_wall);
                var nCount2 = map.getNeighborCount(x, y, params.tile_wall, 2);
				var pos = map.XYtoIndex(x,y);

                if(nCount >= step.r1_cutoff || nCount2 <= step.r2_cutoff){
                    temp.set(pos, params.tile_wall);
                } else {
                    temp.set(pos, params.tile_floor);
                }
            }
        }

		for(i in temp.keys()) {
			var pos = map.IndexToXY(i);
			map.set(pos.x, pos.y, temp[i]);
		}
    }
}

