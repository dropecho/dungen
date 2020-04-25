package dropecho.dungen.map;

import dropecho.dungen.map.Map2d;
import haxe.ds.IntMap;

using Lambda;

class MapHelper {
  public static function isMapConnected(map : Map2d, tile : Int = 0, diagonal : Bool = true) : Bool {
    var start = getFirstEmptyTile(map, tile);
    var filled = floodFill(map, start.x, start.y, tile, diagonal);

    return getFirstEmptyTile(map, tile, filled) == null;
  }

  public static function getFirstEmptyTile(map : Map2d, tile : Int = 0, ignore : Array<Tile2d> = null) : Tile2d {
    for (i in 0...map._height * map._width) {
      if (map._mapData[i] == tile) {
        var cur = map.IndexToXY(i);

        if (ignore != null) {
          var foo = ignore.find(function(tile) {
            return tile.x == cur.x && tile.y == cur.y;
          });

          if (foo != null) {
            continue;
          }
        }

        return cur;
      }
    }

    return null;
  }

  public static function floodFill(map : Map2d, startX : Int, startY: Int, tile: Int = 0, diagonal:Bool = true) : Array<Tile2d> {
    var closed = new IntMap<Tile2d>();
    var open = new Array<Tile2d>();
    var neighbors = new Array<Tile2d>();

    var currentTile = map.IndexToXY(map.XYtoIndex(startX, startY));
    open.push(currentTile);

    function whereHasNotBeenVisited(tile) {
      return closed.get(map.XYtoIndex(tile.x, tile.y)) == null;
    }
    
    function whereTileIsSameType(t){ 
      return map.get(t.x,t.y) == tile; 
    }

    while (open.length > 0) {
      currentTile = open.pop();
      closed.set(map.XYtoIndex(currentTile.x,currentTile.y), currentTile);

      neighbors = map
        .getNeighbors(currentTile.x, currentTile.y, 1, diagonal)
        .filter(whereHasNotBeenVisited)
        .filter(whereTileIsSameType);

      open = open.concat(neighbors);
    }

    return closed.array();
  }

  public static function getHallwayTiles(map : Map2d, tile : Int) : Array<Tile2d> {
    var hallwayTiles = new Array<Tile2d>();

    for (i in 0...map._height) {
      for(j in 0...map._width){
        if(map._mapData[map.XYtoIndex(i, j)] != tile){
          continue;
        }

        var c = map.getNeighborCount(i, j, tile, 2);
        if(c < (2 * 4)){
          
        }
      }
    }


    return hallwayTiles;
  }
}
