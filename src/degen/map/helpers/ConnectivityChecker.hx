package degen.map.helpers;

class ConnectivityChecker {
  function check(map : Map2d, tile : Int = 0) : Bool {
    //get random non-filled tile
    var firstEmpty = MapHelper.getFirstEmptyTile(map, tile);
    if(firstEmpty == null){
      return false;
    }

    //floodfill from tile
    var filledTiles = MapHelper.floodFill(map, tile, firstEmpty.x, firstEmpty.y);

    //get random non-filled tile if existing
    //if exists, map is not connected!
    firstEmpty = MapHelper.getFirstEmptyTile(map, tile);

    return firstEmpty != null;

  }
}
