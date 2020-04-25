package dropecho.dungen.bsp;

import dropecho.dungen.utils.Extender;

@:expose("dungen.BSPData")
class BspData {
	public var width:Int = 0;
	public var height:Int = 0;
	public var x:Int = 0;
	public var y:Int = 0;

	public function new(?ops:Dynamic = null) {
		Extender.extend(this, ops);
	}
}
