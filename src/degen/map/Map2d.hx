package degen.map;

typedef Tile2d = {
  x : Int,
  y : Int,
  onMap : Bool
}

class Map2d {
  public var _width : Int = 0;
  public var _height: Int = 0;
  public var _mapData : Array<Int>;

  public function new(width : Int, height : Int, initTileData : Int = 0){
    _width = width;
    _height = height;
    _mapData = new Array<Int>();

    this.initializeData(initTileData);
  }

  private function initializeData(initTileData : Int) : Void {
    if(initTileData == -1){
      return;
    }

    for(i in 0 ... _height * _width){
      _mapData[i] = initTileData;
    }
  }

  public function fillMapRandomly(wallTile : Int, floorTile : Int, wallPercent:Float = 45) {
    for(i in 0 ... (_width * _height)){
      _mapData[i] = Std.random(100) > wallPercent ? floorTile : wallTile;
    }
  }

  public function ensureEdgesAreWalls(tileType:Int = 0){
    for(x in 0...(_width - 1)){
      _mapData[XYtoIndex(x, 0)] = tileType;
      _mapData[XYtoIndex(x, _height - 1)] = tileType;
    }

    for(y in 0...(_height - 1)){
      _mapData[XYtoIndex(0, y)] = tileType;
      _mapData[XYtoIndex(_width - 1, y)] = tileType;
    }
  }

  public function getNeighborCount(x:Int, y:Int, neighborType:Int, dist:Int = 1) : Int {
    function isNeighborType(tile) {
      return _mapData[XYtoIndex(tile.x, tile.y)] == neighborType || tile.onMap == false;
    }

    return getNeighbors(x, y, dist).filter(isNeighborType).length;
  }

  public function getNeighbors(x:Int, y:Int, dist:Int = 1, diagonal:Bool = true) : Array<Tile2d> {
    var neighbors = new Array<Tile2d>(),
        isSelf = false,
        isNotOnMap = false;

    for(i in -dist...dist+1) {
      for(j in -dist...dist+1) {
        isSelf = (i == 0 && j == 0);
        isNotOnMap = x + i < 0 || x+i > (_width-1) || y+j < 0 || y+j > (_height - 1);

        if(isSelf || isNotOnMap){
          continue;
        }

        if(!diagonal && i == j){
          continue;
        }

        neighbors.push({x:x+i, y: y+j, onMap: true});
      }
    }

    return neighbors;
  }


  public function XYtoIndex(x : Int, y : Int) : Int {
    return (_width * y) + x;
  }

  public function IndexToXY(index : Int) : Tile2d {
    var x = Std.int(index % _width),
        y = Std.int(index / _width);

    return {
      x: x,
      y: y,
      onMap: x >= 0 && y >= 0 && x < _width && y < _height
    }
  }

  public function set(x : Int, y :Int, data : Int) : Void {
    _mapData[XYtoIndex(x, y)] = data;
  }

  public function get(x : Int,y :Int) : Int {
    return _mapData[XYtoIndex(x, y)];
  }

  public function toString() : String {
    var output = "\n MAP2d: \n\n";

    for(y in 0 ... _height){
      for(x in 0 ... _width){
        //output += get(x,y); 
        output += String.fromCharCode(_mapData[XYtoIndex(x,y)]);
      }

      output += "\n";
    }

    return output;
  }
}

