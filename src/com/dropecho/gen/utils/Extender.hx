package com.dropecho.gen.utils;

class Extender {
    public static function extend(base:Dynamic, extension:Dynamic){
        for(ff in Reflect.fields(extension)){
            if(Reflect.hasField(base, ff)){
                var exField = Reflect.field(extension, ff);
                var baseField = Reflect.field(base,ff);

                if(Reflect.isObject(baseField)){
                    extend(baseField, exField);
                } else{
                    Reflect.setField(base, ff, exField);
                }
            }
        }
    }
}
