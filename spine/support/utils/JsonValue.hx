package spine.support.utils;

interface JsonValue {

    function get(key:String):JsonValue;

    function getAtIndex(index:Int):JsonValue;

    function has(key:String):Bool;

    function getChild(key:String):JsonValue;

    function getString(key:String, defaultValue:String = null):String;

    function getFloat(key:Either<Int,String>, defaultValue:Float = 0):Float;

    function getInt(key:String, defaultValue:Int = 0):Int;

    function getBoolean(key:String, defaultValue:Bool = false):Bool;

    function require(key:String):JsonValue;

    function asString():String;

    function asFloat():Float;

    function asInt():Int;

    function asFloatArray():FloatArray;

    function asShortArray():ShortArray;

    function isString():Bool;

    function isArray():Bool;

    var name(get,never):String;

    var size(get,never):Int;

    var next(get,never):JsonValue;

    var child(get,never):JsonValue;

}

class JsonDynamic implements JsonValue {

    private var data:Dynamic;

    function toString() {
        return 'JsonDynamic:'+data;
    }

    public function new(data:Dynamic) {
        this.data = data;
    }

    public function has(key:String):Bool {
        return get(key) != null;
    }

    public function require(key:String):JsonValue {
        return get(key);
    }

    public function get(key:String):JsonValue {
        if (#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data, std.Array)) {
            return null;
        } else {
            return Reflect.hasField(data, key) ? new JsonDynamic(Reflect.field(data, key)) : null;
        }
    }

    public function getAtIndex(index:Int):JsonValue {
        if (#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data, std.Array)) {
            return new JsonChild(data, index);
        } else {
            return null;
        }
    }

    public function getChild(key:String):JsonValue {
        var item:Dynamic = Reflect.field(data, key);
        if (item == null) {
            return null;
        }
        else {
            var value = new JsonDynamic(item);
            var child = value.child;
            return child;
        }
    }

    public function getString(key:String, defaultValue:String = null):String {
        return Reflect.hasField(data, key) ? Reflect.field(data, key) : defaultValue;
    }

    public function getFloat(key:Either<Int,String>, defaultValue:Float = 0):Float {
        if (#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(key, Int)) {
            if (/*#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data, Array) || */#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data, std.Array)) {
                return data[key];
            } else {
                return defaultValue;
            }
        }
        else {
            return Reflect.hasField(data, key) ? Reflect.field(data, key) : defaultValue;
        }
    }

    public function getInt(key:String, defaultValue:Int = 0):Int {
        return Reflect.hasField(data, key) ? Reflect.field(data, key) : defaultValue;
    }

    public function getBoolean(key:String, defaultValue:Bool = false):Bool {
        return Reflect.hasField(data, key) ? Reflect.field(data, key) : defaultValue;
    }

    public function asString():String {
        return data;
    }

    public function asFloatArray():FloatArray {
        #if cs
        var array:std.Array<Dynamic> = data;
        return cast array;
        #else
        return data;
        #end
    }

    public function asShortArray():ShortArray {
        #if cs
        var array:std.Array<Dynamic> = data;
        return cast array;
        #else
        return data;
        #end
    }

    public function asFloat():Float {
        return data;
    }

    public function asInt():Int {
        return data;
    }

    public function isString():Bool {
        return #if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data, String);
    }

    public function isArray():Bool{
        return /*#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data, Array) || */#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data, std.Array);
    }

    public var next(get,never):JsonValue;
    function get_next():JsonValue {
        return null;
    }

    public var name(get,never):String;
    function get_name():String {
        return null;
    }

    public var size(get,never):Int;
    function get_size():Int {
        if (/*#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data, Array) || */#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data, std.Array)) {
            return data.length;
        }
        return Reflect.fields(data).length;
    }

    public var child(get,never):JsonValue;
    public function get_child():JsonValue {
        var item:Dynamic = data;
        if (item == null) {
            return null;
        }
        else if (/*#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(item, Array) || */#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(item, std.Array)) {
            return new JsonChild(item, 0);
        }
        else {
            var keys:Array<String> = [];
            var values:Array<Dynamic> = [];
            for (field in Reflect.fields(item)) {
                keys.push(field);
                values.push(Reflect.field(item, field));
            }
            if (keys.length == 0) {
                return null;
            }
            return new JsonChild(values, 0, keys);
        }
    }

}

