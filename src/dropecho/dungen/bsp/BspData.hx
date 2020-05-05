package dropecho.dungen.bsp;

import dropecho.interop.Extender;

@:expose("dungen.BSPData")
class BspData {
	public var width:Int = 0;
	public var height:Int = 0;
	public var x:Int = 0;
	public var y:Int = 0;

	public function new(?ops:Dynamic = null) {
		Extender.extendThis(this, ops);
	}
}
