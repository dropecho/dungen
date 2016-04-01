package degen.export;

import degen.map.Map2d;
import haxe.Json;

private class TiledMap {
    public var backgroundcolor:String = "";
    public var height:Int = 0;
    public var layers: Array<TiledLayer> = new Array<TiledLayer>();
    public var nextobjectid:Int = 0;
    public var orientation:String = "";
    public var properties:Map<String,String> = new Map<String,String>();
    public var renderorder:String = "";
    public var tileheight:Int = 0;
    public var tilesets:Array<TiledTileSet> = new Array<TiledTileSet>();
    public var tilewidth:Int = 0;
    public var version:Int = 1;
    public var width:Int = 0;

    public function new(map : Map2d){
        this.height = map._height;
        this.width = map._width;

        this.layers.push(new TiledLayer(map));
        this.tilesets.push(new TiledTileSet());
    }
}

private class TiledLayer {
    public var data: Array<Int> = new Array<Int>();
    public var height:Int = 0;
    public var name:String = "";
    public var opacity:Int = 0;
    public var properties: Map<String,String> = new Map<String,String>();
    public var type:String = "";
    public var visible:Bool = true;
    public var width:Int = 0;
    public var x:Int = 0;
    public var y:Int = 0;

    public function new(map : Map2d){
        height = map._height;
        width = map._width;
        data = map._mapData;
    }
}

private class TiledTileSet {
    public var firstgid:Int = 0;
    public var image:String = "";
    public var imageheight:Int = 0;
    public var imagewidth:Int = 0;
    public var margin:Int = 0;
    public var name:String = "";
    public var properties: Map<String,String> = new Map<String,String>();
    public var spacing:Int = 0;
    public var tilewidth:Int = 0;

    public function new(){
    }
}

class TiledExporter {
    public static function export(filename : String, map: Map2d) : String{
        var tiled_map : TiledMap = new TiledMap(map);
        var json = Json.stringify(tiled_map, null, " ");
        //trace(json);

        return json;
    }
}
