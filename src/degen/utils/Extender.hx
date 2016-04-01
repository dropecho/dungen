package degen.utils;

class Extender {
	public static function extend(base:Dynamic, extension:Dynamic){
		if(base == null){
			base = {};
		}
		for(ff in Reflect.fields(extension)){

			if(!Reflect.hasField(base,ff)){
				continue;
			}

			var exField = Reflect.field(extension, ff);
			var baseField = Reflect.field(base,ff);

			if(Reflect.isObject(baseField)){
				if(Reflect.isObject(exField)){
					extend(baseField, exField);
				}
				continue;
			}

			Reflect.setField(base, ff, exField);
		}
	}
}
