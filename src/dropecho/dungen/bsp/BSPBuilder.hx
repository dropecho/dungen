package dropecho.dungen.bsp;

import dropecho.dungen.bsp.BSPData;
import seedyrng.Random;
import dropecho.ds.BSPNode;
import dropecho.ds.BSPTree;
import dropecho.interop.Extender;

typedef BSPBuilderConfigProps = {
	?width:Int,
	?height:Int,
	?minHeight:Int,
	?minWidth:Int,
	?depth:Int,
	?ratio:Float,
	?x:Int,
	?y:Int,
	?seed:String
}

// @:expose("dungen.BSPGeneratorConfig")
class BSPBuilderConfig {
	public var width:Int = 120;
	public var height:Int = 60;
	public var minHeight:Int = 10;
	public var minWidth:Int = 10;
	public var depth:Int = 10;
	public var ratio:Float = .45;
	public var x:Int = 0;
	public var y:Int = 0;
	public var seed:String = "0";
}

@:expose("dungen.BSPGenerator")
class BSPBuilder extends BSPBuilderConfig {
	public var random:Random = new Random();

	public function new(?ops:BSPBuilderConfigProps = null) {
		Extender.extendThis(this, ops);
	}

	public function generate():BSPTree<BSPData> {
		random.setStringSeed(this.seed);
		var rootData = new BSPData({
			height: height,
			width: width,
			x: x,
			y: y
		});

		var tree = new BSPTree(rootData);

		buildTree(tree.getRoot());

		return tree;
	}

	private function buildTree(node:BSPNode<BSPData>, ?level:Int = 0):Void {
		if (node == null || level >= depth) {
			return;
		}

		makeSplit(node);
		buildTree(node.left, level + 1);
		buildTree(node.right, level + 1);
	}

	private function makeSplit(node:BSPNode<BSPData>):Void {
		var data = node.value;
		var left:BSPNode<BSPData>;
		var right:BSPNode<BSPData>;

		var tallEnough = data.height > minHeight * 2;
		var wideEnough = data.width > minWidth * 2;

		var isTooSmallToSplit = !tallEnough && !wideEnough;

		if (isTooSmallToSplit) {
			return;
		}

		var splitHeight = (random.random() > 0.5 && tallEnough) || !wideEnough;

		if (splitHeight) {
			var h = data.height;
			var splitAt = random.randomInt(minHeight, h - minHeight);
			var rHeight = data.height - splitAt;

			left = new BSPNode(new BSPData({
				height: splitAt,
				width: data.width,
				x: data.x,
				y: data.y
			}));
			right = new BSPNode(new BSPData({
				height: rHeight,
				width: data.width,
				x: data.x,
				y: data.y + splitAt
			}));
		} else if (wideEnough) {
			var w = data.width;
			var splitAt = random.randomInt(minWidth, w - minWidth);
			var rWidth = data.width - splitAt;

			left = new BSPNode(new BSPData({
				height: data.height,
				width: splitAt,
				x: data.x,
				y: data.y
			}));
			right = new BSPNode(new BSPData({
				height: data.height,
				width: rWidth,
				x: data.x + splitAt,
				y: data.y
			}));
		} else {
			return;
		}

		node.setLeft(left);
		node.setRight(right);

		return;
	}

	//   private function makeSplit(node:BSPNode<BSPData>):Void {
	//     var val = node.value;
	//     var lData:BSPData;
	//     var rData:BSPData;
	//
	//     // Times two because you need to fit two child nodes into this one.
	//     if (val.width < minWidth * 2 && val.height < minHeight * 2) {
	//       return;
	//     }
	//
	//     var splitAt = 0;
	//     var splitHeight:Bool = random.random() > 0.5;
	//
	//     // Change split direction if one dir is smaller than the ratio allows
	//     if (val.width >= val.height * ratio) {
	//       splitHeight = false;
	//     } else if (val.height >= val.width * ratio) {
	//       splitHeight = true;
	//     } else {
	//       return;
	//     }
	//
	//     if (splitHeight) {
	//       var rnd = random.randomInt(minHeight, Std.int(minHeight * 2));
	//       splitAt = rnd - 1;
	//       var rHeight = val.height - splitAt;
	//
	//       if (rHeight < minHeight) {
	//         return;
	//       }
	//
	//       lData = new BSPData({
	//         height: splitAt,
	//         width: val.width,
	//         x: val.x,
	//         y: val.y
	//       });
	//       rData = new BSPData({
	//         height: rHeight,
	//         width: val.width,
	//         x: val.x,
	//         y: val.y + splitAt
	//       });
	//     } else {
	//       //       splitAt = random.randomInt(0, val.width - (minWidth * 2)) + minWidth;
	//       var rnd = random.randomInt(minWidth, Std.int(minWidth * 2));
	//       splitAt = rnd - 1;
	//       var rWidth = val.width - splitAt;
	//       if (rWidth < minHeight) {
	//         return;
	//       }
	//
	//       lData = new BSPData({
	//         height: val.height,
	//         width: splitAt,
	//         x: val.x,
	//         y: val.y
	//       });
	//       rData = new BSPData({
	//         height: val.height,
	//         width: rWidth,
	//         x: val.x + splitAt,
	//         y: val.y
	//       });
	//     }
	//
	//     node.setLeft(new BSPNode(lData));
	//     node.setRight(new BSPNode(rData));
	//
	//     return;
	//   }
}
