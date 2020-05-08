package dropecho.dungen.export;

import dropecho.dungen.Map2d;
import haxe.Json;

private class TiledMap {
    public var backgroundcolor:String = "#000000";
    public var height:Int = 0;
    public var layers: Array<TiledLayer> = new Array<TiledLayer>();
    public var nextobjectid:Int = 1;
    public var orientation:String = "orthogonal";
    public var properties:Map<String,String> = new Map<String,String>();
    public var renderorder:String = "right-down";
    public var tileheight:Int = 16;
    public var tilesets:Array<TiledTileSet> = new Array<TiledTileSet>();
    public var tilewidth:Int = 16;
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
    public var height:Int = -1;
    public var name:String = "degen";
    public var opacity:Int = 1;
    public var properties: Map<String,String> = new Map<String,String>();
    public var type:String = "tilelayer";
    public var visible:Bool = true;
    public var width:Int = -1;
    public var x:Int = 0;
    public var y:Int = 0;

    public function new(map : Map2d){
        this.height = map._height;
        this.width = map._width;
        this.data = map._mapData;
    }
}

private class TiledTileSet {
    public var firstgid:Int = 1;
    public var image:String = "./test.png";
    public var imageheight:Int = 16;
    public var imagewidth:Int = 32;
    public var margin:Int = 0;
    public var name:String = "degen";
    public var properties: Map<String,String> = new Map<String,String>();
    public var spacing:Int = 0;
    public var tilewidth:Int = 16;
    public var tileheight:Int = 16;

    public function new(){
    }
}


@:expose("dungen.TiledExporter")
class TiledExporter {
    public static function export(map: Map2d) : String {
        var tiled_map : TiledMap = new TiledMap(map);
        var json = Json.stringify(tiled_map, null, " ");

        return json;
    }
}
