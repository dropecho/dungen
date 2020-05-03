package dropecho.dungen.utils;

using Lambda;
using StringTools;

typedef BaseObject = {};

class Extender {
	public static function extend(?base:Dynamic, ?extension:Dynamic):Dynamic {
		if (base == null) {
			base = {};
		}

		if (extension == null) {
			return base;
		}

		var extensions:Array<Dynamic>;

		if (Std.is(extension, Array)) {
			extensions = extension.filter(x -> x != null);
		} else {
			extensions = new Array<Dynamic>();
			extensions.push(extension);
		}

		for (ex in extensions) {
			for (ff in Reflect.fields(ex)) {
				var exField = Reflect.field(ex, ff);
				var baseField = Reflect.field(base, ff);

				if (baseField != null && Reflect.isObject(baseField)) {
					if (Std.is(exField, Array)) {
						var arr = cast(exField, Array<Dynamic>);
						Reflect.setField(base, ff, [for (x in arr) x]);
					} else if (Reflect.isObject(exField)) {
						var c = Reflect.copy(baseField);
						Reflect.setField(base, ff, extend(c, exField));
					}
				} else {
					Reflect.setField(base, ff, exField);
				}
			}
		}

		return base;
	}
}