class JsonChild implements JsonValue {

    function toString() {
        return 'JsonChild:'+data[index];
    }

    public var keys:Array<String>;
    public var data:Array<Dynamic>;
    public var index:Int;

    public function new(data:Array<Dynamic>, index:Int, ?keys:Array<String>) {
        this.data = data;
        this.index = index;
        this.keys = keys;
    }

    public function has(key:String):Bool {
        return get(key) != null;
    }

    public function require(key:String):JsonValue {
        return get(key);
    }

    public function get(key:String):JsonValue {
        return Reflect.hasField(data[index], key) ? new JsonDynamic(Reflect.field(data[index], key)) : null;
    }

    public function getAtIndex(idx:Int):JsonValue {
        if (#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data[index], std.Array)) {
            return new JsonChild(data[index], idx);
        } else {
            return null;
        }
    }

    public function getChild(key:String):JsonValue {
        var item:Dynamic = Reflect.field(data[index], key);
        if (item == null) return null;
        else return new JsonDynamic(item).child;
    }

    public function getString(key:String, defaultValue:String = null):String {
        return Reflect.hasField(data[index], key) ? Reflect.field(data[index], key) : defaultValue;
    }

    public function getFloat(key:Either<Int,String>, defaultValue:Float = 0):Float {
        if (#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(key, Int)) {
            if (#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data[index], std.Array)) {
                return getByIndex()[key];
            } else {
                return 0;
            }
        }
        else {
            return Reflect.hasField(data[index], key) ? Reflect.field(data[index], key) : defaultValue;
        }
    }

    public function getInt(key:String, defaultValue:Int = 0):Int {
        return Reflect.hasField(data[index], key) ? Reflect.field(data[index], key) : defaultValue;
    }

    public function getBoolean(key:String, defaultValue:Bool = false):Bool {
        return Reflect.hasField(data[index], key) ? Reflect.field(data[index], key) : defaultValue;
    }

    public function asString():String {
        return data[index];
    }

    public function asFloat():Float {
        return data[index];
    }

    public function asInt():Int {
        return data[index];
    }

    public function isString():Bool {
        return #if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data[index], String);
    }

    public function isArray():Bool{
        return #if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(data[index], std.Array);
    }

    public var next(get,never):JsonValue;
    function get_next():JsonValue {
        var dataArrayAny:Array<Any> = data;
        if (index < dataArrayAny.length - 1) {
            return new JsonChild(data, index + 1, keys);
        }
        else {
            return null;
        }
    }

    public var name(get,never):String;
    function get_name():String {
        return keys != null ? keys[index] : null;
    }

    public var size(get,never):Int;
    function get_size():Int {
        return getByIndex().length;
    }

    public var child(get,never):JsonValue;
    public function get_child():JsonValue {
        var item:Dynamic = data[index];
        if (item == null) return null;
        else if (#if (haxe_ver >= 4.0) Std.isOfType #else Std.is #end(item, std.Array)) {
            return new JsonChild(item, 0);
        }
        else {
            var keys:Array<String> = [];
            var values:Array<Dynamic> = [];
            for (field in Reflect.fields(item)) {
                keys.push(field);
                values.push(Reflect.field(item, field));
            }
            if (keys.length == 0) {
                return null;
            }
            return new JsonChild(values, 0, keys);
        }
        return null;
    }

    public function asFloatArray():FloatArray {
        #if cs
        var array:std.Array<Dynamic> = data[index];
        return cast array;
        #else
        return data[index];
        #end
    }

    public function asShortArray():ShortArray {
        #if cs
        var array:std.Array<Dynamic> = data[index];
        return cast array;
        #else
        return data[index];
        #end
    }

    private inline function getByIndex():Dynamic
    {
        return (data:std.Array<Dynamic>)[index];
    }

}
