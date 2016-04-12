package degen.bsp;

import degen.utils.Extender;

@:expose("degen.bspNode")
class BspData {
    public var width:Int = 0;
    public var height:Int = 0;
    public var x:Int = 0;
    public var y:Int = 0;

    public function new(?ops:Dynamic = null){
        Extender.extend(this, ops);
    }
}
