package dropecho.dungen.ca;

import dropecho.dungen.utils.Extender;
import dropecho.dungen.map.Map2d;

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
  tile_wall: Int,
  start_fill_percent: Int
};

@:expose("degen.CAGenerator")
class Generator {
  private static var _params = {
    steps: [{
      reps: 4,
      r1_cutoff: 5,
      r2_cutoff: 2
    },
    {
      reps : 3,
      r1_cutoff: 5,
      r2_cutoff: 0
    }],
    height: 64,
    width: 64,
    tile_floor: 1,
    tile_wall: 0,
    start_fill_percent: 65
  };

  public static function generate(?params : Dynamic) : Map2d {

    // params = Extender.extend({}, [_params, params]);

    var map = new Map2d(params.width, params.height, -1);
    map.fillMapRandomly(params.tile_wall, params.tile_floor, params.start_fill_percent);
    map.ensureEdgesAreWalls(params.tile_wall);

    var steps:Array<Dynamic> = params.steps;

    for(step in steps){
      for(rep in 0...step.reps){
        buildFromCA(map, params, step);
      }
    }

    map.ensureEdgesAreWalls(params.tile_wall);
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
            // temp.set(pos, params.tile_wall);
            temp.set(pos, params.tile_floor);
        } else {
            temp.set(pos, params.tile_wall);
            // temp.set(pos, params.tile_floor);
        }
      }
    }

    for(i in temp.keys()) {
      var pos = map.IndexToXY(i);
      map.set(pos.x, pos.y, temp[i]);
    }
  }
}

