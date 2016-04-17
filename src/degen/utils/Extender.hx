package degen.utils;

class Extender {
	public static function extend(base:Dynamic, ?extension:Dynamic):Dynamic{
		if(base == null){
			base = {};
		}

		var extensions : Array<Dynamic>;

		if(Std.is(extension, Array)){
			extensions = extension;
		} else {
			extensions = new Array<Dynamic>();
			extensions.push(extension);
		}

		for(ex in extensions){
			for(ff in Reflect.fields(ex)){
				var exField = Reflect.field(ex, ff);
				var baseField = Reflect.field(base,ff);

				if(baseField != null && Reflect.isObject(baseField)){
					if(Reflect.isObject(exField)){
						extend(baseField, exField);
					}
					continue;
				}

				Reflect.setField(base, ff, exField);
			}
		}

		return base;
	}
}
