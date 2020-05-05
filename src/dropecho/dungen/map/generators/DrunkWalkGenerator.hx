
package dropecho.dungen.map.generators;

import dropecho.dungen.ca.Generator as CAGen;
import dropecho.interop.Extender;

@:expose("dungen.WalkGenerator")
class DrunkWalkGenerator {
  public static function generate(?params:Dynamic) : Map2d {
    var height:Int = params.height;
    var width:Int = params.width;

    var tile_floor:Int = params.tile_floor;
    var tile_wall:Int = params.tile_wall;
    var start_fill_percent:Int = params.start_fill_percent;
    var countOfFilled:Int = 0;
    var totalCount:Int = height * width;

    var map = new Map2d(width, height, tile_wall);

    var walkerPos = {x: Std.int(width / 2), y: Std.int(height/2) };

    map.set(walkerPos.x, walkerPos.y, 0);
    var counter = 0;
    var direction = Std.random(4);

    while(countOfFilled < totalCount * (start_fill_percent/100)){
      direction = Std.random(4);
      if(map.get(walkerPos.x, walkerPos.y) != tile_floor){
        map.set(walkerPos.x, walkerPos.y, tile_floor);
        countOfFilled++;
      }

      walkerPos.y += direction == 0 ? -1 : 0;
      walkerPos.y += direction == 2 ? 1 : 0;

      walkerPos.x += direction == 1 ? -1 : 0;
      walkerPos.x += direction == 3 ? 1 : 0;

      if(walkerPos.x < 0 || walkerPos.x > width -1){
        walkerPos.x = Std.int(width / 2);
        walkerPos.y = Std.int(height / 2);
      }

      if(walkerPos.y < 0 || walkerPos.y > height - 1){
        walkerPos.x = Std.int(width / 2);
        walkerPos.y = Std.int(height / 2);
      }

      if(counter >= 500000){
        break;
      }
      counter++;
    }

    return map;
  }
}
