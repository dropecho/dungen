(function ($hx_exports, $global) { "use strict";
$hx_exports["algos"] = $hx_exports["algos"] || {};
$hx_exports["dungen"] = $hx_exports["dungen"] || {};
var $hxClasses = {},$estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	this.r = new RegExp(r,opt.split("u").join(""));
};
$hxClasses["EReg"] = EReg;
EReg.__name__ = "EReg";
EReg.escape = function(s) {
	return s.replace(EReg.escapeRe,"\\$&");
};
EReg.prototype = {
	r: null
	,match: function(s) {
		if(this.r.global) {
			this.r.lastIndex = 0;
		}
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) {
			return this.r.m[n];
		} else {
			throw haxe_Exception.thrown("EReg::matched");
		}
	}
	,matchedLeft: function() {
		if(this.r.m == null) {
			throw haxe_Exception.thrown("No string matched");
		}
		return HxOverrides.substr(this.r.s,0,this.r.m.index);
	}
	,matchedRight: function() {
		if(this.r.m == null) {
			throw haxe_Exception.thrown("No string matched");
		}
		var sz = this.r.m.index + this.r.m[0].length;
		return HxOverrides.substr(this.r.s,sz,this.r.s.length - sz);
	}
	,matchedPos: function() {
		if(this.r.m == null) {
			throw haxe_Exception.thrown("No string matched");
		}
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,matchSub: function(s,pos,len) {
		if(len == null) {
			len = -1;
		}
		if(this.r.global) {
			this.r.lastIndex = pos;
			this.r.m = this.r.exec(len < 0 ? s : HxOverrides.substr(s,0,pos + len));
			var b = this.r.m != null;
			if(b) {
				this.r.s = s;
			}
			return b;
		} else {
			var b = this.match(len < 0 ? HxOverrides.substr(s,pos,null) : HxOverrides.substr(s,pos,len));
			if(b) {
				this.r.s = s;
				this.r.m.index += pos;
			}
			return b;
		}
	}
	,split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,map: function(s,f) {
		var offset = 0;
		var buf_b = "";
		while(true) {
			if(offset >= s.length) {
				break;
			} else if(!this.matchSub(s,offset)) {
				buf_b += Std.string(HxOverrides.substr(s,offset,null));
				break;
			}
			var p = this.matchedPos();
			buf_b += Std.string(HxOverrides.substr(s,offset,p.pos - offset));
			buf_b += Std.string(f(this));
			if(p.len == 0) {
				buf_b += Std.string(HxOverrides.substr(s,p.pos,1));
				offset = p.pos + 1;
			} else {
				offset = p.pos + p.len;
			}
			if(!this.r.global) {
				break;
			}
		}
		if(!this.r.global && offset > 0 && offset < s.length) {
			buf_b += Std.string(HxOverrides.substr(s,offset,null));
		}
		return buf_b;
	}
	,__class__: EReg
};
var EnumValue = {};
EnumValue.match = function(this1,pattern) {
	return false;
};
var HxOverrides = function() { };
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = "HxOverrides";
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10 ? "0" + m : "" + m) + "-" + (d < 10 ? "0" + d : "" + d) + " " + (h < 10 ? "0" + h : "" + h) + ":" + (mi < 10 ? "0" + mi : "" + mi) + ":" + (s < 10 ? "0" + s : "" + s);
};
HxOverrides.strDate = function(s) {
	switch(s.length) {
	case 8:
		var k = s.split(":");
		var d = new Date();
		d["setTime"](0);
		d["setUTCHours"](k[0]);
		d["setUTCMinutes"](k[1]);
		d["setUTCSeconds"](k[2]);
		return d;
	case 10:
		var k = s.split("-");
		return new Date(k[0],k[1] - 1,k[2],0,0,0);
	case 19:
		var k = s.split(" ");
		var y = k[0].split("-");
		var t = k[1].split(":");
		return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
	default:
		throw haxe_Exception.thrown("Invalid date format : " + s);
	}
};
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) {
		return undefined;
	}
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(len == null) {
		len = s.length;
	} else if(len < 0) {
		if(pos == 0) {
			len = s.length + len;
		} else {
			return "";
		}
	}
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) {
			i = 0;
		}
	}
	while(i < len) {
		if(((a[i]) === obj)) {
			return i;
		}
		++i;
	}
	return -1;
};
HxOverrides.lastIndexOf = function(a,obj,i) {
	var len = a.length;
	if(i >= len) {
		i = len - 1;
	} else if(i < 0) {
		i += len;
	}
	while(i >= 0) {
		if(((a[i]) === obj)) {
			return i;
		}
		--i;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = a.indexOf(obj);
	if(i == -1) {
		return false;
	}
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
HxOverrides.keyValueIter = function(a) {
	return new haxe_iterators_ArrayKeyValueIterator(a);
};
HxOverrides.now = function() {
	return Date.now();
};
var IntIterator = function(min,max) {
	this.min = min;
	this.max = max;
};
$hxClasses["IntIterator"] = IntIterator;
IntIterator.__name__ = "IntIterator";
IntIterator.prototype = {
	min: null
	,max: null
	,hasNext: function() {
		return this.min < this.max;
	}
	,next: function() {
		return this.min++;
	}
	,__class__: IntIterator
};
var Lambda = function() { };
$hxClasses["Lambda"] = Lambda;
Lambda.__name__ = "Lambda";
Lambda.array = function(it) {
	var a = [];
	var i = $getIterator(it);
	while(i.hasNext()) {
		var i1 = i.next();
		a.push(i1);
	}
	return a;
};
Lambda.list = function(it) {
	var l = new haxe_ds_List();
	var i = $getIterator(it);
	while(i.hasNext()) {
		var i1 = i.next();
		l.add(i1);
	}
	return l;
};
Lambda.map = function(it,f) {
	var _g = [];
	var x = $getIterator(it);
	while(x.hasNext()) {
		var x1 = x.next();
		_g.push(f(x1));
	}
	return _g;
};
Lambda.mapi = function(it,f) {
	var i = 0;
	var _g = [];
	var x = $getIterator(it);
	while(x.hasNext()) {
		var x1 = x.next();
		_g.push(f(i++,x1));
	}
	return _g;
};
Lambda.flatten = function(it) {
	var _g = [];
	var e = $getIterator(it);
	while(e.hasNext()) {
		var e1 = e.next();
		var x = $getIterator(e1);
		while(x.hasNext()) {
			var x1 = x.next();
			_g.push(x1);
		}
	}
	return _g;
};
Lambda.flatMap = function(it,f) {
	var _g = [];
	var x = $getIterator(it);
	while(x.hasNext()) {
		var x1 = x.next();
		_g.push(f(x1));
	}
	var _g1 = [];
	var e = $getIterator(_g);
	while(e.hasNext()) {
		var e1 = e.next();
		var x = $getIterator(e1);
		while(x.hasNext()) {
			var x1 = x.next();
			_g1.push(x1);
		}
	}
	return _g1;
};
Lambda.has = function(it,elt) {
	var x = $getIterator(it);
	while(x.hasNext()) {
		var x1 = x.next();
		if(x1 == elt) {
			return true;
		}
	}
	return false;
};
Lambda.exists = function(it,f) {
	var x = $getIterator(it);
	while(x.hasNext()) {
		var x1 = x.next();
		if(f(x1)) {
			return true;
		}
	}
	return false;
};
Lambda.foreach = function(it,f) {
	var x = $getIterator(it);
	while(x.hasNext()) {
		var x1 = x.next();
		if(!f(x1)) {
			return false;
		}
	}
	return true;
};
Lambda.iter = function(it,f) {
	var x = $getIterator(it);
	while(x.hasNext()) {
		var x1 = x.next();
		f(x1);
	}
};
Lambda.filter = function(it,f) {
	var _g = [];
	var x = $getIterator(it);
	while(x.hasNext()) {
		var x1 = x.next();
		if(f(x1)) {
			_g.push(x1);
		}
	}
	return _g;
};
Lambda.fold = function(it,f,first) {
	var x = $getIterator(it);
	while(x.hasNext()) {
		var x1 = x.next();
		first = f(x1,first);
	}
	return first;
};
Lambda.foldi = function(it,f,first) {
	var i = 0;
	var x = $getIterator(it);
	while(x.hasNext()) {
		var x1 = x.next();
		first = f(x1,first,i);
		++i;
	}
	return first;
};
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var _ = $getIterator(it);
		while(_.hasNext()) {
			var _1 = _.next();
			++n;
		}
	} else {
		var x = $getIterator(it);
		while(x.hasNext()) {
			var x1 = x.next();
			if(pred(x1)) {
				++n;
			}
		}
	}
	return n;
};
Lambda.empty = function(it) {
	return !$getIterator(it).hasNext();
};
Lambda.indexOf = function(it,v) {
	var i = 0;
	var v2 = $getIterator(it);
	while(v2.hasNext()) {
		var v21 = v2.next();
		if(v == v21) {
			return i;
		}
		++i;
	}
	return -1;
};
Lambda.find = function(it,f) {
	var v = $getIterator(it);
	while(v.hasNext()) {
		var v1 = v.next();
		if(f(v1)) {
			return v1;
		}
	}
	return null;
};
Lambda.findIndex = function(it,f) {
	var i = 0;
	var v = $getIterator(it);
	while(v.hasNext()) {
		var v1 = v.next();
		if(f(v1)) {
			return i;
		}
		++i;
	}
	return -1;
};
Lambda.concat = function(a,b) {
	var l = [];
	var x = $getIterator(a);
	while(x.hasNext()) {
		var x1 = x.next();
		l.push(x1);
	}
	var x = $getIterator(b);
	while(x.hasNext()) {
		var x1 = x.next();
		l.push(x1);
	}
	return l;
};
Math.__name__ = "Math";
var Reflect = function() { };
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = "Reflect";
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
};
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( _g ) {
		haxe_NativeStackTrace.lastError = _g;
		return null;
	}
};
Reflect.setField = function(o,field,value) {
	o[field] = value;
};
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) {
		return null;
	} else {
		var tmp1;
		if(o.__properties__) {
			tmp = o.__properties__["get_" + field];
			tmp1 = tmp;
		} else {
			tmp1 = false;
		}
		if(tmp1) {
			return o[tmp]();
		} else {
			return o[field];
		}
	}
};
Reflect.setProperty = function(o,field,value) {
	var tmp;
	var tmp1;
	if(o.__properties__) {
		tmp = o.__properties__["set_" + field];
		tmp1 = tmp;
	} else {
		tmp1 = false;
	}
	if(tmp1) {
		o[tmp](value);
	} else {
		o[field] = value;
	}
};
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) {
			a.push(f);
		}
		}
	}
	return a;
};
Reflect.isFunction = function(f) {
	if(typeof(f) == "function") {
		return !(f.__name__ || f.__ename__);
	} else {
		return false;
	}
};
Reflect.compare = function(a,b) {
	if(a == b) {
		return 0;
	} else if(a > b) {
		return 1;
	} else {
		return -1;
	}
};
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) {
		return true;
	}
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) {
		return false;
	}
	if(f1.scope == f2.scope && f1.method == f2.method) {
		return f1.method != null;
	} else {
		return false;
	}
};
Reflect.isObject = function(v) {
	if(v == null) {
		return false;
	}
	var t = typeof(v);
	if(!(t == "string" || t == "object" && v.__enum__ == null)) {
		if(t == "function") {
			return (v.__name__ || v.__ename__) != null;
		} else {
			return false;
		}
	} else {
		return true;
	}
};
Reflect.isEnumValue = function(v) {
	if(v != null) {
		return v.__enum__ != null;
	} else {
		return false;
	}
};
Reflect.deleteField = function(o,field) {
	if(!Object.prototype.hasOwnProperty.call(o,field)) {
		return false;
	}
	delete(o[field]);
	return true;
};
Reflect.copy = function(o) {
	if(o == null) {
		return null;
	}
	var o2 = { };
	var _g = 0;
	var _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
};
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice;
		var a1 = arguments;
		var a2 = a.call(a1);
		return f(a2);
	};
};
var Std = function() { };
$hxClasses["Std"] = Std;
Std.__name__ = "Std";
Std.is = function(v,t) {
	return js_Boot.__instanceof(v,t);
};
Std.isOfType = function(v,t) {
	return js_Boot.__instanceof(v,t);
};
Std.downcast = function(value,c) {
	if(js_Boot.__downcastCheck(value,c)) {
		return value;
	} else {
		return null;
	}
};
Std.instance = function(value,c) {
	if(js_Boot.__downcastCheck(value,c)) {
		return value;
	} else {
		return null;
	}
};
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.int = function(x) {
	return x | 0;
};
Std.parseInt = function(x) {
	if(x != null) {
		var _g = 0;
		var _g1 = x.length;
		while(_g < _g1) {
			var i = _g++;
			var c = x.charCodeAt(i);
			if(c <= 8 || c >= 14 && c != 32 && c != 45) {
				var nc = x.charCodeAt(i + 1);
				var v = parseInt(x,nc == 120 || nc == 88 ? 16 : 10);
				if(isNaN(v)) {
					return null;
				} else {
					return v;
				}
			}
		}
	}
	return null;
};
Std.parseFloat = function(x) {
	return parseFloat(x);
};
Std.random = function(x) {
	if(x <= 0) {
		return 0;
	} else {
		return Math.floor(Math.random() * x);
	}
};
var StringBuf = function() {
	this.b = "";
};
$hxClasses["StringBuf"] = StringBuf;
StringBuf.__name__ = "StringBuf";
StringBuf.prototype = {
	b: null
	,get_length: function() {
		return this.b.length;
	}
	,add: function(x) {
		this.b += Std.string(x);
	}
	,addChar: function(c) {
		this.b += String.fromCodePoint(c);
	}
	,addSub: function(s,pos,len) {
		this.b += len == null ? HxOverrides.substr(s,pos,null) : HxOverrides.substr(s,pos,len);
	}
	,toString: function() {
		return this.b;
	}
	,__class__: StringBuf
	,__properties__: {get_length:"get_length"}
};
var haxe_SysTools = function() { };
$hxClasses["haxe.SysTools"] = haxe_SysTools;
haxe_SysTools.__name__ = "haxe.SysTools";
haxe_SysTools.quoteUnixArg = function(argument) {
	if(argument == "") {
		return "''";
	}
	if(!new EReg("[^a-zA-Z0-9_@%+=:,./-]","").match(argument)) {
		return argument;
	}
	return "'" + StringTools.replace(argument,"'","'\"'\"'") + "'";
};
haxe_SysTools.quoteWinArg = function(argument,escapeMetaCharacters) {
	if(!new EReg("^[^ \t\\\\\"]+$","").match(argument)) {
		var result_b = "";
		var needquote = argument.indexOf(" ") != -1 || argument.indexOf("\t") != -1 || argument == "";
		if(needquote) {
			result_b += "\"";
		}
		var bs_buf = new StringBuf();
		var _g = 0;
		var _g1 = argument.length;
		while(_g < _g1) {
			var i = _g++;
			var _g2 = HxOverrides.cca(argument,i);
			if(_g2 == null) {
				var c = _g2;
				if(bs_buf.b.length > 0) {
					result_b += Std.string(bs_buf.b);
					bs_buf = new StringBuf();
				}
				result_b += String.fromCodePoint(c);
			} else {
				switch(_g2) {
				case 34:
					var bs = bs_buf.b;
					result_b += bs == null ? "null" : "" + bs;
					result_b += bs == null ? "null" : "" + bs;
					bs_buf = new StringBuf();
					result_b += "\\\"";
					break;
				case 92:
					bs_buf.b += "\\";
					break;
				default:
					var c1 = _g2;
					if(bs_buf.b.length > 0) {
						result_b += Std.string(bs_buf.b);
						bs_buf = new StringBuf();
					}
					result_b += String.fromCodePoint(c1);
				}
			}
		}
		result_b += Std.string(bs_buf.b);
		if(needquote) {
			result_b += Std.string(bs_buf.b);
			result_b += "\"";
		}
		argument = result_b;
	}
	if(escapeMetaCharacters) {
		var result_b = "";
		var _g = 0;
		var _g1 = argument.length;
		while(_g < _g1) {
			var i = _g++;
			var c = HxOverrides.cca(argument,i);
			if(haxe_SysTools.winMetaCharacters.indexOf(c) >= 0) {
				result_b += String.fromCodePoint(94);
			}
			result_b += String.fromCodePoint(c);
		}
		return result_b;
	} else {
		return argument;
	}
};
var StringTools = function() { };
$hxClasses["StringTools"] = StringTools;
StringTools.__name__ = "StringTools";
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
};
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
};
StringTools.htmlEscape = function(s,quotes) {
	var buf_b = "";
	var _g_offset = 0;
	var _g_s = s;
	while(_g_offset < _g_s.length) {
		var s = _g_s;
		var index = _g_offset++;
		var c = s.charCodeAt(index);
		if(c >= 55296 && c <= 56319) {
			c = c - 55232 << 10 | s.charCodeAt(index + 1) & 1023;
		}
		var c1 = c;
		if(c1 >= 65536) {
			++_g_offset;
		}
		var code = c1;
		switch(code) {
		case 34:
			if(quotes) {
				buf_b += "&quot;";
			} else {
				buf_b += String.fromCodePoint(code);
			}
			break;
		case 38:
			buf_b += "&amp;";
			break;
		case 39:
			if(quotes) {
				buf_b += "&#039;";
			} else {
				buf_b += String.fromCodePoint(code);
			}
			break;
		case 60:
			buf_b += "&lt;";
			break;
		case 62:
			buf_b += "&gt;";
			break;
		default:
			buf_b += String.fromCodePoint(code);
		}
	}
	return buf_b;
};
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&quot;").join("\"").split("&#039;").join("'").split("&amp;").join("&");
};
StringTools.contains = function(s,value) {
	return s.indexOf(value) != -1;
};
StringTools.startsWith = function(s,start) {
	if(s.length >= start.length) {
		return s.lastIndexOf(start,0) == 0;
	} else {
		return false;
	}
};
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	if(slen >= elen) {
		return s.indexOf(end,slen - elen) == slen - elen;
	} else {
		return false;
	}
};
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	if(!(c > 8 && c < 14)) {
		return c == 32;
	} else {
		return true;
	}
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,r,l - r);
	} else {
		return s;
	}
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,0,l - r);
	} else {
		return s;
	}
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
StringTools.lpad = function(s,c,l) {
	if(c.length <= 0) {
		return s;
	}
	var buf_b = "";
	l -= s.length;
	while(buf_b.length < l) buf_b += c == null ? "null" : "" + c;
	buf_b += s == null ? "null" : "" + s;
	return buf_b;
};
StringTools.rpad = function(s,c,l) {
	if(c.length <= 0) {
		return s;
	}
	var buf_b = "";
	buf_b += s == null ? "null" : "" + s;
	while(buf_b.length < l) buf_b += c == null ? "null" : "" + c;
	return buf_b;
};
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	while(true) {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
		if(!(n > 0)) {
			break;
		}
	}
	if(digits != null) {
		while(s.length < digits) s = "0" + s;
	}
	return s;
};
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
};
StringTools.unsafeCodeAt = function(s,index) {
	return s.charCodeAt(index);
};
StringTools.iterator = function(s) {
	return new haxe_iterators_StringIterator(s);
};
StringTools.keyValueIterator = function(s) {
	return new haxe_iterators_StringKeyValueIterator(s);
};
StringTools.isEof = function(c) {
	return c != c;
};
StringTools.quoteUnixArg = function(argument) {
	if(argument == "") {
		return "''";
	} else if(!new EReg("[^a-zA-Z0-9_@%+=:,./-]","").match(argument)) {
		return argument;
	} else {
		return "'" + StringTools.replace(argument,"'","'\"'\"'") + "'";
	}
};
StringTools.quoteWinArg = function(argument,escapeMetaCharacters) {
	var argument1 = argument;
	if(!new EReg("^[^ \t\\\\\"]+$","").match(argument1)) {
		var result_b = "";
		var needquote = argument1.indexOf(" ") != -1 || argument1.indexOf("\t") != -1 || argument1 == "";
		if(needquote) {
			result_b += "\"";
		}
		var bs_buf = new StringBuf();
		var _g = 0;
		var _g1 = argument1.length;
		while(_g < _g1) {
			var i = _g++;
			var _g2 = HxOverrides.cca(argument1,i);
			if(_g2 == null) {
				var c = _g2;
				if(bs_buf.b.length > 0) {
					result_b += Std.string(bs_buf.b);
					bs_buf = new StringBuf();
				}
				result_b += String.fromCodePoint(c);
			} else {
				switch(_g2) {
				case 34:
					var bs = bs_buf.b;
					result_b += Std.string(bs);
					result_b += Std.string(bs);
					bs_buf = new StringBuf();
					result_b += "\\\"";
					break;
				case 92:
					bs_buf.b += "\\";
					break;
				default:
					var c1 = _g2;
					if(bs_buf.b.length > 0) {
						result_b += Std.string(bs_buf.b);
						bs_buf = new StringBuf();
					}
					result_b += String.fromCodePoint(c1);
				}
			}
		}
		result_b += Std.string(bs_buf.b);
		if(needquote) {
			result_b += Std.string(bs_buf.b);
			result_b += "\"";
		}
		argument1 = result_b;
	}
	if(escapeMetaCharacters) {
		var result_b = "";
		var _g = 0;
		var _g1 = argument1.length;
		while(_g < _g1) {
			var i = _g++;
			var c = HxOverrides.cca(argument1,i);
			if(haxe_SysTools.winMetaCharacters.indexOf(c) >= 0) {
				result_b += String.fromCodePoint(94);
			}
			result_b += String.fromCodePoint(c);
		}
		return result_b;
	} else {
		return argument1;
	}
};
StringTools.utf16CodePointAt = function(s,index) {
	var c = s.charCodeAt(index);
	if(c >= 55296 && c <= 56319) {
		c = c - 55232 << 10 | s.charCodeAt(index + 1) & 1023;
	}
	return c;
};
var ValueType = $hxEnums["ValueType"] = { __ename__:"ValueType",__constructs__:null
	,TNull: {_hx_name:"TNull",_hx_index:0,__enum__:"ValueType",toString:$estr}
	,TInt: {_hx_name:"TInt",_hx_index:1,__enum__:"ValueType",toString:$estr}
	,TFloat: {_hx_name:"TFloat",_hx_index:2,__enum__:"ValueType",toString:$estr}
	,TBool: {_hx_name:"TBool",_hx_index:3,__enum__:"ValueType",toString:$estr}
	,TObject: {_hx_name:"TObject",_hx_index:4,__enum__:"ValueType",toString:$estr}
	,TFunction: {_hx_name:"TFunction",_hx_index:5,__enum__:"ValueType",toString:$estr}
	,TClass: ($_=function(c) { return {_hx_index:6,c:c,__enum__:"ValueType",toString:$estr}; },$_._hx_name="TClass",$_.__params__ = ["c"],$_)
	,TEnum: ($_=function(e) { return {_hx_index:7,e:e,__enum__:"ValueType",toString:$estr}; },$_._hx_name="TEnum",$_.__params__ = ["e"],$_)
	,TUnknown: {_hx_name:"TUnknown",_hx_index:8,__enum__:"ValueType",toString:$estr}
};
ValueType.__constructs__ = [ValueType.TNull,ValueType.TInt,ValueType.TFloat,ValueType.TBool,ValueType.TObject,ValueType.TFunction,ValueType.TClass,ValueType.TEnum,ValueType.TUnknown];
ValueType.__empty_constructs__ = [ValueType.TNull,ValueType.TInt,ValueType.TFloat,ValueType.TBool,ValueType.TObject,ValueType.TFunction,ValueType.TUnknown];
var Type = function() { };
$hxClasses["Type"] = Type;
Type.__name__ = "Type";
Type.getClass = function(o) {
	return js_Boot.getClass(o);
};
Type.getEnum = function(o) {
	if(o == null) {
		return null;
	}
	return $hxEnums[o.__enum__];
};
Type.getSuperClass = function(c) {
	return c.__super__;
};
Type.getClassName = function(c) {
	return c.__name__;
};
Type.getEnumName = function(e) {
	return e.__ename__;
};
Type.resolveClass = function(name) {
	return $hxClasses[name];
};
Type.resolveEnum = function(name) {
	return $hxEnums[name];
};
Type.createInstance = function(cl,args) {
	var ctor = Function.prototype.bind.apply(cl,[null].concat(args));
	return new (ctor);
};
Type.createEmptyInstance = function(cl) {
	return Object.create(cl.prototype);
};
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) {
		throw haxe_Exception.thrown("No such constructor " + constr);
	}
	if(Reflect.isFunction(f)) {
		if(params == null) {
			throw haxe_Exception.thrown("Constructor " + constr + " need parameters");
		}
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) {
		throw haxe_Exception.thrown("Constructor " + constr + " does not need parameters");
	}
	return f;
};
Type.createEnumIndex = function(e,index,params) {
	var c;
	var _g = e.__constructs__[index];
	if(_g == null) {
		c = null;
	} else {
		var ctor = _g;
		c = ctor._hx_name;
	}
	if(c == null) {
		throw haxe_Exception.thrown(index + " is not a valid enum constructor index");
	}
	return Type.createEnum(e,c,params);
};
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
};
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	HxOverrides.remove(a,"__name__");
	HxOverrides.remove(a,"__interfaces__");
	HxOverrides.remove(a,"__properties__");
	HxOverrides.remove(a,"__super__");
	HxOverrides.remove(a,"__meta__");
	HxOverrides.remove(a,"prototype");
	return a;
};
Type.getEnumConstructs = function(e) {
	var _this = e.__constructs__;
	var result = new Array(_this.length);
	var _g = 0;
	var _g1 = _this.length;
	while(_g < _g1) {
		var i = _g++;
		result[i] = _this[i]._hx_name;
	}
	return result;
};
Type.typeof = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "function":
		if(v.__name__ || v.__ename__) {
			return ValueType.TObject;
		}
		return ValueType.TFunction;
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) {
			return ValueType.TInt;
		}
		return ValueType.TFloat;
	case "object":
		if(v == null) {
			return ValueType.TNull;
		}
		var e = v.__enum__;
		if(e != null) {
			return ValueType.TEnum($hxEnums[e]);
		}
		var c = js_Boot.getClass(v);
		if(c != null) {
			return ValueType.TClass(c);
		}
		return ValueType.TObject;
	case "string":
		return ValueType.TClass(String);
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
};
Type.enumEq = function(a,b) {
	if(a == b) {
		return true;
	}
	try {
		var e = a.__enum__;
		if(e == null || e != b.__enum__) {
			return false;
		}
		if(a._hx_index != b._hx_index) {
			return false;
		}
		var enm = $hxEnums[e];
		var params = enm.__constructs__[a._hx_index].__params__;
		var _g = 0;
		while(_g < params.length) {
			var f = params[_g];
			++_g;
			if(!Type.enumEq(a[f],b[f])) {
				return false;
			}
		}
	} catch( _g ) {
		haxe_NativeStackTrace.lastError = _g;
		return false;
	}
	return true;
};
Type.enumConstructor = function(e) {
	return $hxEnums[e.__enum__].__constructs__[e._hx_index]._hx_name;
};
Type.enumParameters = function(e) {
	var enm = $hxEnums[e.__enum__];
	var params = enm.__constructs__[e._hx_index].__params__;
	if(params != null) {
		var _g = [];
		var _g1 = 0;
		while(_g1 < params.length) {
			var p = params[_g1];
			++_g1;
			_g.push(e[p]);
		}
		return _g;
	} else {
		return [];
	}
};
Type.enumIndex = function(e) {
	return e._hx_index;
};
Type.allEnums = function(e) {
	return e.__empty_constructs__.slice();
};
var UInt = {};
UInt.add = function(a,b) {
	return a + b;
};
UInt.div = function(a,b) {
	return UInt.toFloat(a) / UInt.toFloat(b);
};
UInt.mul = function(a,b) {
	return a * b;
};
UInt.sub = function(a,b) {
	return a - b;
};
UInt.gt = function(a,b) {
	var aNeg = a < 0;
	var bNeg = b < 0;
	if(aNeg != bNeg) {
		return aNeg;
	} else {
		return a > b;
	}
};
UInt.gte = function(a,b) {
	var aNeg = a < 0;
	var bNeg = b < 0;
	if(aNeg != bNeg) {
		return aNeg;
	} else {
		return a >= b;
	}
};
UInt.lt = function(a,b) {
	return UInt.gt(b,a);
};
UInt.lte = function(a,b) {
	return UInt.gte(b,a);
};
UInt.and = function(a,b) {
	return a & b;
};
UInt.or = function(a,b) {
	return a | b;
};
UInt.xor = function(a,b) {
	return a ^ b;
};
UInt.shl = function(a,b) {
	return a << b;
};
UInt.shr = function(a,b) {
	return a >>> b;
};
UInt.ushr = function(a,b) {
	return a >>> b;
};
UInt.mod = function(a,b) {
	return UInt.toFloat(a) % UInt.toFloat(b) | 0;
};
UInt.addWithFloat = function(a,b) {
	return UInt.toFloat(a) + b;
};
UInt.mulWithFloat = function(a,b) {
	return UInt.toFloat(a) * b;
};
UInt.divFloat = function(a,b) {
	return UInt.toFloat(a) / b;
};
UInt.floatDiv = function(a,b) {
	return a / UInt.toFloat(b);
};
UInt.subFloat = function(a,b) {
	return UInt.toFloat(a) - b;
};
UInt.floatSub = function(a,b) {
	return a - UInt.toFloat(b);
};
UInt.gtFloat = function(a,b) {
	return UInt.toFloat(a) > b;
};
UInt.equalsInt = function(a,b) {
	return a == b;
};
UInt.notEqualsInt = function(a,b) {
	return a != b;
};
UInt.equalsFloat = function(a,b) {
	return UInt.toFloat(a) == b;
};
UInt.notEqualsFloat = function(a,b) {
	return UInt.toFloat(a) != b;
};
UInt.gteFloat = function(a,b) {
	return UInt.toFloat(a) >= b;
};
UInt.floatGt = function(a,b) {
	return a > UInt.toFloat(b);
};
UInt.floatGte = function(a,b) {
	return a >= UInt.toFloat(b);
};
UInt.ltFloat = function(a,b) {
	return UInt.toFloat(a) < b;
};
UInt.lteFloat = function(a,b) {
	return UInt.toFloat(a) <= b;
};
UInt.floatLt = function(a,b) {
	return a < UInt.toFloat(b);
};
UInt.floatLte = function(a,b) {
	return a <= UInt.toFloat(b);
};
UInt.modFloat = function(a,b) {
	return UInt.toFloat(a) % b;
};
UInt.floatMod = function(a,b) {
	return a % UInt.toFloat(b);
};
UInt.negBits = function(this1) {
	return ~this1;
};
UInt.prefixIncrement = function(this1) {
	return ++this1;
};
UInt.postfixIncrement = function(this1) {
	return this1++;
};
UInt.prefixDecrement = function(this1) {
	return --this1;
};
UInt.postfixDecrement = function(this1) {
	return this1--;
};
UInt.toString = function(this1,radix) {
	return Std.string(UInt.toFloat(this1));
};
UInt.toInt = function(this1) {
	return this1;
};
UInt.toFloat = function(this1) {
	var int = this1;
	if(int < 0) {
		return 4294967296.0 + int;
	} else {
		return int + 0.0;
	}
};
var dropecho_ds_GraphNode = $hx_exports["GraphNode"] = function(value,id) {
	this.id = id != null ? id : Std.string(Std.random(10000000));
	this.value = value;
};
$hxClasses["dropecho.ds.GraphNode"] = dropecho_ds_GraphNode;
dropecho_ds_GraphNode.__name__ = "dropecho.ds.GraphNode";
dropecho_ds_GraphNode.prototype = {
	id: null
	,value: null
	,graph: null
	,__class__: dropecho_ds_GraphNode
};
var dropecho_ds_BSPNode = $hx_exports["BSPNode"] = function(value) {
	dropecho_ds_GraphNode.call(this,value);
};
$hxClasses["dropecho.ds.BSPNode"] = dropecho_ds_BSPNode;
dropecho_ds_BSPNode.__name__ = "dropecho.ds.BSPNode";
dropecho_ds_BSPNode.__super__ = dropecho_ds_GraphNode;
dropecho_ds_BSPNode.prototype = $extend(dropecho_ds_GraphNode.prototype,{
	parent: null
	,left: null
	,right: null
	,createLeft: function(value) {
		return this.setLeft(new dropecho_ds_BSPNode(value));
	}
	,createRight: function(value) {
		return this.setRight(new dropecho_ds_BSPNode(value));
	}
	,setLeft: function(node) {
		this.left = node;
		node.parent = this;
		this.graph.addNode(node);
		this.graph.addUniEdge(this.id,node.id,"left");
		this.graph.addUniEdge(node.id,this.id,"parent");
		return node;
	}
	,setRight: function(node) {
		this.right = node;
		node.parent = this;
		this.graph.addNode(node);
		this.graph.addUniEdge(this.id,node.id,"right");
		this.graph.addUniEdge(node.id,this.id,"parent");
		return node;
	}
	,isLeaf: function() {
		if(this.right == null) {
			return this.left == null;
		} else {
			return false;
		}
	}
	,isRoot: function() {
		return this.parent == null;
	}
	,hasLeft: function() {
		return this.left != null;
	}
	,hasRight: function() {
		return this.right != null;
	}
	,__class__: dropecho_ds_BSPNode
});
var dropecho_ds_Graph = $hx_exports["Graph"] = function() {
	this.nodes = dropecho_interop_AbstractMap._new();
	this.edges = dropecho_interop_AbstractMap._new();
};
$hxClasses["dropecho.ds.Graph"] = dropecho_ds_Graph;
dropecho_ds_Graph.__name__ = "dropecho.ds.Graph";
dropecho_ds_Graph.prototype = {
	nodes: null
	,edges: null
	,createNode: function(value,id) {
		return this.addNode(new dropecho_ds_GraphNode(value,id));
	}
	,addNode: function(node) {
		this.nodes[Std.string(node.id)] = node;
		node.graph = this;
		return node;
	}
	,addUniEdge: function(fromId,toId,data) {
		if(!Object.prototype.hasOwnProperty.call(this.edges,fromId == null ? "null" : "" + fromId)) {
			var this1 = this.edges;
			var value = dropecho_interop_AbstractMap._new();
			this1[fromId == null ? "null" : "" + fromId] = value;
		}
		this.edges[fromId == null ? "null" : "" + fromId][toId == null ? "null" : "" + toId] = data;
	}
	,addBiEdge: function(nodeId,otherId,data) {
		this.addUniEdge(nodeId,otherId,data);
		this.addUniEdge(otherId,nodeId,data);
	}
	,remove: function(id) {
		var _g = 0;
		var _g1 = this.inNeighborIds(this.nodes[id == null ? "null" : "" + id]);
		while(_g < _g1.length) {
			var n = _g1[_g];
			++_g;
			Reflect.deleteField(this.edges[n == null ? "null" : "" + n],id);
		}
		Reflect.deleteField(this.edges,id);
		Reflect.deleteField(this.nodes,id);
	}
	,inNeighbors: function(node,filter) {
		var _gthis = this;
		var _this = this.inNeighborIds(node,filter);
		var result = new Array(_this.length);
		var _g = 0;
		var _g1 = _this.length;
		while(_g < _g1) {
			var i = _g++;
			var id = _this[i];
			result[i] = _gthis.nodes[id == null ? "null" : "" + id];
		}
		return result;
	}
	,inNeighborIds: function(node,filter) {
		var _g = [];
		var _g1 = new dropecho_interop_JSAbstractMapKeyValueIterator(this.edges);
		while(_g1.hasNext()) {
			var _g2 = _g1.next();
			var id = _g2.key;
			var edge = _g2.value;
			if(Object.prototype.hasOwnProperty.call(edge,Std.string(node.id)) && (filter == null || filter(id,edge[Std.string(node.id)]))) {
				_g.push(id);
			}
		}
		var ids = _g;
		return ids;
	}
	,outNeighbors: function(node,filter) {
		var _gthis = this;
		var _this = this.outNeighborIds(node,filter);
		var result = new Array(_this.length);
		var _g = 0;
		var _g1 = _this.length;
		while(_g < _g1) {
			var i = _g++;
			var id = _this[i];
			result[i] = _gthis.nodes[id == null ? "null" : "" + id];
		}
		return result;
	}
	,outNeighborIds: function(node,filter) {
		if(!Object.prototype.hasOwnProperty.call(this.edges,Std.string(node.id))) {
			return [];
		}
		var _g = [];
		var _g1 = new dropecho_interop_JSAbstractMapKeyValueIterator(this.edges[Std.string(node.id)]);
		while(_g1.hasNext()) {
			var _g2 = _g1.next();
			var id = _g2.key;
			var data = _g2.value;
			if(filter == null || filter(id,data)) {
				_g.push(id);
			}
		}
		var ids = _g;
		haxe_ds_ArraySort.sort(ids,Reflect.compare);
		return ids;
	}
	,neighborIds: function(node,filter) {
		return this.outNeighborIds(node,filter).concat(this.inNeighborIds(node,filter));
	}
	,neighbors: function(node,filter) {
		return this.outNeighbors(node,filter).concat(this.inNeighbors(node,filter));
	}
	,edgeData: function(fromId,toId) {
		if(Object.prototype.hasOwnProperty.call(this.edges,fromId == null ? "null" : "" + fromId)) {
			var edgefrom = this.edges[fromId == null ? "null" : "" + fromId];
			if(Object.prototype.hasOwnProperty.call(edgefrom,toId == null ? "null" : "" + toId)) {
				return edgefrom[toId == null ? "null" : "" + toId];
			}
		}
		return null;
	}
	,toString: function() {
		var adjList = "\nGraph:\n";
		adjList += "out-Neighbors:\n";
		var access = this.nodes;
		var _g_access = access;
		var _g_keys = Reflect.fields(access);
		var _g_index = 0;
		while(_g_index < _g_keys.length) {
			var node = _g_access[_g_keys[_g_index++]];
			adjList += node.id;
			adjList += "\t-> ";
			var neighbors = this.outNeighbors(node);
			var _g = 0;
			while(_g < neighbors.length) {
				var node1 = neighbors[_g];
				++_g;
				adjList += node1.id;
				if(neighbors.indexOf(node1) != neighbors.length - 1) {
					adjList += ",";
				}
			}
			adjList += "\n";
		}
		adjList += "in-Neighbors:\n";
		var access = this.nodes;
		var _g1_access = access;
		var _g1_keys = Reflect.fields(access);
		var _g1_index = 0;
		while(_g1_index < _g1_keys.length) {
			var node = _g1_access[_g1_keys[_g1_index++]];
			adjList += node.id;
			adjList += "\t-> ";
			var neighbors = this.inNeighbors(node);
			var _g = 0;
			while(_g < neighbors.length) {
				var node1 = neighbors[_g];
				++_g;
				adjList += node1.id;
				if(neighbors.indexOf(node1) != neighbors.length - 1) {
					adjList += ",";
				}
			}
			adjList += "\n";
		}
		return adjList;
	}
	,__class__: dropecho_ds_Graph
};
var dropecho_ds_BSPTree = $hx_exports["BSPTree"] = function(rootValue) {
	dropecho_ds_Graph.call(this);
	this.root = new dropecho_ds_BSPNode(rootValue);
	this.addNode(this.root);
};
$hxClasses["dropecho.ds.BSPTree"] = dropecho_ds_BSPTree;
dropecho_ds_BSPTree.__name__ = "dropecho.ds.BSPTree";
dropecho_ds_BSPTree.__super__ = dropecho_ds_Graph;
dropecho_ds_BSPTree.prototype = $extend(dropecho_ds_Graph.prototype,{
	root: null
	,getParent: function(node) {
		return this.outNeighbors(node,function(id,data) {
			return data == "parent";
		})[0];
	}
	,getChildren: function(node) {
		return this.outNeighbors(node,function(id,data) {
			if(data != "left") {
				return data == "right";
			} else {
				return true;
			}
		});
	}
	,getRoot: function() {
		return this.root;
	}
	,getLeafs: function() {
		var _g = [];
		var access = this.nodes;
		var _g1_access = access;
		var _g1_keys = Reflect.fields(access);
		var _g1_index = 0;
		while(_g1_index < _g1_keys.length) {
			var node = _g1_access[_g1_keys[_g1_index++]];
			var tmp;
			if(this.getChildren(node).length == 0) {
				tmp = node;
			} else {
				continue;
			}
			_g.push(tmp);
		}
		return _g;
	}
	,__class__: dropecho_ds_BSPTree
});
var dropecho_ds_algos_InOrderTraversal = $hx_exports["algos"]["InOrderTraversal"] = function() {
	this.visited = [];
};
$hxClasses["dropecho.ds.algos.InOrderTraversal"] = dropecho_ds_algos_InOrderTraversal;
dropecho_ds_algos_InOrderTraversal.__name__ = "dropecho.ds.algos.InOrderTraversal";
dropecho_ds_algos_InOrderTraversal.prototype = {
	visited: null
	,run: function(node,visitor) {
		if(node.left != null) {
			this.run(node.left,visitor);
		}
		if(visitor != null) {
			if(visitor(node)) {
				this.visited.push(node.id);
			} else {
				return this.visited;
			}
		} else {
			this.visited.push(node.id);
		}
		if(node.right != null) {
			this.run(node.right,visitor);
		}
		return this.visited;
	}
	,__class__: dropecho_ds_algos_InOrderTraversal
};
var dropecho_ds_algos_PostOrderTraversal = $hx_exports["algos"]["PostOrderTraversal"] = function() {
	this.visited = [];
};
$hxClasses["dropecho.ds.algos.PostOrderTraversal"] = dropecho_ds_algos_PostOrderTraversal;
dropecho_ds_algos_PostOrderTraversal.__name__ = "dropecho.ds.algos.PostOrderTraversal";
dropecho_ds_algos_PostOrderTraversal.prototype = {
	visited: null
	,run: function(node,visitor) {
		if(node.left != null) {
			this.run(node.left,visitor);
		}
		if(node.right != null) {
			this.run(node.right,visitor);
		}
		if(visitor != null) {
			if(visitor(node)) {
				this.visited.push(node.id);
			} else {
				return this.visited;
			}
		} else {
			this.visited.push(node.id);
		}
		return this.visited;
	}
	,__class__: dropecho_ds_algos_PostOrderTraversal
};
var dropecho_dungen_Tile2d = $hx_exports["dungen"]["Tile2d"] = function(x,y,val) {
	this.x = x;
	this.y = y;
	this.val = val;
};
$hxClasses["dropecho.dungen.Tile2d"] = dropecho_dungen_Tile2d;
dropecho_dungen_Tile2d.__name__ = "dropecho.dungen.Tile2d";
dropecho_dungen_Tile2d.prototype = {
	x: null
	,y: null
	,val: null
	,__class__: dropecho_dungen_Tile2d
};
var dropecho_dungen_Map2d = $hx_exports["dungen"]["Map2d"] = function(width,height,initTileData) {
	if(initTileData == null) {
		initTileData = 0;
	}
	this._height = 0;
	this._width = 0;
	this._width = width;
	this._height = height;
	this._mapData = [];
	this.initializeData(initTileData);
};
$hxClasses["dropecho.dungen.Map2d"] = dropecho_dungen_Map2d;
dropecho_dungen_Map2d.__name__ = "dropecho.dungen.Map2d";
dropecho_dungen_Map2d.prototype = {
	_width: null
	,_height: null
	,_mapData: null
	,initializeData: function(initTileData) {
		if(initTileData == -1) {
			return;
		}
		var length = this._height * this._width;
		var _g = 0;
		var _g1 = length;
		while(_g < _g1) {
			var i = _g++;
			this._mapData[i] = initTileData;
		}
	}
	,XYtoIndex: function(x,y) {
		return this._width * y + x;
	}
	,IndexToXY: function(index) {
		var x = index % this._width | 0;
		var y = index / this._width | 0;
		return new dropecho_dungen_Tile2d(x,y);
	}
	,set: function(x,y,data) {
		var index = this._width * y + x;
		this._mapData[index] = data;
	}
	,get: function(x,y) {
		return this._mapData[this._width * y + x];
	}
	,toPrettyString: function(char) {
		if(char == null) {
			char = [" ",".",",","`"];
		}
		var output = "\n MAP2d: \n\n";
		var _g = 0;
		var _g1 = this._height;
		while(_g < _g1) {
			var y = _g++;
			var _g2 = 0;
			var _g3 = this._width;
			while(_g2 < _g3) {
				var x = _g2++;
				output += char[this._mapData[this._width * y + x]];
			}
			output += "\n";
		}
		return output;
	}
	,toString: function() {
		var output = "\n MAP2d: \n\n";
		var _g = 0;
		var _g1 = this._height;
		while(_g < _g1) {
			var y = _g++;
			var _g2 = 0;
			var _g3 = this._width;
			while(_g2 < _g3) {
				var x = _g2++;
				var val = this._mapData[this._width * y + x];
				output += val;
			}
			output += "\n";
		}
		return output;
	}
	,__class__: dropecho_dungen_Map2d
};
var dropecho_dungen_Region = $hx_exports["dungen"]["Region"] = function(id) {
	this.tiles = [];
	this.id = id;
	this.tiles = [];
};
$hxClasses["dropecho.dungen.Region"] = dropecho_dungen_Region;
dropecho_dungen_Region.__name__ = "dropecho.dungen.Region";
dropecho_dungen_Region.prototype = {
	id: null
	,tiles: null
	,__class__: dropecho_dungen_Region
};
var dropecho_dungen_RegionMap = $hx_exports["dungen"]["RegionMap"] = function(map,depth,expand) {
	if(expand == null) {
		expand = true;
	}
	if(depth == null) {
		depth = 2;
	}
	this.graph = new dropecho_ds_Graph();
	this.borders = dropecho_interop_AbstractMap._new();
	this.regions = dropecho_interop_AbstractMap._new();
	dropecho_dungen_Map2d.call(this,map._width,map._height,0);
	var regionmap = dropecho_dungen_map_Map2dExtensions.clone(map);
	regionmap = dropecho_dungen_map_extensions_DistanceFill.distanceFill(regionmap,0,false);
	regionmap = dropecho_dungen_map_extensions_RegionManager.findAndTagRegions(regionmap,depth);
	if(expand) {
		regionmap = dropecho_dungen_map_extensions_RegionManager.expandRegions(regionmap,depth + 1);
	} else if(depth > 1) {
		regionmap = dropecho_dungen_map_extensions_RegionManager.expandRegionsByOne(regionmap,depth);
	}
	this.buildRegions(regionmap,depth);
	this.buildBorders(dropecho_dungen_map_extensions_RegionManager.findAndTagBorders(regionmap,1,128));
	this.buildGraph();
};
$hxClasses["dropecho.dungen.RegionMap"] = dropecho_dungen_RegionMap;
dropecho_dungen_RegionMap.__name__ = "dropecho.dungen.RegionMap";
dropecho_dungen_RegionMap.__super__ = dropecho_dungen_Map2d;
dropecho_dungen_RegionMap.prototype = $extend(dropecho_dungen_Map2d.prototype,{
	regions: null
	,borders: null
	,graph: null
	,buildGraph: function() {
		var access = this.regions;
		var _g_access = access;
		var _g_keys = Reflect.fields(access);
		var _g_index = 0;
		while(_g_index < _g_keys.length) {
			var region = _g_access[_g_keys[_g_index++]];
			this.graph.addNode(new dropecho_ds_GraphNode(region,region.id));
		}
		var access = this.borders;
		var _g1_access = access;
		var _g1_keys = Reflect.fields(access);
		var _g1_index = 0;
		while(_g1_index < _g1_keys.length) {
			var border = _g1_access[_g1_keys[_g1_index++]];
			var borderRegions = [];
			var _g = 0;
			var _g1 = border.tiles;
			while(_g < _g1.length) {
				var tile = _g1[_g];
				++_g;
				var neighbors = dropecho_dungen_map_extensions_Neighbors.getNeighbors(this,tile.x,tile.y);
				var _g2 = 0;
				while(_g2 < neighbors.length) {
					var n = neighbors[_g2];
					++_g2;
					if(Object.prototype.hasOwnProperty.call(this.regions,Std.string(n.val))) {
						var region = this.regions[Std.string(n.val)];
						if(!Lambda.has(borderRegions,region)) {
							borderRegions.push(region);
						}
					}
				}
			}
			var _g3 = 0;
			while(_g3 < borderRegions.length) {
				var region1 = borderRegions[_g3];
				++_g3;
				var _g4 = 0;
				while(_g4 < borderRegions.length) {
					var region2 = borderRegions[_g4];
					++_g4;
					if(region1.id == region2.id) {
						continue;
					}
					this.graph.addUniEdge(region1.id,region2.id,border);
				}
			}
		}
	}
	,buildRegions: function(regionmap,depth) {
		if(depth == null) {
			depth = 2;
		}
		var _g = 0;
		var _g1 = regionmap._mapData.length;
		while(_g < _g1) {
			var tile = _g++;
			var regionTileId = regionmap._mapData[tile];
			var isRegion = regionTileId > depth;
			this._mapData[tile] = regionmap._mapData[tile];
			if(isRegion) {
				var region;
				if(Object.prototype.hasOwnProperty.call(this.regions,regionTileId == null ? "null" : "" + regionTileId) == false) {
					region = new dropecho_dungen_Region(regionTileId);
					this.regions[Std.string(region.id)] = region;
				} else {
					region = this.regions[regionTileId == null ? "null" : "" + regionTileId];
				}
				region.tiles.push(regionmap.IndexToXY(tile));
			}
		}
	}
	,buildBorders: function(bordermap) {
		var _g = 0;
		var _g1 = bordermap._mapData.length;
		while(_g < _g1) {
			var tile = _g++;
			var borderTile = bordermap._mapData[tile];
			var isBorder = borderTile != 0;
			this._mapData[tile] = isBorder ? borderTile : this._mapData[tile];
			if(isBorder) {
				var border;
				if(Object.prototype.hasOwnProperty.call(this.borders,borderTile == null ? "null" : "" + borderTile) == false) {
					border = new dropecho_dungen_Region(borderTile);
					this.borders[Std.string(border.id)] = border;
				} else {
					border = this.borders[borderTile == null ? "null" : "" + borderTile];
				}
				var tileData = bordermap.IndexToXY(tile);
				border.tiles.push(tileData);
			}
		}
	}
	,toStringSingleRegion: function(regionId) {
		var chars = [];
		var _g = 0;
		while(_g < 255) {
			var i = _g++;
			chars[i] = i - 1 == regionId ? "." : " ";
		}
		return this.toPrettyString(chars);
	}
	,toRegionBorderIdString: function() {
		var output = "\n MAP2d: \n\n";
		var _g = 0;
		var _g1 = this._height;
		while(_g < _g1) {
			var y = _g++;
			var _g2 = 0;
			var _g3 = this._width;
			while(_g2 < _g3) {
				var x = _g2++;
				var val = this._mapData[this._width * y + x];
				if(Object.prototype.hasOwnProperty.call(this.regions,val == null ? "null" : "" + val)) {
					var tiles = this.regions[val == null ? "null" : "" + val].tiles;
					var _g4 = 0;
					var _g5 = tiles.length;
					while(_g4 < _g5) {
						var i = _g4++;
						if(tiles[i].x == x && tiles[i].y == y) {
							output += val;
						}
					}
				} else if(Object.prototype.hasOwnProperty.call(this.borders,val == null ? "null" : "" + val)) {
					var _g6 = 0;
					var _g7 = this.borders[val == null ? "null" : "" + val].tiles;
					while(_g6 < _g7.length) {
						var tile = _g7[_g6];
						++_g6;
						if(tile.x == x && tile.y == y) {
							output += val - 127;
						}
					}
				} else {
					output += val == 0 ? " " : val;
				}
			}
			output += "\n";
		}
		return output;
	}
	,toRegionBorderString: function() {
		var output = "\n MAP2d: \n\n";
		var _g = 0;
		var _g1 = this._height;
		while(_g < _g1) {
			var y = _g++;
			var _g2 = 0;
			var _g3 = this._width;
			while(_g2 < _g3) {
				var x = _g2++;
				var isBorder = false;
				var isRegion = false;
				var val = this._mapData[this._width * y + x];
				if(Object.prototype.hasOwnProperty.call(this.regions,val == null ? "null" : "" + val)) {
					var tiles = this.regions[val == null ? "null" : "" + val].tiles;
					var _g4 = 0;
					var _g5 = tiles.length;
					while(_g4 < _g5) {
						var i = _g4++;
						if(tiles[i].x == x && tiles[i].y == y) {
							isRegion = true;
						}
					}
				}
				if(Object.prototype.hasOwnProperty.call(this.borders,val == null ? "null" : "" + val)) {
					var _g6 = 0;
					var _g7 = this.borders[val == null ? "null" : "" + val].tiles;
					while(_g6 < _g7.length) {
						var tile = _g7[_g6];
						++_g6;
						if(tile.x == x && tile.y == y) {
							isBorder = true;
						}
					}
				}
				output += isBorder ? "b" : isRegion ? "r" : " ";
			}
			output += "\n";
		}
		return output;
	}
	,__class__: dropecho_dungen_RegionMap
});
var dropecho_dungen_bsp_BSPData = $hx_exports["dungen"]["BSPData"] = function(ops) {
	this.y = 0;
	this.x = 0;
	this.height = 0;
	this.width = 0;
	dropecho_interop_Extender.extendThis(this,ops);
};
$hxClasses["dropecho.dungen.bsp.BSPData"] = dropecho_dungen_bsp_BSPData;
dropecho_dungen_bsp_BSPData.__name__ = "dropecho.dungen.bsp.BSPData";
dropecho_dungen_bsp_BSPData.prototype = {
	width: null
	,height: null
	,x: null
	,y: null
	,__class__: dropecho_dungen_bsp_BSPData
};
var dropecho_dungen_bsp_BSPGeneratorConfig = $hx_exports["dungen"]["BSPGeneratorConfig"] = function() {
	this.seed = "0";
	this.y = 0;
	this.x = 0;
	this.ratio = .45;
	this.depth = 10;
	this.minWidth = 10;
	this.minHeight = 10;
	this.height = 60;
	this.width = 120;
};
$hxClasses["dropecho.dungen.bsp.BSPGeneratorConfig"] = dropecho_dungen_bsp_BSPGeneratorConfig;
dropecho_dungen_bsp_BSPGeneratorConfig.__name__ = "dropecho.dungen.bsp.BSPGeneratorConfig";
dropecho_dungen_bsp_BSPGeneratorConfig.prototype = {
	width: null
	,height: null
	,minHeight: null
	,minWidth: null
	,depth: null
	,ratio: null
	,x: null
	,y: null
	,seed: null
	,__class__: dropecho_dungen_bsp_BSPGeneratorConfig
};
var dropecho_dungen_bsp_Generator = $hx_exports["dungen"]["BSPGenerator"] = function(ops) {
	this.random = new seedyrng_Random();
	dropecho_dungen_bsp_BSPGeneratorConfig.call(this);
	dropecho_interop_Extender.extendThis(this,ops);
	this.random.setStringSeed(this.seed);
};
$hxClasses["dropecho.dungen.bsp.Generator"] = dropecho_dungen_bsp_Generator;
dropecho_dungen_bsp_Generator.__name__ = "dropecho.dungen.bsp.Generator";
dropecho_dungen_bsp_Generator.__super__ = dropecho_dungen_bsp_BSPGeneratorConfig;
dropecho_dungen_bsp_Generator.prototype = $extend(dropecho_dungen_bsp_BSPGeneratorConfig.prototype,{
	random: null
	,generate: function() {
		this.random.setStringSeed(this.seed);
		var rootData = new dropecho_dungen_bsp_BSPData({ height : this.height, width : this.width, x : this.x, y : this.y});
		var tree = new dropecho_ds_BSPTree(rootData);
		this.buildTree(tree.getRoot());
		return tree;
	}
	,buildTree: function(node,level) {
		if(level == null) {
			level = 0;
		}
		if(node == null || level >= this.depth) {
			return;
		}
		this.makeSplit(node);
		this.buildTree(node.left,level + 1);
		this.buildTree(node.right,level + 1);
	}
	,makeSplit: function(node) {
		var val = node.value;
		var lData;
		var rData;
		if(val.width < this.minWidth * 2 && val.height < this.minHeight * 2) {
			return;
		}
		var splitAt = 0;
		var splitHeight = this.random.random() > 0.5;
		if(val.width >= val.height * this.ratio) {
			splitHeight = false;
		} else if(val.height >= val.width * this.ratio) {
			splitHeight = true;
		} else {
			return;
		}
		if(splitHeight) {
			splitAt = this.random.randomInt(0,val.height - this.minHeight * 2) + this.minHeight;
			var rHeight = val.height - splitAt;
			lData = new dropecho_dungen_bsp_BSPData({ height : splitAt, width : val.width, x : val.x, y : val.y});
			rData = new dropecho_dungen_bsp_BSPData({ height : rHeight, width : val.width, x : val.x, y : val.y + splitAt});
		} else {
			splitAt = this.random.randomInt(0,val.width - this.minWidth * 2) + this.minWidth;
			var rWidth = val.width - splitAt;
			lData = new dropecho_dungen_bsp_BSPData({ height : val.height, width : splitAt, x : val.x, y : val.y});
			rData = new dropecho_dungen_bsp_BSPData({ height : val.height, width : rWidth, x : val.x + splitAt, y : val.y});
		}
		node.setLeft(new dropecho_ds_BSPNode(lData));
		node.setRight(new dropecho_ds_BSPNode(rData));
	}
	,__class__: dropecho_dungen_bsp_Generator
});
var dropecho_dungen_export_TiledExporter = $hx_exports["dungen"]["TiledExporter"] = function() { };
$hxClasses["dropecho.dungen.export.TiledExporter"] = dropecho_dungen_export_TiledExporter;
dropecho_dungen_export_TiledExporter.__name__ = "dropecho.dungen.export.TiledExporter";
dropecho_dungen_export_TiledExporter.export = function(map) {
	return "0";
};
var dropecho_dungen_generators_CA_$PARAMS = $hx_exports["dungen"]["CA_PARAMS"] = function() {
	this.useOtherType = false;
	this.seed = "0";
	this.start_fill_percent = 65;
	this.tile_wall = 0;
	this.tile_floor = 1;
	this.width = 64;
	this.height = 64;
	this.steps = [];
	this.steps = [{ reps : 4, r1_cutoff : 5, r2_cutoff : 2, invert : true},{ reps : 3, r1_cutoff : 5, r2_cutoff : 0, invert : true}];
};
$hxClasses["dropecho.dungen.generators.CA_PARAMS"] = dropecho_dungen_generators_CA_$PARAMS;
dropecho_dungen_generators_CA_$PARAMS.__name__ = "dropecho.dungen.generators.CA_PARAMS";
dropecho_dungen_generators_CA_$PARAMS.prototype = {
	steps: null
	,height: null
	,width: null
	,tile_floor: null
	,tile_wall: null
	,start_fill_percent: null
	,seed: null
	,useOtherType: null
	,__class__: dropecho_dungen_generators_CA_$PARAMS
};
var dropecho_dungen_generators_CAGenerator = $hx_exports["dungen"]["CAGenerator"] = function() { };
$hxClasses["dropecho.dungen.generators.CAGenerator"] = dropecho_dungen_generators_CAGenerator;
dropecho_dungen_generators_CAGenerator.__name__ = "dropecho.dungen.generators.CAGenerator";
dropecho_dungen_generators_CAGenerator.generate = function(opts) {
	var params = dropecho_interop_Extender.defaults(new dropecho_dungen_generators_CA_$PARAMS(),opts);
	var map = dropecho_dungen_generators_RandomGenerator.generate(params);
	var _g = 0;
	var _g1 = params.steps;
	while(_g < _g1.length) {
		var step = _g1[_g];
		++_g;
		var _g2 = 0;
		var _g3 = step.reps;
		while(_g2 < _g3) {
			var _ = _g2++;
			dropecho_dungen_generators_CAGenerator.buildFromCA(map,params,step);
		}
	}
	return map;
};
dropecho_dungen_generators_CAGenerator.buildFromCA = function(map,params,step) {
	var temp = new haxe_ds_IntMap();
	var alive_tile_type = step.invert ? params.tile_floor : params.tile_wall;
	var dead_tile_type = step.invert ? params.tile_wall : params.tile_floor;
	var _g = 0;
	var _g1 = params.width;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = params.height;
		while(_g2 < _g3) {
			var y = _g2++;
			var nCount = dropecho_dungen_map_extensions_Neighbors.getNeighborCount(map,x,y,alive_tile_type);
			var nCount2 = dropecho_dungen_map_extensions_Neighbors.getNeighborCount(map,x,y,alive_tile_type,2);
			var pos = map._width * y + x;
			if(!params.useOtherType) {
				var is_alive = map._mapData[map._width * y + x] == alive_tile_type;
				if(!is_alive && nCount >= step.r1_cutoff) {
					is_alive = true;
				} else if(is_alive && nCount >= step.r2_cutoff) {
					is_alive = true;
				} else {
					is_alive = false;
				}
				temp.h[pos] = is_alive ? alive_tile_type : dead_tile_type;
			} else if(nCount >= step.r1_cutoff || nCount2 <= step.r2_cutoff) {
				temp.h[pos] = dead_tile_type;
			} else {
				temp.h[pos] = alive_tile_type;
			}
		}
	}
	var i = temp.keys();
	while(i.hasNext()) {
		var i1 = i.next();
		var pos = map.IndexToXY(i1);
		var index = map._width * pos.y + pos.x;
		map._mapData[index] = temp.h[i1];
	}
};
var dropecho_dungen_generators_ConvChain = $hx_exports["dungen"]["ConvChain"] = function(sample) {
	this.seed = "0";
	this.sample = sample;
	this.cachedN = -1;
	this.cachedWeights = null;
	this.rng = new seedyrng_Random();
	this.rng.setStringSeed(this.seed);
};
$hxClasses["dropecho.dungen.generators.ConvChain"] = dropecho_dungen_generators_ConvChain;
dropecho_dungen_generators_ConvChain.__name__ = "dropecho.dungen.generators.ConvChain";
dropecho_dungen_generators_ConvChain.prototype = {
	sample: null
	,cachedN: null
	,cachedWeights: null
	,rng: null
	,seed: null
	,processWeights: function(sample,n) {
		var size = Math.pow(2,n * n) | 0;
		var _g = [];
		var _g1 = 0;
		var _g2 = size;
		while(_g1 < _g2) {
			var _ = _g1++;
			_g.push(0.0);
		}
		var weights = _g;
		var _g = 0;
		var _g1 = sample._height;
		while(_g < _g1) {
			var x = _g++;
			var _g2 = 0;
			var _g3 = sample._width;
			while(_g2 < _g3) {
				var y = _g2++;
				var rect = dropecho_dungen_map_extensions_Utils.getRect(sample,{ x : x, y : y, width : n, height : n},true);
				var p = dropecho_dungen_map_Pattern.init(n,rect);
				var _g4 = 0;
				var _g5 = p.hashes.length;
				while(_g4 < _g5) {
					var h = _g4++;
					weights[p.hashes[h]] += 1;
				}
			}
		}
		var _g = 0;
		var _g1 = weights.length;
		while(_g < _g1) {
			var k = _g++;
			weights[k] = weights[k] <= 0 ? 0.1 : weights[k];
		}
		return weights;
	}
	,getWeights: function(n) {
		if(this.cachedN != n) {
			this.cachedN = n;
			this.cachedWeights = this.processWeights(this.sample,n);
		}
		return this.cachedWeights;
	}
	,generateBaseField: function(width,height) {
		return dropecho_dungen_generators_RandomGenerator.generate({ height : height, width : width, seed : this.seed});
	}
	,applyChanges: function(field,weights,n,temperature,changes) {
		var r;
		var q;
		var x;
		var y;
		var ind;
		var difference;
		var _g = 0;
		var _g1 = changes;
		while(_g < _g1) {
			var _ = _g++;
			q = 1.0;
			r = this.rng.randomInt(0,field._mapData.length);
			x = r % field._width | 0;
			y = r / field._width | 0;
			var _g2 = y - n + 1;
			var _g3 = y + n;
			while(_g2 < _g3) {
				var sy = _g2++;
				var _g4 = x - n + 1;
				var _g5 = x + n;
				while(_g4 < _g5) {
					var sx = _g4++;
					ind = 0;
					difference = 0;
					var _g6 = 0;
					var _g7 = n;
					while(_g6 < _g7) {
						var dy = _g6++;
						var _g8 = 0;
						var _g9 = n;
						while(_g8 < _g9) {
							var dx = _g8++;
							var power = 1 << dy * n + dx;
							var X = sx + dx;
							var Y = sy + dy;
							X = Math.abs(X % field._width) | 0;
							Y = Math.abs(Y % field._height) | 0;
							var value = field._mapData[field._width * Y + X];
							ind += value != 0 ? power : 0;
							if(X == x && Y == y) {
								difference = value != 0 ? power : -power;
							}
						}
					}
					var a = weights[ind - difference];
					var b = weights[ind];
					q *= a / b;
				}
			}
			if(q >= 1) {
				var index = field._width * y + x;
				field._mapData[index] = field._mapData[field._width * y + x] != 1 ? 1 : 0;
			} else {
				if(temperature != 1) {
					q = Math.pow(q,1.0 / temperature);
				}
				if(q > this.rng.random()) {
					var index1 = field._width * y + x;
					field._mapData[index1] = field._mapData[field._width * y + x] != 1 ? 1 : 0;
				}
			}
		}
	}
	,generate: function(width,height,n,temperature,iterations) {
		var changesPerIterations = width * height;
		var field = this.generateBaseField(width,height);
		var weights = this.getWeights(n);
		var _g = 0;
		var _g1 = iterations;
		while(_g < _g1) {
			var _ = _g++;
			this.applyChanges(field,weights,n,temperature,changesPerIterations);
		}
		return field;
	}
	,__class__: dropecho_dungen_generators_ConvChain
};
var dropecho_dungen_generators_FloorPlanGenerator = $hx_exports["dungen"]["FloorPlanGenerator"] = function() { };
$hxClasses["dropecho.dungen.generators.FloorPlanGenerator"] = dropecho_dungen_generators_FloorPlanGenerator;
dropecho_dungen_generators_FloorPlanGenerator.__name__ = "dropecho.dungen.generators.FloorPlanGenerator";
dropecho_dungen_generators_FloorPlanGenerator.generate = function(params) {
	var width = params.width;
	var height = params.height;
	var tile_floor = params.tile_floor;
	var tile_wall = params.tile_wall;
	var map = new dropecho_dungen_Map2d(width,height);
	var rooms = [];
	rooms.push({ width : 20, height : 20, x : -999999, y : -999999});
	rooms.push({ width : 20, height : 20, x : -999999, y : -999999});
	rooms.push({ width : 20, height : 30, x : -999999, y : -999999});
	rooms.push({ width : 30, height : 20, x : -999999, y : -999999});
	dropecho_dungen_generators_FloorPlanGenerator.arrangeRooms(map,rooms);
	return map;
};
dropecho_dungen_generators_FloorPlanGenerator.scaleFloorPlan = function(map,rooms) {
};
dropecho_dungen_generators_FloorPlanGenerator.arrangeRooms = function(map,rooms) {
	var random = new seedyrng_Random();
	var mapMidX = map._width / 2;
	var mapMidY = map._height / 2;
	var randomRooms = rooms.slice();
	random.shuffle(randomRooms);
	var _g = 0;
	while(_g < randomRooms.length) {
		var r = randomRooms[_g];
		++_g;
		r.x = 500;
		r.y = 500;
		var isRight = r.x > mapMidX;
		var isAbove = r.y > mapMidY;
	}
};
var dropecho_dungen_generators_MixedGenerator = $hx_exports["dungen"]["MixedGenerator"] = function() { };
$hxClasses["dropecho.dungen.generators.MixedGenerator"] = dropecho_dungen_generators_MixedGenerator;
dropecho_dungen_generators_MixedGenerator.__name__ = "dropecho.dungen.generators.MixedGenerator";
dropecho_dungen_generators_MixedGenerator.buildRooms = function(tree,opts) {
	var random = new seedyrng_Random();
	var params = dropecho_interop_Extender.defaults({ tile_wall : 0, tile_floor : 1, cave_percent : 20, seed : "0"},opts);
	random.setStringSeed(params.seed);
	var rootvalue = tree.root.value;
	var map = new dropecho_dungen_Map2d(rootvalue.width,rootvalue.height,params.tile_wall);
	var makeRooms = function(node) {
		if(node.hasLeft() || node.hasRight()) {
			return true;
		}
		var roomStartX = node.value.x + 1;
		var roomStartY = node.value.y + 1;
		var roomEndX = node.value.x + node.value.width - 1;
		var roomEndY = node.value.y + node.value.height - 1;
		var _g = roomStartX;
		var _g1 = roomEndX;
		while(_g < _g1) {
			var x = _g++;
			var _g2 = roomStartY;
			var _g3 = roomEndY;
			while(_g2 < _g3) {
				var y = _g2++;
				var index = map._width * y + x;
				map._mapData[index] = params.tile_floor;
			}
		}
		return true;
	};
	var makeCaveFromCA = function(node) {
		if((node.hasLeft() || node.hasRight()) && (node.right.hasRight() || node.right.hasLeft() || node.left.hasRight() || node.left.hasLeft())) {
			return true;
		}
		var roomStartX = node.value.x + 1;
		var roomStartY = node.value.y + 1;
		var cave = dropecho_dungen_generators_CAGenerator.generate({ height : node.value.height, width : node.value.width});
		var _g = 0;
		var _g1 = cave._width;
		while(_g < _g1) {
			var x = _g++;
			var _g2 = 0;
			var _g3 = cave._height;
			while(_g2 < _g3) {
				var y = _g2++;
				var index = map._width * (y + roomStartY) + (x + roomStartX);
				map._mapData[index] = cave._mapData[cave._width * y + x];
			}
		}
		return true;
	};
	var makeCorridors = function(node) {
		if(!node.hasLeft() && !node.hasRight()) {
			return true;
		}
		var leftXcenter = node.left.value.x + node.left.value.width / 2 | 0;
		var leftYcenter = node.left.value.y + node.left.value.height / 2 | 0;
		var rightXcenter = node.right.value.x + node.right.value.width / 2 | 0;
		var rightYcenter = node.right.value.y + node.right.value.height / 2 | 0;
		var startX = leftXcenter <= rightXcenter ? leftXcenter : rightXcenter;
		var endX = leftXcenter >= rightXcenter ? leftXcenter : rightXcenter;
		var startY = leftYcenter <= rightYcenter ? leftYcenter : rightYcenter;
		var endY = leftYcenter >= rightYcenter ? leftYcenter : rightYcenter;
		var _g = startX;
		var _g1 = endX;
		while(_g < _g1) {
			var x = _g++;
			var index = map._width * startY + x;
			map._mapData[index] = params.tile_floor;
		}
		var _g = startY;
		var _g1 = endY;
		while(_g < _g1) {
			var y = _g++;
			var index = map._width * y + startX;
			map._mapData[index] = params.tile_floor;
		}
		return true;
	};
	var chooseRoomOrCave = function(node) {
		if(random.random() * 100 > params.cave_percent) {
			return makeRooms(node);
		} else {
			return makeCaveFromCA(node);
		}
	};
	var closeEdges = function(node) {
		if(!node.isRoot()) {
			return true;
		}
		var _g = 0;
		var _g1 = node.value.width;
		while(_g < _g1) {
			var x = _g++;
			var index = map._width * 0 + x;
			map._mapData[index] = params.tile_wall;
			var index1 = map._width * node.value.height + x;
			map._mapData[index1] = params.tile_wall;
		}
		var _g = 0;
		var _g1 = node.value.height;
		while(_g < _g1) {
			var y = _g++;
			var index = map._width * y;
			map._mapData[index] = params.tile_wall;
			var index1 = map._width * y + node.value.width;
			map._mapData[index1] = params.tile_wall;
		}
		return false;
	};
	var povisitor = new dropecho_ds_algos_PostOrderTraversal();
	var invisitor = new dropecho_ds_algos_InOrderTraversal();
	povisitor.run(tree.root,chooseRoomOrCave);
	povisitor.visited.length = 0;
	invisitor.run(tree.root,closeEdges);
	povisitor.run(tree.root,makeCorridors);
	return map;
};
var dropecho_dungen_generators_RandomParams = function() {
	this.seed = "0";
	this.start_fill_percent = 50;
	this.tile_wall = 0;
	this.tile_floor = 1;
	this.width = 64;
	this.height = 64;
};
$hxClasses["dropecho.dungen.generators.RandomParams"] = dropecho_dungen_generators_RandomParams;
dropecho_dungen_generators_RandomParams.__name__ = "dropecho.dungen.generators.RandomParams";
dropecho_dungen_generators_RandomParams.prototype = {
	height: null
	,width: null
	,tile_floor: null
	,tile_wall: null
	,start_fill_percent: null
	,seed: null
	,__class__: dropecho_dungen_generators_RandomParams
};
var dropecho_dungen_generators_RandomGenerator = $hx_exports["dungen"]["RandomGenerator"] = function() { };
$hxClasses["dropecho.dungen.generators.RandomGenerator"] = dropecho_dungen_generators_RandomGenerator;
dropecho_dungen_generators_RandomGenerator.__name__ = "dropecho.dungen.generators.RandomGenerator";
dropecho_dungen_generators_RandomGenerator.generate = function(opts) {
	var params = dropecho_interop_Extender.defaults(new dropecho_dungen_generators_RandomParams(),opts);
	var random = new seedyrng_Random();
	random.setStringSeed(params.seed);
	var map = new dropecho_dungen_Map2d(params.width,params.height,params.tile_wall);
	var _g = 0;
	var _g1 = params.width * params.height;
	while(_g < _g1) {
		var i = _g++;
		map._mapData[i] = random.random() * 100 > params.start_fill_percent ? params.tile_floor : params.tile_wall;
	}
	return map;
};
var dropecho_dungen_generators_RoomParams = function() {
	this.padding = 0;
	this.tileWall = 0;
	this.tileFloor = 1;
	this.tileCorridor = 1;
};
$hxClasses["dropecho.dungen.generators.RoomParams"] = dropecho_dungen_generators_RoomParams;
dropecho_dungen_generators_RoomParams.__name__ = "dropecho.dungen.generators.RoomParams";
dropecho_dungen_generators_RoomParams.prototype = {
	tileCorridor: null
	,tileFloor: null
	,tileWall: null
	,padding: null
	,__class__: dropecho_dungen_generators_RoomParams
};
var dropecho_dungen_generators_RoomGenerator = $hx_exports["dungen"]["RoomGenerator"] = function() { };
$hxClasses["dropecho.dungen.generators.RoomGenerator"] = dropecho_dungen_generators_RoomGenerator;
dropecho_dungen_generators_RoomGenerator.__name__ = "dropecho.dungen.generators.RoomGenerator";
dropecho_dungen_generators_RoomGenerator.buildRooms = function(tree,opts) {
	var params = dropecho_interop_Extender.defaults(new dropecho_dungen_generators_RoomParams(),opts);
	var rootvalue = tree.getRoot().value;
	var map = new dropecho_dungen_Map2d(rootvalue.width,rootvalue.height,params.tileWall);
	var makeRoom = function(node) {
		if(node.hasLeft() || node.hasRight()) {
			return true;
		}
		var lPad = params.padding / 2 | 0;
		var rPad = (params.padding / 2 | 0) + params.padding % 2;
		var roomStartX = node.value.x + 1 + lPad;
		var roomStartY = node.value.y + 1 + lPad;
		var roomEndX = node.value.x + node.value.width - 1 - rPad;
		var roomEndY = node.value.y + node.value.height - 1 - rPad;
		if(roomStartX != 1) {
			--roomStartX;
		}
		if(roomStartY != 1) {
			--roomStartY;
		}
		var _g = roomStartX;
		var _g1 = roomEndX;
		while(_g < _g1) {
			var x = _g++;
			var _g2 = roomStartY;
			var _g3 = roomEndY;
			while(_g2 < _g3) {
				var y = _g2++;
				var index = map._width * y + x;
				map._mapData[index] = params.tileFloor;
			}
		}
		return true;
	};
	var makeCorridors = function(node) {
		if(!node.hasLeft() && !node.hasRight()) {
			return true;
		}
		var leftXcenter = node.left.value.x + node.left.value.width / 2 | 0;
		var leftYcenter = node.left.value.y + node.left.value.height / 2 | 0;
		var rightXcenter = node.right.value.x + node.right.value.width / 2 | 0;
		var rightYcenter = node.right.value.y + node.right.value.height / 2 | 0;
		var startX = leftXcenter <= rightXcenter ? leftXcenter : rightXcenter;
		var endX = leftXcenter >= rightXcenter ? leftXcenter : rightXcenter;
		var startY = leftYcenter <= rightYcenter ? leftYcenter : rightYcenter;
		var endY = leftYcenter >= rightYcenter ? leftYcenter : rightYcenter;
		var _g = startX;
		var _g1 = endX;
		while(_g < _g1) {
			var x = _g++;
			if(map._mapData[map._width * startY + x] != params.tileFloor) {
				var index = map._width * startY + x;
				map._mapData[index] = params.tileCorridor;
			}
		}
		var _g = startY;
		var _g1 = endY;
		while(_g < _g1) {
			var y = _g++;
			if(map._mapData[map._width * y + startX] != params.tileFloor) {
				var index = map._width * y + startX;
				map._mapData[index] = params.tileCorridor;
			}
		}
		return true;
	};
	var visitor = new dropecho_ds_algos_PostOrderTraversal();
	visitor.run(tree.root,makeRoom);
	visitor.visited.length = 0;
	visitor.run(tree.root,makeCorridors);
	return map;
};
var dropecho_dungen_generators_TunnelerGenerator = $hx_exports["dungen"]["TunnelerGenerator"] = function() { };
$hxClasses["dropecho.dungen.generators.TunnelerGenerator"] = dropecho_dungen_generators_TunnelerGenerator;
dropecho_dungen_generators_TunnelerGenerator.__name__ = "dropecho.dungen.generators.TunnelerGenerator";
dropecho_dungen_generators_TunnelerGenerator.generate = function(params) {
	var height = params.height;
	var width = params.width;
	var tile_floor = params.tile_floor;
	var tile_wall = params.tile_wall;
	var start_fill_percent = params.start_fill_percent;
	var countOfFilled = 0;
	var totalCount = height * width;
	var map = new dropecho_dungen_Map2d(width,height,tile_wall);
	var walkerPos_x = width / 2 | 0;
	var walkerPos_y = height / 2 | 0;
	var index = map._width * walkerPos_y + walkerPos_x;
	map._mapData[index] = 0;
	return map;
};
dropecho_dungen_generators_TunnelerGenerator.getEntrancePosition = function(map) {
	var random = new seedyrng_Random();
	var top = random.randomInt(0,1) == 1;
	var right = random.randomInt(0,1) == 1;
	return null;
};
var dropecho_dungen_generators__$TunnelerGenerator_Tunneler = function(map,position,width,direction,lifeSpan) {
	if(lifeSpan == null) {
		lifeSpan = 5;
	}
	if(direction == null) {
		direction = 2;
	}
	if(width == null) {
		width = 1;
	}
	this.map = map;
	this.position = position;
	this.width = width;
	this.direction = direction;
	this.lifeSpan = lifeSpan;
};
$hxClasses["dropecho.dungen.generators._TunnelerGenerator.Tunneler"] = dropecho_dungen_generators__$TunnelerGenerator_Tunneler;
dropecho_dungen_generators__$TunnelerGenerator_Tunneler.__name__ = "dropecho.dungen.generators._TunnelerGenerator.Tunneler";
dropecho_dungen_generators__$TunnelerGenerator_Tunneler.prototype = {
	map: null
	,position: null
	,width: null
	,direction: null
	,lifeSpan: null
	,run: function() {
		var ticks = 0;
		while(ticks < this.lifeSpan) {
		}
	}
	,__class__: dropecho_dungen_generators__$TunnelerGenerator_Tunneler
};
var dropecho_dungen_generators_WALK_$PARAMS_$DEF = function() {
	this.seed = "0";
	this.start_fill_percent = 50;
	this.tile_wall = 0;
	this.tile_floor = 1;
	this.width = 64;
	this.height = 64;
};
$hxClasses["dropecho.dungen.generators.WALK_PARAMS_DEF"] = dropecho_dungen_generators_WALK_$PARAMS_$DEF;
dropecho_dungen_generators_WALK_$PARAMS_$DEF.__name__ = "dropecho.dungen.generators.WALK_PARAMS_DEF";
dropecho_dungen_generators_WALK_$PARAMS_$DEF.prototype = {
	height: null
	,width: null
	,tile_floor: null
	,tile_wall: null
	,start_fill_percent: null
	,seed: null
	,__class__: dropecho_dungen_generators_WALK_$PARAMS_$DEF
};
var dropecho_dungen_generators_WalkGenerator = $hx_exports["dungen"]["WalkGenerator"] = function() { };
$hxClasses["dropecho.dungen.generators.WalkGenerator"] = dropecho_dungen_generators_WalkGenerator;
dropecho_dungen_generators_WalkGenerator.__name__ = "dropecho.dungen.generators.WalkGenerator";
dropecho_dungen_generators_WalkGenerator.generate = function(opts) {
	var params = dropecho_interop_Extender.defaults(new dropecho_dungen_generators_WALK_$PARAMS_$DEF(),opts);
	var random = new seedyrng_Random();
	random.setStringSeed(params.seed);
	var countOfFilled = 0;
	var totalCount = params.height * params.width;
	var map = new dropecho_dungen_Map2d(params.width,params.height,params.tile_wall);
	var walkerPos_x = params.width / 2 | 0;
	var walkerPos_y = params.height / 2 | 0;
	var index = map._width * walkerPos_y + walkerPos_x;
	map._mapData[index] = 0;
	var counter = 0;
	var direction = random.randomInt(0,3);
	while(countOfFilled < totalCount * (params.start_fill_percent / 100)) {
		direction = random.randomInt(0,3);
		if(map._mapData[map._width * walkerPos_y + walkerPos_x] != params.tile_floor) {
			var index = map._width * walkerPos_y + walkerPos_x;
			map._mapData[index] = params.tile_floor;
			++countOfFilled;
		}
		walkerPos_y += direction == 0 ? -1 : 0;
		walkerPos_y += direction == 2 ? 1 : 0;
		walkerPos_x += direction == 1 ? -1 : 0;
		walkerPos_x += direction == 3 ? 1 : 0;
		if(walkerPos_x < 0 || walkerPos_x > params.width - 1) {
			walkerPos_x = params.width / 2 | 0;
			walkerPos_y = params.height / 2 | 0;
		}
		if(walkerPos_y < 0 || walkerPos_y > params.height - 1) {
			walkerPos_x = params.width / 2 | 0;
			walkerPos_y = params.height / 2 | 0;
		}
		if(counter >= 500000) {
			break;
		}
		++counter;
	}
	return map;
};
var dropecho_dungen_map_Map2dExtensions = $hx_exports["dungen"]["Map2dExtensions"] = function() { };
$hxClasses["dropecho.dungen.map.Map2dExtensions"] = dropecho_dungen_map_Map2dExtensions;
dropecho_dungen_map_Map2dExtensions.__name__ = "dropecho.dungen.map.Map2dExtensions";
dropecho_dungen_map_Map2dExtensions.setAllEdgesTo = function(map,tileType) {
	if(tileType == null) {
		tileType = 0;
	}
	var _g = 0;
	var _g1 = map._width;
	while(_g < _g1) {
		var x = _g++;
		var index = map._width * 0 + x;
		map._mapData[index] = tileType;
		var index1 = map._width * (map._height - 1) + x;
		map._mapData[index1] = tileType;
	}
	var _g = 0;
	var _g1 = map._height;
	while(_g < _g1) {
		var y = _g++;
		var index = map._width * y;
		map._mapData[index] = tileType;
		var index1 = map._width * y + (map._width - 1);
		map._mapData[index1] = tileType;
	}
};
dropecho_dungen_map_Map2dExtensions.clone = function(map,mapData) {
	var clone = new dropecho_dungen_Map2d(map._width,map._height);
	if(mapData != null) {
		clone._mapData = mapData;
	} else {
		var _g = 0;
		var _g1 = map._mapData.length;
		while(_g < _g1) {
			var i = _g++;
			clone._mapData[i] = map._mapData[i];
		}
	}
	return clone;
};
var dropecho_dungen_map_Pattern = $hx_exports["dungen"]["Pattern"] = function(size,initTileData) {
	if(initTileData == null) {
		initTileData = 0;
	}
	this.hashes = [];
	this.patterns = [];
	dropecho_dungen_Map2d.call(this,size,size,initTileData);
};
$hxClasses["dropecho.dungen.map.Pattern"] = dropecho_dungen_map_Pattern;
dropecho_dungen_map_Pattern.__name__ = "dropecho.dungen.map.Pattern";
dropecho_dungen_map_Pattern.init = function(size,pattern,symmetry) {
	if(symmetry == null) {
		symmetry = 255;
	}
	var p = new dropecho_dungen_map_Pattern(size,0);
	p._mapData = pattern;
	p.buildVariations(symmetry);
	return p;
};
dropecho_dungen_map_Pattern.__super__ = dropecho_dungen_Map2d;
dropecho_dungen_map_Pattern.prototype = $extend(dropecho_dungen_Map2d.prototype,{
	patterns: null
	,hashes: null
	,indexToMap: function(index) {
		if(index == null) {
			index = 0;
		}
		return dropecho_dungen_map_Map2dExtensions.clone(this,this.patterns[index]);
	}
	,matchesIndex: function(map,x,y,tileToIgnore) {
		if(tileToIgnore == null) {
			tileToIgnore = -1;
		}
		var toMatch = dropecho_dungen_map_extensions_Utils.getRect(map,{ x : x, y : y, width : this._width, height : this._height});
		var match = false;
		var _g = 0;
		var _g1 = this.patterns.length;
		while(_g < _g1) {
			var p = _g++;
			var pattern = this.patterns[p];
			var _g2 = 0;
			var _g3 = pattern.length;
			while(_g2 < _g3) {
				var tile = _g2++;
				match = toMatch[tile] == pattern[tile] || pattern[tile] == tileToIgnore;
				if(!match) {
					break;
				}
			}
			if(match) {
				return p;
			}
		}
		return -1;
	}
	,matches: function(map,x,y) {
		return this.matchesIndex(map,x,y) != -1;
	}
	,buildVariations: function(symmetry) {
		if(symmetry == null) {
			symmetry = 255;
		}
		var n = this._width;
		var variations = [];
		variations[0] = this._mapData;
		var p = variations[0];
		var _g = [];
		var _g1 = 0;
		var _g2 = n;
		while(_g1 < _g2) {
			var y = _g1++;
			var _g3 = 0;
			var _g4 = n;
			while(_g3 < _g4) {
				var x = _g3++;
				_g.push(p[n - 1 - y + x * n]);
			}
		}
		variations[1] = _g;
		var p = variations[1];
		var _g = [];
		var _g1 = 0;
		var _g2 = n;
		while(_g1 < _g2) {
			var y = _g1++;
			var _g3 = 0;
			var _g4 = n;
			while(_g3 < _g4) {
				var x = _g3++;
				_g.push(p[n - 1 - y + x * n]);
			}
		}
		variations[2] = _g;
		var p = variations[2];
		var _g = [];
		var _g1 = 0;
		var _g2 = n;
		while(_g1 < _g2) {
			var y = _g1++;
			var _g3 = 0;
			var _g4 = n;
			while(_g3 < _g4) {
				var x = _g3++;
				_g.push(p[n - 1 - y + x * n]);
			}
		}
		variations[3] = _g;
		var p = variations[0];
		var _g = [];
		var _g1 = 0;
		var _g2 = n;
		while(_g1 < _g2) {
			var y = _g1++;
			var _g3 = 0;
			var _g4 = n;
			while(_g3 < _g4) {
				var x = _g3++;
				_g.push(p[n - 1 - x + y * n]);
			}
		}
		variations[4] = _g;
		var p = variations[1];
		var _g = [];
		var _g1 = 0;
		var _g2 = n;
		while(_g1 < _g2) {
			var y = _g1++;
			var _g3 = 0;
			var _g4 = n;
			while(_g3 < _g4) {
				var x = _g3++;
				_g.push(p[n - 1 - x + y * n]);
			}
		}
		variations[5] = _g;
		var p = variations[2];
		var _g = [];
		var _g1 = 0;
		var _g2 = n;
		while(_g1 < _g2) {
			var y = _g1++;
			var _g3 = 0;
			var _g4 = n;
			while(_g3 < _g4) {
				var x = _g3++;
				_g.push(p[n - 1 - x + y * n]);
			}
		}
		variations[6] = _g;
		var p = variations[3];
		var _g = [];
		var _g1 = 0;
		var _g2 = n;
		while(_g1 < _g2) {
			var y = _g1++;
			var _g3 = 0;
			var _g4 = n;
			while(_g3 < _g4) {
				var x = _g3++;
				_g.push(p[n - 1 - x + y * n]);
			}
		}
		variations[7] = _g;
		var tmp = this.hashes;
		var p = variations[0];
		var result = 0;
		var power = 1;
		var _g = 0;
		var _g1 = p.length;
		while(_g < _g1) {
			var i = _g++;
			result += p[p.length - 1 - i] != 0 ? power : 0;
			power *= 2;
		}
		tmp[0] = result;
		this.patterns[0] = variations[0];
		if((symmetry & 1) != 0) {
			var tmp = this.hashes;
			var p = variations[1];
			var result = 0;
			var power = 1;
			var _g = 0;
			var _g1 = p.length;
			while(_g < _g1) {
				var i = _g++;
				result += p[p.length - 1 - i] != 0 ? power : 0;
				power *= 2;
			}
			tmp[1] = result;
			this.patterns[1] = variations[1];
		}
		if((symmetry & 2) != 0) {
			var tmp = this.hashes;
			var p = variations[2];
			var result = 0;
			var power = 1;
			var _g = 0;
			var _g1 = p.length;
			while(_g < _g1) {
				var i = _g++;
				result += p[p.length - 1 - i] != 0 ? power : 0;
				power *= 2;
			}
			tmp[2] = result;
			this.patterns[2] = variations[2];
		}
		if((symmetry & 3) != 0) {
			var tmp = this.hashes;
			var p = variations[3];
			var result = 0;
			var power = 1;
			var _g = 0;
			var _g1 = p.length;
			while(_g < _g1) {
				var i = _g++;
				result += p[p.length - 1 - i] != 0 ? power : 0;
				power *= 2;
			}
			tmp[3] = result;
			this.patterns[3] = variations[3];
		}
		if((symmetry & 4) != 0) {
			var tmp = this.hashes;
			var p = variations[4];
			var result = 0;
			var power = 1;
			var _g = 0;
			var _g1 = p.length;
			while(_g < _g1) {
				var i = _g++;
				result += p[p.length - 1 - i] != 0 ? power : 0;
				power *= 2;
			}
			tmp[4] = result;
			this.patterns[4] = variations[4];
		}
		if((symmetry & 5) != 0) {
			var tmp = this.hashes;
			var p = variations[5];
			var result = 0;
			var power = 1;
			var _g = 0;
			var _g1 = p.length;
			while(_g < _g1) {
				var i = _g++;
				result += p[p.length - 1 - i] != 0 ? power : 0;
				power *= 2;
			}
			tmp[5] = result;
			this.patterns[5] = variations[5];
		}
		if((symmetry & 6) != 0) {
			var tmp = this.hashes;
			var p = variations[6];
			var result = 0;
			var power = 1;
			var _g = 0;
			var _g1 = p.length;
			while(_g < _g1) {
				var i = _g++;
				result += p[p.length - 1 - i] != 0 ? power : 0;
				power *= 2;
			}
			tmp[6] = result;
			this.patterns[6] = variations[6];
		}
		if((symmetry & 7) != 0) {
			var tmp = this.hashes;
			var p = variations[7];
			var result = 0;
			var power = 1;
			var _g = 0;
			var _g1 = p.length;
			while(_g < _g1) {
				var i = _g++;
				result += p[p.length - 1 - i] != 0 ? power : 0;
				power *= 2;
			}
			tmp[7] = result;
			this.patterns[7] = variations[7];
		}
	}
	,__class__: dropecho_dungen_map_Pattern
});
var dropecho_dungen_map_extensions_CheckConnectivity = $hx_exports["dungen"]["CheckConnectivity"] = function() { };
$hxClasses["dropecho.dungen.map.extensions.CheckConnectivity"] = dropecho_dungen_map_extensions_CheckConnectivity;
dropecho_dungen_map_extensions_CheckConnectivity.__name__ = "dropecho.dungen.map.extensions.CheckConnectivity";
dropecho_dungen_map_extensions_CheckConnectivity.checkConnectivity = function(map,tile,diagonal) {
	if(diagonal == null) {
		diagonal = true;
	}
	if(tile == null) {
		tile = 0;
	}
	var firstTile = dropecho_dungen_map_extensions_GetFirstTileOfType.getFirstTileOfType(map,tile);
	if(firstTile == null) {
		return false;
	}
	var filledTiles = dropecho_dungen_map_extensions_FloodFill.floodFill(map,firstTile.x,firstTile.y,tile,diagonal);
	firstTile = dropecho_dungen_map_extensions_GetFirstTileOfType.getFirstTileOfType(map,tile,filledTiles);
	return firstTile == null;
};
var dropecho_dungen_map_extensions_DistanceFill = $hx_exports["dungen"]["DistanceFill"] = function() { };
$hxClasses["dropecho.dungen.map.extensions.DistanceFill"] = dropecho_dungen_map_extensions_DistanceFill;
dropecho_dungen_map_extensions_DistanceFill.__name__ = "dropecho.dungen.map.extensions.DistanceFill";
dropecho_dungen_map_extensions_DistanceFill.distanceFill = function(map,tile,diagonal,maxDepth) {
	if(maxDepth == null) {
		maxDepth = 40;
	}
	if(diagonal == null) {
		diagonal = true;
	}
	if(tile == null) {
		tile = 0;
	}
	var distanceMap = new dropecho_dungen_Map2d(map._width,map._height);
	var _g = 0;
	var _g1 = map._mapData.length;
	while(_g < _g1) {
		var i = _g++;
		distanceMap._mapData[i] = map._mapData[i] == tile ? 0 : 999;
	}
	var pass = 0;
	var changes = 1;
	while(changes > 0 && pass++ < maxDepth) {
		changes = 0;
		var _g = 0;
		var _g1 = distanceMap._width;
		while(_g < _g1) {
			var x = _g++;
			var _g2 = 0;
			var _g3 = distanceMap._height;
			while(_g2 < _g3) {
				var y = _g2++;
				var neighbors = dropecho_dungen_map_extensions_Neighbors.getNeighbors(distanceMap,x,y,1);
				var _g4 = 0;
				while(_g4 < neighbors.length) {
					var n = neighbors[_g4];
					++_g4;
					var v = distanceMap._mapData[distanceMap._width * y + x];
					var nval = distanceMap._mapData[distanceMap._width * n.y + n.x];
					if(nval < v) {
						var index = distanceMap._width * y + x;
						distanceMap._mapData[index] = nval + 1;
						++changes;
					}
				}
			}
		}
	}
	return distanceMap;
};
var dropecho_dungen_map_extensions_FindAndReplace = $hx_exports["dungen"]["FindAndReplace"] = function() { };
$hxClasses["dropecho.dungen.map.extensions.FindAndReplace"] = dropecho_dungen_map_extensions_FindAndReplace;
dropecho_dungen_map_extensions_FindAndReplace.__name__ = "dropecho.dungen.map.extensions.FindAndReplace";
dropecho_dungen_map_extensions_FindAndReplace.findAndReplace = function(map,pattern1,pattern2,ignoreTile) {
	if(ignoreTile == null) {
		ignoreTile = -1;
	}
	var _g = 0;
	var _g1 = map._width;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = map._height;
		while(_g2 < _g3) {
			var y = _g2++;
			var patternIndex = pattern1.matchesIndex(map,x,y);
			if(patternIndex != -1) {
				var splat = pattern2.indexToMap(patternIndex);
				dropecho_dungen_map_extensions_Splat.splat(map,splat,x,y,ignoreTile);
			}
		}
	}
	return map;
};
var dropecho_dungen_map_extensions_FloodFill = $hx_exports["dungen"]["FloodFill"] = function() { };
$hxClasses["dropecho.dungen.map.extensions.FloodFill"] = dropecho_dungen_map_extensions_FloodFill;
dropecho_dungen_map_extensions_FloodFill.__name__ = "dropecho.dungen.map.extensions.FloodFill";
dropecho_dungen_map_extensions_FloodFill.floodFill = function(map,startX,startY,tile,diagonal) {
	if(diagonal == null) {
		diagonal = true;
	}
	if(tile == null) {
		tile = 0;
	}
	var closed = new haxe_ds_IntMap();
	var open = [];
	var neighbors = [];
	var currentTile = map.IndexToXY(map._width * startY + startX);
	open.push(currentTile);
	var whereHasNotBeenVisited = function(tile) {
		return closed.h[map._width * tile.y + tile.x] == null;
	};
	var whereTileIsSameType = function(t) {
		return map._mapData[map._width * t.y + t.x] == tile;
	};
	while(open.length > 0) {
		currentTile = open.pop();
		closed.h[map._width * currentTile.y + currentTile.x] = currentTile;
		var _this = dropecho_dungen_map_extensions_Neighbors.getNeighbors(map,currentTile.x,currentTile.y,1,diagonal);
		var f = whereHasNotBeenVisited;
		var _g = [];
		var _g1 = 0;
		var _g2 = _this;
		while(_g1 < _g2.length) {
			var v = _g2[_g1];
			++_g1;
			if(f(v)) {
				_g.push(v);
			}
		}
		var f1 = whereTileIsSameType;
		var _g3 = [];
		var _g4 = 0;
		var _g5 = _g;
		while(_g4 < _g5.length) {
			var v1 = _g5[_g4];
			++_g4;
			if(f1(v1)) {
				_g3.push(v1);
			}
		}
		neighbors = _g3;
		open = open.concat(neighbors);
	}
	return Lambda.array(closed);
};
var dropecho_dungen_map_extensions_GetFirstTileOfType = $hx_exports["dungen"]["GetFirstTileOfType"] = function() { };
$hxClasses["dropecho.dungen.map.extensions.GetFirstTileOfType"] = dropecho_dungen_map_extensions_GetFirstTileOfType;
dropecho_dungen_map_extensions_GetFirstTileOfType.__name__ = "dropecho.dungen.map.extensions.GetFirstTileOfType";
dropecho_dungen_map_extensions_GetFirstTileOfType.getFirstTileOfType = function(map,tile,ignore) {
	if(tile == null) {
		tile = 0;
	}
	var _g = 0;
	var _g1 = map._height * map._width;
	while(_g < _g1) {
		var i = _g++;
		if(map._mapData[i] == tile) {
			var cur = [map.IndexToXY(i)];
			if(ignore != null) {
				var foo = Lambda.find(ignore,(function(cur) {
					return function(tile) {
						if(tile.x == cur[0].x) {
							return tile.y == cur[0].y;
						} else {
							return false;
						}
					};
				})(cur));
				if(foo != null) {
					continue;
				}
			}
			return cur[0];
		}
	}
	return null;
};
var dropecho_dungen_map_extensions_Neighbors = $hx_exports["dungen"]["Neighbors"] = function() { };
$hxClasses["dropecho.dungen.map.extensions.Neighbors"] = dropecho_dungen_map_extensions_Neighbors;
dropecho_dungen_map_extensions_Neighbors.__name__ = "dropecho.dungen.map.extensions.Neighbors";
dropecho_dungen_map_extensions_Neighbors.getNeighborCount = function(map,x,y,neighborType,dist,diagonal) {
	if(diagonal == null) {
		diagonal = true;
	}
	if(dist == null) {
		dist = 1;
	}
	var isNeighborType = function(tile) {
		return map._mapData[map._width * tile.y + tile.x] == neighborType;
	};
	return Lambda.count(dropecho_dungen_map_extensions_Neighbors.getNeighbors(map,x,y,dist,diagonal),isNeighborType);
};
dropecho_dungen_map_extensions_Neighbors.getNeighbors = function(map,x,y,dist,diagonal) {
	if(diagonal == null) {
		diagonal = true;
	}
	if(dist == null) {
		dist = 1;
	}
	var neighbors = [];
	var isSelf = false;
	var isNotOnMap = false;
	var _g = -dist;
	var _g1 = dist + 1;
	while(_g < _g1) {
		var i = _g++;
		var _g2 = -dist;
		var _g3 = dist + 1;
		while(_g2 < _g3) {
			var j = _g2++;
			isSelf = i == 0 && j == 0;
			isNotOnMap = x + i < 0 || x + i >= map._width || y + j < 0 || y + j >= map._height;
			if(isSelf || isNotOnMap) {
				continue;
			}
			if(!diagonal && (i == j || i == -dist && j == dist || j == -dist && i == dist)) {
				continue;
			}
			var val = map._mapData[map._width * (y + j) + (x + i)];
			neighbors.push(new dropecho_dungen_Tile2d(x + i,y + j,val));
		}
	}
	return neighbors;
};
var dropecho_dungen_map_extensions_Queue = function() {
	this.data = [];
};
$hxClasses["dropecho.dungen.map.extensions.Queue"] = dropecho_dungen_map_extensions_Queue;
dropecho_dungen_map_extensions_Queue.__name__ = "dropecho.dungen.map.extensions.Queue";
dropecho_dungen_map_extensions_Queue.prototype = {
	data: null
	,enqueue: function(value) {
		this.data.unshift(value);
	}
	,dequeue: function() {
		return this.data.pop();
	}
	,length: function() {
		return this.data.length;
	}
	,__class__: dropecho_dungen_map_extensions_Queue
};
var dropecho_dungen_map_extensions_RegionFill = $hx_exports["dungen"]["RegionFill"] = function() { };
$hxClasses["dropecho.dungen.map.extensions.RegionFill"] = dropecho_dungen_map_extensions_RegionFill;
dropecho_dungen_map_extensions_RegionFill.__name__ = "dropecho.dungen.map.extensions.RegionFill";
dropecho_dungen_map_extensions_RegionFill.BFS = function(map,x,y,value) {
	var q = new dropecho_dungen_map_extensions_Queue();
	var visited_h = { };
	q.enqueue(new dropecho_dungen_Tile2d(x,y));
	visited_h[map._width * y + x] = -1;
	var currentIndex = -1;
	while(q.length() > 0) {
		var current = q.dequeue();
		if(map._mapData[map._width * current.y + current.x] == value) {
			break;
		}
		currentIndex = map._width * current.y + current.x;
		var neighbors = dropecho_dungen_map_extensions_Neighbors.getNeighbors(map,current.x,current.y);
		var _g = 0;
		while(_g < neighbors.length) {
			var neighbor = neighbors[_g];
			++_g;
			var index = map._width * neighbor.y + neighbor.x;
			if(!visited_h.hasOwnProperty(index)) {
				visited_h[index] = currentIndex;
				q.enqueue(neighbor);
			}
		}
	}
	var path = [];
	while(currentIndex != -1) {
		currentIndex = visited_h[currentIndex];
		if(currentIndex != -1) {
			path.push(map.IndexToXY(currentIndex));
		}
	}
	return path;
};
dropecho_dungen_map_extensions_RegionFill.distToValue = function(map,x,y,value) {
	var count = 0;
	var dist = 0;
	while(count == 0 && dist < 10) {
		++dist;
		count = dropecho_dungen_map_extensions_Neighbors.getNeighborCount(map,x,y,value,dist);
	}
	return dist - 1;
};
dropecho_dungen_map_extensions_RegionFill.regionFill = function(map,wall,diagonal) {
	if(diagonal == null) {
		diagonal = true;
	}
	if(wall == null) {
		wall = 0;
	}
	var regionMapWallValue = 999999;
	var regionMap = new dropecho_dungen_Map2d(map._width,map._height);
	var _g = 0;
	var _g1 = map._mapData.length;
	while(_g < _g1) {
		var i = _g++;
		if(map._mapData[i] == wall) {
			regionMap._mapData[i] = regionMapWallValue;
		} else {
			regionMap._mapData[i] = map._mapData[i];
		}
	}
	var _g = 0;
	var _g1 = regionMap._mapData.length;
	while(_g < _g1) {
		var i = _g++;
		if(regionMap._mapData[i] == regionMapWallValue) {
			continue;
		}
		var tile = regionMap.IndexToXY(i);
		regionMap._mapData[i] = dropecho_dungen_map_extensions_RegionFill.distToValue(regionMap,tile.x,tile.y,regionMapWallValue);
	}
	return regionMap;
};
var dropecho_dungen_map_extensions_RegionManager = $hx_exports["dungen"]["RegionManager"] = function() { };
$hxClasses["dropecho.dungen.map.extensions.RegionManager"] = dropecho_dungen_map_extensions_RegionManager;
dropecho_dungen_map_extensions_RegionManager.__name__ = "dropecho.dungen.map.extensions.RegionManager";
dropecho_dungen_map_extensions_RegionManager.removeIslandsBySize = function(map,size,tileType) {
	if(tileType == null) {
		tileType = 1;
	}
	if(size == null) {
		size = 4;
	}
	var cleanedMap = new dropecho_dungen_Map2d(map._width,map._height);
	var nextTile;
	var visited = [];
	var _g = 0;
	var _g1 = map._mapData.length;
	while(_g < _g1) {
		var i = _g++;
		cleanedMap._mapData[i] = map._mapData[i];
	}
	while(true) {
		nextTile = dropecho_dungen_map_extensions_GetFirstTileOfType.getFirstTileOfType(cleanedMap,tileType,visited);
		if(!(nextTile != null)) {
			break;
		}
		var tiles = dropecho_dungen_map_extensions_FloodFill.floodFill(cleanedMap,nextTile.x,nextTile.y,tileType);
		var isIsland = tiles.length <= size;
		if(isIsland) {
			visited.push(nextTile);
		}
		var _g = 0;
		while(_g < tiles.length) {
			var t = tiles[_g];
			++_g;
			if(isIsland) {
				var index = cleanedMap._width * t.y + t.x;
				cleanedMap._mapData[index] = 0;
			} else {
				visited.push(t);
			}
		}
	}
	return cleanedMap;
};
dropecho_dungen_map_extensions_RegionManager.removeIslands = function(map,tileType) {
	if(tileType == null) {
		tileType = 1;
	}
	var nextTile;
	var visited = [];
	var cleanedMap = new dropecho_dungen_Map2d(map._width,map._height);
	var _g = 0;
	var _g1 = map._mapData.length;
	while(_g < _g1) {
		var i = _g++;
		cleanedMap._mapData[i] = map._mapData[i];
	}
	while(true) {
		nextTile = dropecho_dungen_map_extensions_GetFirstTileOfType.getFirstTileOfType(cleanedMap,tileType,visited);
		if(!(nextTile != null)) {
			break;
		}
		visited.push(nextTile);
		var tiles = dropecho_dungen_map_extensions_FloodFill.floodFill(cleanedMap,nextTile.x,nextTile.y,tileType);
		var isIsland = true;
		var _g = 0;
		while(_g < tiles.length) {
			var t = tiles[_g];
			++_g;
			if(dropecho_dungen_map_extensions_Neighbors.getNeighborCount(map,t.x,t.y,tileType) + dropecho_dungen_map_extensions_Neighbors.getNeighborCount(map,t.x,t.y,0) != 8) {
				isIsland = false;
				break;
			}
		}
		if(isIsland) {
			var _g1 = 0;
			while(_g1 < tiles.length) {
				var t1 = tiles[_g1];
				++_g1;
				var index = cleanedMap._width * t1.y + t1.x;
				cleanedMap._mapData[index] = 0;
			}
		}
	}
	return cleanedMap;
};
dropecho_dungen_map_extensions_RegionManager.findAndTagBorders = function(map,borderType,startTag) {
	if(startTag == null) {
		startTag = 2;
	}
	if(borderType == null) {
		borderType = 1;
	}
	var borderMap = new dropecho_dungen_Map2d(map._width,map._height);
	var _g = 0;
	var _g1 = map._mapData.length;
	while(_g < _g1) {
		var i = _g++;
		borderMap._mapData[i] = map._mapData[i] != borderType ? 0 : 1;
	}
	var nextBorder;
	var nextTag = startTag;
	while(true) {
		nextBorder = dropecho_dungen_map_extensions_GetFirstTileOfType.getFirstTileOfType(borderMap,borderType);
		if(!(nextBorder != null)) {
			break;
		}
		var _g = 0;
		var _g1 = dropecho_dungen_map_extensions_FloodFill.floodFill(borderMap,nextBorder.x,nextBorder.y,borderType);
		while(_g < _g1.length) {
			var t = _g1[_g];
			++_g;
			var index = borderMap._width * t.y + t.x;
			borderMap._mapData[index] = nextTag;
		}
		++nextTag;
	}
	return borderMap;
};
dropecho_dungen_map_extensions_RegionManager.findAndTagRegions = function(map,depth) {
	if(depth == null) {
		depth = 2;
	}
	var regionmap = new dropecho_dungen_Map2d(map._width,map._height,0);
	var _g = 0;
	var _g1 = map._mapData.length;
	while(_g < _g1) {
		var i = _g++;
		var val = map._mapData[i] > depth ? depth : map._mapData[i];
		regionmap._mapData[i] = val;
	}
	var nextRegion;
	var nextTag = depth + 1;
	while(true) {
		nextRegion = dropecho_dungen_map_extensions_GetFirstTileOfType.getFirstTileOfType(regionmap,depth);
		if(!(nextRegion != null)) {
			break;
		}
		var _g = 0;
		var _g1 = dropecho_dungen_map_extensions_FloodFill.floodFill(regionmap,nextRegion.x,nextRegion.y,depth);
		while(_g < _g1.length) {
			var t = _g1[_g];
			++_g;
			var index = regionmap._width * t.y + t.x;
			regionmap._mapData[index] = nextTag;
		}
		++nextTag;
	}
	return regionmap;
};
dropecho_dungen_map_extensions_RegionManager.expandRegionsByOne = function(map,startTag) {
	if(startTag == null) {
		startTag = 3;
	}
	var tilesToPaint = new haxe_ds_IntMap();
	var _g = 0;
	var _g1 = map._width;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = map._height;
		while(_g2 < _g3) {
			var y = _g2++;
			var tileVal = map._mapData[map._width * y + x];
			if(tileVal < startTag) {
				var neighbors = dropecho_dungen_map_extensions_Neighbors.getNeighbors(map,x,y);
				var _g4 = 0;
				while(_g4 < neighbors.length) {
					var n = neighbors[_g4];
					++_g4;
					if(n.val >= startTag) {
						tilesToPaint.h[map._width * y + x] = n.val;
					}
				}
			}
		}
	}
	var map1 = tilesToPaint;
	var _g2_map = map1;
	var _g2_keys = map1.keys();
	while(_g2_keys.hasNext()) {
		var key = _g2_keys.next();
		var _g3_value = _g2_map.get(key);
		var _g3_key = key;
		var index = _g3_key;
		var value = _g3_value;
		map._mapData[index] = value;
	}
	return map;
};
dropecho_dungen_map_extensions_RegionManager.expandRegions = function(map,startTag,eatWalls) {
	if(eatWalls == null) {
		eatWalls = false;
	}
	if(startTag == null) {
		startTag = 3;
	}
	var _g = 0;
	while(_g < 100) {
		var _ = _g++;
		var _g1 = startTag;
		var _g2 = startTag + 500;
		while(_g1 < _g2) {
			var currentTag = _g1++;
			var tilesToPaint = [];
			var _g3 = 0;
			var _g4 = map._width;
			while(_g3 < _g4) {
				var x = _g3++;
				var _g5 = 0;
				var _g6 = map._height;
				while(_g5 < _g6) {
					var y = _g5++;
					if(map._mapData[map._width * y + x] == currentTag) {
						var neighbors = dropecho_dungen_map_extensions_Neighbors.getNeighbors(map,x,y,1,true);
						var _g7 = 0;
						while(_g7 < neighbors.length) {
							var n = neighbors[_g7];
							++_g7;
							if(n.val < startTag) {
								if(!eatWalls && n.val == 0) {
									continue;
								}
								var nWalls = dropecho_dungen_map_extensions_Neighbors.getNeighborCount(map,n.x,n.y,0,1,true);
								var nOpen = 0;
								var _g8 = 1;
								var _g9 = startTag;
								while(_g8 < _g9) {
									var i = _g8++;
									nOpen += dropecho_dungen_map_extensions_Neighbors.getNeighborCount(map,n.x,n.y,i,1,true);
								}
								var nTag = dropecho_dungen_map_extensions_Neighbors.getNeighborCount(map,n.x,n.y,currentTag,1,true);
								if(nWalls + nOpen + nTag == 8) {
									tilesToPaint.push(map._width * n.y + n.x);
								}
							}
						}
					}
				}
			}
			var _g10 = 0;
			while(_g10 < tilesToPaint.length) {
				var c = tilesToPaint[_g10];
				++_g10;
				map._mapData[c] = currentTag;
			}
		}
	}
	return map;
};
var dropecho_dungen_map_extensions_Splat = function() { };
$hxClasses["dropecho.dungen.map.extensions.Splat"] = dropecho_dungen_map_extensions_Splat;
dropecho_dungen_map_extensions_Splat.__name__ = "dropecho.dungen.map.extensions.Splat";
dropecho_dungen_map_extensions_Splat.splat = function(map,other,x,y,ignoreTile) {
	if(ignoreTile == null) {
		ignoreTile = -1;
	}
	var _g = 0;
	var _g1 = other._width;
	while(_g < _g1) {
		var x2 = _g++;
		var _g2 = 0;
		var _g3 = other._height;
		while(_g2 < _g3) {
			var y2 = _g2++;
			var otherTile = other._mapData[other._width * y2 + x2];
			if(otherTile != ignoreTile) {
				var index = map._width * (y2 + y) + (x2 + x);
				map._mapData[index] = otherTile;
			}
		}
	}
};
var dropecho_dungen_map_extensions_Utils = function() { };
$hxClasses["dropecho.dungen.map.extensions.Utils"] = dropecho_dungen_map_extensions_Utils;
dropecho_dungen_map_extensions_Utils.__name__ = "dropecho.dungen.map.extensions.Utils";
dropecho_dungen_map_extensions_Utils.getRect = function(map,rect,wrap) {
	if(wrap == null) {
		wrap = false;
	}
	var _g = [];
	var _g1 = rect.y;
	var _g2 = rect.y + rect.height;
	while(_g1 < _g2) {
		var j = _g1++;
		var _g3 = rect.x;
		var _g4 = rect.x + rect.width;
		while(_g3 < _g4) {
			var i = _g3++;
			if(wrap) {
				_g.push(map._mapData[map._width * (j % map._height) + i % map._width]);
			} else {
				_g.push(map._mapData[map._width * j + i]);
			}
		}
	}
	return _g;
};
dropecho_dungen_map_extensions_Utils.setRect = function(map,rect,data) {
	var _g = rect.y;
	var _g1 = rect.y + rect.height + 1;
	while(_g < _g1) {
		var j = _g++;
		var _g2 = rect.x;
		var _g3 = rect.x + rect.width + 1;
		while(_g2 < _g3) {
			var i = _g2++;
			var index = map._width * j + i;
			map._mapData[index] = data;
		}
	}
};
dropecho_dungen_map_extensions_Utils.checkOverlap = function(r1,r2) {
	var r1p1_x = r1.x;
	var r1p1_y = r1.y;
	var r1p2_x = r1.x + r1.width;
	var r1p2_y = r1.y + r1.height;
	var r2p1_x = r2.x;
	var r2p1_y = r2.y;
	var r2p2_x = r2.x + r2.width;
	var r2p2_y = r2.y + r2.height;
	return !(r1p1_x > r2p2_x || r2p1_x > r1p2_x || r1p1_y > r2p2_y || r2p1_y > r1p2_y);
};
dropecho_dungen_map_extensions_Utils.contains = function(r1,r2) {
	var r1p1_x = r1.x;
	var r1p1_y = r1.y;
	var r1p2_x = r1.x + r1.width;
	var r1p2_y = r1.y + r1.height;
	var r2p1_x = r2.x;
	var r2p1_y = r2.y;
	var r2p2_x = r2.x + r2.width;
	var r2p2_y = r2.y + r2.height;
	if(r2p2_x < r1p2_x && r2p2_y < r1p2_y && r2p1_x > r1p1_x) {
		return r2p1_y > r1p1_y;
	} else {
		return false;
	}
};
dropecho_dungen_map_extensions_Utils.isOverlappingArray = function(r1,a) {
	var _g = 0;
	while(_g < a.length) {
		var r = a[_g];
		++_g;
		if(r == r1) {
			continue;
		}
		if(dropecho_dungen_map_extensions_Utils.checkOverlap(r1,r)) {
			return true;
		}
	}
	return false;
};
var dropecho_interop_AbstractArray = {};
dropecho_interop_AbstractArray._new = function(a) {
	var this1;
	if(a != null) {
		this1 = a;
	} else {
		this1 = [];
	}
	return this1;
};
dropecho_interop_AbstractArray.get = function(this1,i) {
	return this1[i];
};
dropecho_interop_AbstractArray.set = function(this1,i,v) {
	return this1[i] = v;
};
dropecho_interop_AbstractArray.fromAny = function(d) {
	var arr = js_Boot.__cast(d , Array);
	var _g = [];
	var _g1 = 0;
	while(_g1 < arr.length) {
		var v = arr[_g1];
		++_g1;
		_g.push(v);
	}
	return dropecho_interop_AbstractArray._new(_g);
};
var dropecho_interop_JSAbstractMapKeyValueIterator = function(map) {
	this._iter = new haxe_iterators_DynamicAccessKeyValueIterator(map);
};
$hxClasses["dropecho.interop.JSAbstractMapKeyValueIterator"] = dropecho_interop_JSAbstractMapKeyValueIterator;
dropecho_interop_JSAbstractMapKeyValueIterator.__name__ = "dropecho.interop.JSAbstractMapKeyValueIterator";
dropecho_interop_JSAbstractMapKeyValueIterator.prototype = {
	_iter: null
	,hasNext: function() {
		var _this = this._iter;
		return _this.index < _this.keys.length;
	}
	,next: function() {
		var _this = this._iter;
		var key = _this.keys[_this.index++];
		return { value : _this.access[key], key : key};
	}
	,__class__: dropecho_interop_JSAbstractMapKeyValueIterator
};
var dropecho_interop_AbstractMap = {};
dropecho_interop_AbstractMap._new = function(s) {
	var this1;
	if(s != null) {
		this1 = s;
	} else {
		var this2 = { };
		this1 = this2;
	}
	return this1;
};
dropecho_interop_AbstractMap.keyValueIterator = function(this1) {
	return new dropecho_interop_JSAbstractMapKeyValueIterator(this1);
};
dropecho_interop_AbstractMap.fromMap = function(map) {
	var abs = dropecho_interop_AbstractMap._new();
	var _g = map.keyValueIterator();
	while(_g.hasNext()) {
		var _g1 = _g.next();
		var k = _g1.key;
		var v = _g1.value;
		abs[Std.string(k)] = v;
	}
	return abs;
};
dropecho_interop_AbstractMap.fromIMap = function(map) {
	var abs = dropecho_interop_AbstractMap._new();
	var _g = map.keyValueIterator();
	while(_g.hasNext()) {
		var _g1 = _g.next();
		var k = _g1.key;
		var v = _g1.value;
		abs[Std.string(k)] = v;
	}
	return abs;
};
dropecho_interop_AbstractMap.exists = function(this1,key) {
	return Object.prototype.hasOwnProperty.call(this1,Std.string(key));
};
dropecho_interop_AbstractMap.get = function(this1,key) {
	return this1[Std.string(key)];
};
dropecho_interop_AbstractMap.set = function(this1,key,value) {
	this1[Std.string(key)] = value;
	return value;
};
dropecho_interop_AbstractMap.clear = function(this1) {
	var _g = 0;
	var _g1 = Reflect.fields(this1);
	while(_g < _g1.length) {
		var key = _g1[_g];
		++_g;
		Reflect.deleteField(this1,key);
	}
};
var dropecho_interop_Extender = function() { };
$hxClasses["dropecho.interop.Extender"] = dropecho_interop_Extender;
dropecho_interop_Extender.__name__ = "dropecho.interop.Extender";
dropecho_interop_Extender.extendThis = function(base,extension) {
	if(extension == null) {
		return;
	}
	var _g = 0;
	var _g1 = Reflect.fields(base);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		var def = Reflect.field(base,f);
		var opt = Reflect.field(extension,f);
		base[f] = opt != null ? opt : def;
	}
};
dropecho_interop_Extender.defaults = function(base,extension) {
	if(base == null) {
		throw haxe_Exception.thrown("Base cannot be null.");
	}
	if(extension == null) {
		return base;
	}
	var extensions = [];
	if(((extension) instanceof Array)) {
		extensions = extension.filter(function(x) {
			return x != null;
		});
	} else {
		extensions.push(extension);
	}
	var _g = 0;
	while(_g < extensions.length) {
		var ex = extensions[_g];
		++_g;
		var fields = Reflect.fields(ex);
		var exType = js_Boot.getClass(ex);
		var typeFields;
		if(exType != null) {
			var _this = Type.getInstanceFields(exType);
			var result = new Array(_this.length);
			var _g1 = 0;
			var _g2 = _this.length;
			while(_g1 < _g2) {
				var i = _g1++;
				var f = _this[i];
				var typeFields1;
				if(StringTools.startsWith(f,"get_") || StringTools.startsWith(f,"set_")) {
					var parts = f.split("_");
					parts.shift();
					typeFields1 = parts.join("_");
				} else {
					typeFields1 = f;
				}
				result[i] = typeFields1;
			}
			typeFields = result;
		} else {
			typeFields = [];
		}
		if(fields.length == 0) {
			fields = typeFields;
		}
		var baseFields = [];
		var baseClass = js_Boot.getClass(base);
		if(baseClass != null) {
			baseFields = Type.getInstanceFields(baseClass);
		}
		var _g3 = 0;
		while(_g3 < fields.length) {
			var ff = fields[_g3];
			++_g3;
			var exField = Reflect.field(ex,ff);
			var baseField = Reflect.field(base,ff);
			var bfIsArray = dropecho_interop_Extender.isArray(baseField);
			var bfIsMap = dropecho_interop_Extender.isMap(baseField);
			var bfIsObject = !bfIsArray && !bfIsMap && dropecho_interop_Extender.isObject(baseField);
			if(bfIsArray) {
				var copy = dropecho_interop_AbstractArray.fromAny(exField);
				var _g4 = 0;
				var _g5 = copy;
				while(_g4 < _g5.length) {
					var v = _g5[_g4];
					++_g4;
					baseField.push(v);
				}
			} else if(bfIsMap) {
				var abs = dropecho_interop_AbstractMap._new();
				var _g6 = exField.keyValueIterator();
				while(_g6.hasNext()) {
					var _g7 = _g6.next();
					var k = _g7.key;
					var v1 = _g7.value;
					abs[Std.string(k)] = v1;
				}
				var copy1 = abs;
				var _g8 = new dropecho_interop_JSAbstractMapKeyValueIterator(copy1);
				while(_g8.hasNext()) {
					var _g9 = _g8.next();
					var k1 = _g9.key;
					var v2 = _g9.value;
					baseField.set(k1,v2);
				}
			} else if(bfIsObject) {
				dropecho_interop_Extender.defaults(baseField,exField);
			} else {
				try {
					base[ff] = exField;
				} catch( _g10 ) {
					haxe_NativeStackTrace.lastError = _g10;
					var ex1 = haxe_Exception.caught(_g10).unwrap();
					haxe_Log.trace("FAILED SETTING PROP: " + ff + " error: " + Std.string(ex1),{ fileName : "dropecho/interop/Extender.hx", lineNumber : 85, className : "dropecho.interop.Extender", methodName : "defaults"});
				}
			}
		}
	}
	return base;
};
dropecho_interop_Extender.isObject = function(obj) {
	var stdis = Reflect.isObject(obj);
	var type = js_Boot.getClass(obj);
	var name = type != null ? type.__name__ : "";
	var refis = name != "String";
	if(stdis) {
		return refis;
	} else {
		return false;
	}
};
dropecho_interop_Extender.isArray = function(obj) {
	return ((obj) instanceof Array);
};
dropecho_interop_Extender.isMap = function(obj) {
	if(((obj) instanceof Map)) {
		return true;
	}
	var type = js_Boot.getClass(obj);
	var name = type != null ? type.__name__ : "";
	if(name == null) {
		name = "";
	}
	var isMap = StringTools.startsWith(name,"haxe.ds.") && StringTools.endsWith(name,"Map");
	return isMap;
};
var haxe_StackItem = $hxEnums["haxe.StackItem"] = { __ename__:"haxe.StackItem",__constructs__:null
	,CFunction: {_hx_name:"CFunction",_hx_index:0,__enum__:"haxe.StackItem",toString:$estr}
	,Module: ($_=function(m) { return {_hx_index:1,m:m,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="Module",$_.__params__ = ["m"],$_)
	,FilePos: ($_=function(s,file,line,column) { return {_hx_index:2,s:s,file:file,line:line,column:column,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="FilePos",$_.__params__ = ["s","file","line","column"],$_)
	,Method: ($_=function(classname,method) { return {_hx_index:3,classname:classname,method:method,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="Method",$_.__params__ = ["classname","method"],$_)
	,LocalFunction: ($_=function(v) { return {_hx_index:4,v:v,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="LocalFunction",$_.__params__ = ["v"],$_)
};
haxe_StackItem.__constructs__ = [haxe_StackItem.CFunction,haxe_StackItem.Module,haxe_StackItem.FilePos,haxe_StackItem.Method,haxe_StackItem.LocalFunction];
haxe_StackItem.__empty_constructs__ = [haxe_StackItem.CFunction];
var haxe_CallStack = {};
haxe_CallStack.__properties__ = {get_length:"get_length"};
haxe_CallStack.get_length = function(this1) {
	return this1.length;
};
haxe_CallStack.callStack = function() {
	return haxe_NativeStackTrace.toHaxe(haxe_NativeStackTrace.callStack());
};
haxe_CallStack.exceptionStack = function(fullStack) {
	if(fullStack == null) {
		fullStack = false;
	}
	var eStack = haxe_NativeStackTrace.toHaxe(haxe_NativeStackTrace.exceptionStack());
	return fullStack ? eStack : haxe_CallStack.subtract(eStack,haxe_CallStack.callStack());
};
haxe_CallStack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	var _g1 = stack;
	while(_g < _g1.length) {
		var s = _g1[_g];
		++_g;
		b.b += "\nCalled from ";
		haxe_CallStack.itemToString(b,s);
	}
	return b.b;
};
haxe_CallStack.subtract = function(this1,stack) {
	var startIndex = -1;
	var i = -1;
	while(++i < this1.length) {
		var _g = 0;
		var _g1 = stack.length;
		while(_g < _g1) {
			var j = _g++;
			if(haxe_CallStack.equalItems(this1[i],stack[j])) {
				if(startIndex < 0) {
					startIndex = i;
				}
				++i;
				if(i >= this1.length) {
					break;
				}
			} else {
				startIndex = -1;
			}
		}
		if(startIndex >= 0) {
			break;
		}
	}
	if(startIndex >= 0) {
		return this1.slice(0,startIndex);
	} else {
		return this1;
	}
};
haxe_CallStack.copy = function(this1) {
	return this1.slice();
};
haxe_CallStack.get = function(this1,index) {
	return this1[index];
};
haxe_CallStack.asArray = function(this1) {
	return this1;
};
haxe_CallStack.equalItems = function(item1,item2) {
	if(item1 == null) {
		if(item2 == null) {
			return true;
		} else {
			return false;
		}
	} else {
		switch(item1._hx_index) {
		case 0:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 0) {
				return true;
			} else {
				return false;
			}
			break;
		case 1:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 1) {
				var m2 = item2.m;
				var m1 = item1.m;
				return m1 == m2;
			} else {
				return false;
			}
			break;
		case 2:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 2) {
				var item21 = item2.s;
				var file2 = item2.file;
				var line2 = item2.line;
				var col2 = item2.column;
				var col1 = item1.column;
				var line1 = item1.line;
				var file1 = item1.file;
				var item11 = item1.s;
				if(file1 == file2 && line1 == line2 && col1 == col2) {
					return haxe_CallStack.equalItems(item11,item21);
				} else {
					return false;
				}
			} else {
				return false;
			}
			break;
		case 3:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 3) {
				var class2 = item2.classname;
				var method2 = item2.method;
				var method1 = item1.method;
				var class1 = item1.classname;
				if(class1 == class2) {
					return method1 == method2;
				} else {
					return false;
				}
			} else {
				return false;
			}
			break;
		case 4:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 4) {
				var v2 = item2.v;
				var v1 = item1.v;
				return v1 == v2;
			} else {
				return false;
			}
			break;
		}
	}
};
haxe_CallStack.exceptionToString = function(e) {
	if(e.get_previous() == null) {
		var tmp = "Exception: " + e.toString();
		var tmp1 = e.get_stack();
		return tmp + (tmp1 == null ? "null" : haxe_CallStack.toString(tmp1));
	}
	var result = "";
	var e1 = e;
	var prev = null;
	while(e1 != null) {
		if(prev == null) {
			var result1 = "Exception: " + e1.get_message();
			var tmp = e1.get_stack();
			result = result1 + (tmp == null ? "null" : haxe_CallStack.toString(tmp)) + result;
		} else {
			var prevStack = haxe_CallStack.subtract(e1.get_stack(),prev.get_stack());
			result = "Exception: " + e1.get_message() + (prevStack == null ? "null" : haxe_CallStack.toString(prevStack)) + "\n\nNext " + result;
		}
		prev = e1;
		e1 = e1.get_previous();
	}
	return result;
};
haxe_CallStack.itemToString = function(b,s) {
	switch(s._hx_index) {
	case 0:
		b.b += "a C function";
		break;
	case 1:
		var m = s.m;
		b.b += "module ";
		b.b += m == null ? "null" : "" + m;
		break;
	case 2:
		var s1 = s.s;
		var file = s.file;
		var line = s.line;
		var col = s.column;
		if(s1 != null) {
			haxe_CallStack.itemToString(b,s1);
			b.b += " (";
		}
		b.b += file == null ? "null" : "" + file;
		b.b += " line ";
		b.b += line == null ? "null" : "" + line;
		if(col != null) {
			b.b += " column ";
			b.b += col == null ? "null" : "" + col;
		}
		if(s1 != null) {
			b.b += ")";
		}
		break;
	case 3:
		var cname = s.classname;
		var meth = s.method;
		b.b += Std.string(cname == null ? "<unknown>" : cname);
		b.b += ".";
		b.b += meth == null ? "null" : "" + meth;
		break;
	case 4:
		var n = s.v;
		b.b += "local function #";
		b.b += n == null ? "null" : "" + n;
		break;
	}
};
var haxe_IMap = function() { };
$hxClasses["haxe.IMap"] = haxe_IMap;
haxe_IMap.__name__ = "haxe.IMap";
haxe_IMap.__isInterface__ = true;
haxe_IMap.prototype = {
	get: null
	,set: null
	,exists: null
	,remove: null
	,keys: null
	,iterator: null
	,keyValueIterator: null
	,copy: null
	,toString: null
	,clear: null
	,__class__: haxe_IMap
};
var haxe_DynamicAccess = {};
haxe_DynamicAccess._new = function() {
	var this1 = { };
	return this1;
};
haxe_DynamicAccess.get = function(this1,key) {
	return this1[key];
};
haxe_DynamicAccess.set = function(this1,key,value) {
	return this1[key] = value;
};
haxe_DynamicAccess.exists = function(this1,key) {
	return Object.prototype.hasOwnProperty.call(this1,key);
};
haxe_DynamicAccess.remove = function(this1,key) {
	return Reflect.deleteField(this1,key);
};
haxe_DynamicAccess.keys = function(this1) {
	return Reflect.fields(this1);
};
haxe_DynamicAccess.copy = function(this1) {
	return Reflect.copy(this1);
};
haxe_DynamicAccess.iterator = function(this1) {
	return new haxe_iterators_DynamicAccessIterator(this1);
};
haxe_DynamicAccess.keyValueIterator = function(this1) {
	return new haxe_iterators_DynamicAccessKeyValueIterator(this1);
};
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
	this.__skipStack = 0;
	var old = Error.prepareStackTrace;
	Error.prepareStackTrace = function(e) { return e.stack; }
	if(((native) instanceof Error)) {
		this.stack = native.stack;
	} else {
		var e = null;
		if(Error.captureStackTrace) {
			Error.captureStackTrace(this,haxe_Exception);
			e = this;
		} else {
			e = new Error();
			if(typeof(e.stack) == "undefined") {
				try { throw e; } catch(_) {}
				this.__skipStack++;
			}
		}
		this.stack = e.stack;
	}
	Error.prepareStackTrace = old;
};
$hxClasses["haxe.Exception"] = haxe_Exception;
haxe_Exception.__name__ = "haxe.Exception";
haxe_Exception.caught = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value;
	} else if(((value) instanceof Error)) {
		return new haxe_Exception(value.message,null,value);
	} else {
		return new haxe_ValueException(value,null,value);
	}
};
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		e.__skipStack++;
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	__skipStack: null
	,__nativeException: null
	,__previousException: null
	,unwrap: function() {
		return this.__nativeException;
	}
	,toString: function() {
		return this.get_message();
	}
	,details: function() {
		if(this.get_previous() == null) {
			var tmp = "Exception: " + this.toString();
			var tmp1 = this.get_stack();
			return tmp + (tmp1 == null ? "null" : haxe_CallStack.toString(tmp1));
		} else {
			var result = "";
			var e = this;
			var prev = null;
			while(e != null) {
				if(prev == null) {
					var result1 = "Exception: " + e.get_message();
					var tmp = e.get_stack();
					result = result1 + (tmp == null ? "null" : haxe_CallStack.toString(tmp)) + result;
				} else {
					var prevStack = haxe_CallStack.subtract(e.get_stack(),prev.get_stack());
					result = "Exception: " + e.get_message() + (prevStack == null ? "null" : haxe_CallStack.toString(prevStack)) + "\n\nNext " + result;
				}
				prev = e;
				e = e.get_previous();
			}
			return result;
		}
	}
	,__shiftStack: function() {
		this.__skipStack++;
	}
	,get_message: function() {
		return this.message;
	}
	,get_previous: function() {
		return this.__previousException;
	}
	,get_native: function() {
		return this.__nativeException;
	}
	,get_stack: function() {
		var _g = this.__exceptionStack;
		if(_g == null) {
			var value = haxe_NativeStackTrace.toHaxe(haxe_NativeStackTrace.normalize(this.stack),this.__skipStack);
			this.setProperty("__exceptionStack",value);
			return value;
		} else {
			var s = _g;
			return s;
		}
	}
	,setProperty: function(name,value) {
		try {
			Object.defineProperty(this,name,{ value : value});
		} catch( _g ) {
			this[name] = value;
		}
	}
	,get___exceptionStack: function() {
		return this.__exceptionStack;
	}
	,set___exceptionStack: function(value) {
		this.setProperty("__exceptionStack",value);
		return value;
	}
	,get___skipStack: function() {
		return this.__skipStack;
	}
	,set___skipStack: function(value) {
		this.setProperty("__skipStack",value);
		return value;
	}
	,get___nativeException: function() {
		return this.__nativeException;
	}
	,set___nativeException: function(value) {
		this.setProperty("__nativeException",value);
		return value;
	}
	,get___previousException: function() {
		return this.__previousException;
	}
	,set___previousException: function(value) {
		this.setProperty("__previousException",value);
		return value;
	}
	,__class__: haxe_Exception
	,__properties__: {set___exceptionStack:"set___exceptionStack",get___exceptionStack:"get___exceptionStack",get_native:"get_native",get_previous:"get_previous",get_stack:"get_stack",get_message:"get_message"}
});
var haxe_Int32 = {};
haxe_Int32.negate = function(this1) {
	return ~this1 + 1 | 0;
};
haxe_Int32.preIncrement = function(this1) {
	this1 = ++this1 | 0;
	return this1;
};
haxe_Int32.postIncrement = function(this1) {
	var ret = this1++;
	this1 |= 0;
	return ret;
};
haxe_Int32.preDecrement = function(this1) {
	this1 = --this1 | 0;
	return this1;
};
haxe_Int32.postDecrement = function(this1) {
	var ret = this1--;
	this1 |= 0;
	return ret;
};
haxe_Int32.add = function(a,b) {
	return a + b | 0;
};
haxe_Int32.addInt = function(a,b) {
	return a + b | 0;
};
haxe_Int32.sub = function(a,b) {
	return a - b | 0;
};
haxe_Int32.subInt = function(a,b) {
	return a - b | 0;
};
haxe_Int32.intSub = function(a,b) {
	return a - b | 0;
};
haxe_Int32.mul = function(a,b) {
	return haxe_Int32._mul(a,b);
};
haxe_Int32.mulInt = function(a,b) {
	return haxe_Int32._mul(a,b);
};
haxe_Int32.toFloat = function(this1) {
	return this1;
};
haxe_Int32.ucompare = function(a,b) {
	if(a < 0) {
		if(b < 0) {
			return ~b - ~a | 0;
		} else {
			return 1;
		}
	}
	if(b < 0) {
		return -1;
	} else {
		return a - b | 0;
	}
};
haxe_Int32.clamp = function(x) {
	return x | 0;
};
var haxe_Int64 = {};
haxe_Int64.__properties__ = {get_low:"get_low",get_high:"get_high"};
haxe_Int64._new = function(x) {
	var this1 = x;
	return this1;
};
haxe_Int64.copy = function(this1) {
	var this2 = new haxe__$Int64__$_$_$Int64(this1.high,this1.low);
	return this2;
};
haxe_Int64.make = function(high,low) {
	var this1 = new haxe__$Int64__$_$_$Int64(high,low);
	return this1;
};
haxe_Int64.ofInt = function(x) {
	var this1 = new haxe__$Int64__$_$_$Int64(x >> 31,x);
	return this1;
};
haxe_Int64.toInt = function(x) {
	if(x.high != x.low >> 31) {
		throw haxe_Exception.thrown("Overflow");
	}
	return x.low;
};
haxe_Int64.is = function(val) {
	return ((val) instanceof haxe__$Int64__$_$_$Int64);
};
haxe_Int64.isInt64 = function(val) {
	return ((val) instanceof haxe__$Int64__$_$_$Int64);
};
haxe_Int64.getHigh = function(x) {
	return x.high;
};
haxe_Int64.getLow = function(x) {
	return x.low;
};
haxe_Int64.isNeg = function(x) {
	return x.high < 0;
};
haxe_Int64.isZero = function(x) {
	var b_high = 0;
	var b_low = 0;
	if(x.high == b_high) {
		return x.low == b_low;
	} else {
		return false;
	}
};
haxe_Int64.compare = function(a,b) {
	var v = a.high - b.high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a.low,b.low);
	}
	if(a.high < 0) {
		if(b.high < 0) {
			return v;
		} else {
			return -1;
		}
	} else if(b.high >= 0) {
		return v;
	} else {
		return 1;
	}
};
haxe_Int64.ucompare = function(a,b) {
	var v = haxe_Int32.ucompare(a.high,b.high);
	if(v != 0) {
		return v;
	} else {
		return haxe_Int32.ucompare(a.low,b.low);
	}
};
haxe_Int64.toStr = function(x) {
	return haxe_Int64.toString(x);
};
haxe_Int64.toString = function(this1) {
	var i = this1;
	var b_high = 0;
	var b_low = 0;
	if(i.high == b_high && i.low == b_low) {
		return "0";
	}
	var str = "";
	var neg = false;
	if(i.high < 0) {
		neg = true;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(0,10);
	var ten = this1;
	while(true) {
		var b_high = 0;
		var b_low = 0;
		if(!(i.high != b_high || i.low != b_low)) {
			break;
		}
		var r = haxe_Int64.divMod(i,ten);
		if(r.modulus.high < 0) {
			var x = r.modulus;
			var high = ~x.high;
			var low = ~x.low + 1 | 0;
			if(low == 0) {
				var ret = high++;
				high = high | 0;
			}
			var this_high = high;
			var this_low = low;
			str = this_low + str;
			var x1 = r.quotient;
			var high1 = ~x1.high;
			var low1 = ~x1.low + 1 | 0;
			if(low1 == 0) {
				var ret1 = high1++;
				high1 = high1 | 0;
			}
			var this1 = new haxe__$Int64__$_$_$Int64(high1,low1);
			i = this1;
		} else {
			str = r.modulus.low + str;
			i = r.quotient;
		}
	}
	if(neg) {
		str = "-" + str;
	}
	return str;
};
haxe_Int64.parseString = function(sParam) {
	return haxe_Int64Helper.parseString(sParam);
};
haxe_Int64.fromFloat = function(f) {
	return haxe_Int64Helper.fromFloat(f);
};
haxe_Int64.divMod = function(dividend,divisor) {
	if(divisor.high == 0) {
		switch(divisor.low) {
		case 0:
			throw haxe_Exception.thrown("divide by zero");
		case 1:
			var this1 = new haxe__$Int64__$_$_$Int64(dividend.high,dividend.low);
			var this2 = new haxe__$Int64__$_$_$Int64(0,0);
			return { quotient : this1, modulus : this2};
		}
	}
	var divSign = dividend.high < 0 != divisor.high < 0;
	var modulus;
	if(dividend.high < 0) {
		var high = ~dividend.high;
		var low = ~dividend.low + 1 | 0;
		if(low == 0) {
			var ret = high++;
			high = high | 0;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(high,low);
		modulus = this1;
	} else {
		var this1 = new haxe__$Int64__$_$_$Int64(dividend.high,dividend.low);
		modulus = this1;
	}
	if(divisor.high < 0) {
		var high = ~divisor.high;
		var low = ~divisor.low + 1 | 0;
		if(low == 0) {
			var ret = high++;
			high = high | 0;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(high,low);
		divisor = this1;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(0,0);
	var quotient = this1;
	var this1 = new haxe__$Int64__$_$_$Int64(0,1);
	var mask = this1;
	while(!(divisor.high < 0)) {
		var v = haxe_Int32.ucompare(divisor.high,modulus.high);
		var cmp = v != 0 ? v : haxe_Int32.ucompare(divisor.low,modulus.low);
		var b = 1;
		b &= 63;
		if(b == 0) {
			var this1 = new haxe__$Int64__$_$_$Int64(divisor.high,divisor.low);
			divisor = this1;
		} else if(b < 32) {
			var this2 = new haxe__$Int64__$_$_$Int64(divisor.high << b | divisor.low >>> 32 - b,divisor.low << b);
			divisor = this2;
		} else {
			var this3 = new haxe__$Int64__$_$_$Int64(divisor.low << b - 32,0);
			divisor = this3;
		}
		var b1 = 1;
		b1 &= 63;
		if(b1 == 0) {
			var this4 = new haxe__$Int64__$_$_$Int64(mask.high,mask.low);
			mask = this4;
		} else if(b1 < 32) {
			var this5 = new haxe__$Int64__$_$_$Int64(mask.high << b1 | mask.low >>> 32 - b1,mask.low << b1);
			mask = this5;
		} else {
			var this6 = new haxe__$Int64__$_$_$Int64(mask.low << b1 - 32,0);
			mask = this6;
		}
		if(cmp >= 0) {
			break;
		}
	}
	while(true) {
		var b_high = 0;
		var b_low = 0;
		if(!(mask.high != b_high || mask.low != b_low)) {
			break;
		}
		var v = haxe_Int32.ucompare(modulus.high,divisor.high);
		if((v != 0 ? v : haxe_Int32.ucompare(modulus.low,divisor.low)) >= 0) {
			var this1 = new haxe__$Int64__$_$_$Int64(quotient.high | mask.high,quotient.low | mask.low);
			quotient = this1;
			var high = modulus.high - divisor.high | 0;
			var low = modulus.low - divisor.low | 0;
			if(haxe_Int32.ucompare(modulus.low,divisor.low) < 0) {
				var ret = high--;
				high = high | 0;
			}
			var this2 = new haxe__$Int64__$_$_$Int64(high,low);
			modulus = this2;
		}
		var b = 1;
		b &= 63;
		if(b == 0) {
			var this3 = new haxe__$Int64__$_$_$Int64(mask.high,mask.low);
			mask = this3;
		} else if(b < 32) {
			var this4 = new haxe__$Int64__$_$_$Int64(mask.high >>> b,mask.high << 32 - b | mask.low >>> b);
			mask = this4;
		} else {
			var this5 = new haxe__$Int64__$_$_$Int64(0,mask.high >>> b - 32);
			mask = this5;
		}
		var b1 = 1;
		b1 &= 63;
		if(b1 == 0) {
			var this6 = new haxe__$Int64__$_$_$Int64(divisor.high,divisor.low);
			divisor = this6;
		} else if(b1 < 32) {
			var this7 = new haxe__$Int64__$_$_$Int64(divisor.high >>> b1,divisor.high << 32 - b1 | divisor.low >>> b1);
			divisor = this7;
		} else {
			var this8 = new haxe__$Int64__$_$_$Int64(0,divisor.high >>> b1 - 32);
			divisor = this8;
		}
	}
	if(divSign) {
		var high = ~quotient.high;
		var low = ~quotient.low + 1 | 0;
		if(low == 0) {
			var ret = high++;
			high = high | 0;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(high,low);
		quotient = this1;
	}
	if(dividend.high < 0) {
		var high = ~modulus.high;
		var low = ~modulus.low + 1 | 0;
		if(low == 0) {
			var ret = high++;
			high = high | 0;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(high,low);
		modulus = this1;
	}
	return { quotient : quotient, modulus : modulus};
};
haxe_Int64.neg = function(x) {
	var high = ~x.high;
	var low = ~x.low + 1 | 0;
	if(low == 0) {
		var ret = high++;
		high = high | 0;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(high,low);
	return this1;
};
haxe_Int64.preIncrement = function(this1) {
	var this2 = new haxe__$Int64__$_$_$Int64(this1.high,this1.low);
	this1 = this2;
	var ret = this1.low++;
	this1.low = this1.low | 0;
	if(this1.low == 0) {
		var ret = this1.high++;
		this1.high = this1.high | 0;
	}
	return this1;
};
haxe_Int64.postIncrement = function(this1) {
	var ret = this1;
	var this2 = new haxe__$Int64__$_$_$Int64(this1.high,this1.low);
	this1 = this2;
	var ret1 = this1.low++;
	this1.low = this1.low | 0;
	if(this1.low == 0) {
		var ret1 = this1.high++;
		this1.high = this1.high | 0;
	}
	return ret;
};
haxe_Int64.preDecrement = function(this1) {
	var this2 = new haxe__$Int64__$_$_$Int64(this1.high,this1.low);
	this1 = this2;
	if(this1.low == 0) {
		var ret = this1.high--;
		this1.high = this1.high | 0;
	}
	var ret = this1.low--;
	this1.low = this1.low | 0;
	return this1;
};
haxe_Int64.postDecrement = function(this1) {
	var ret = this1;
	var this2 = new haxe__$Int64__$_$_$Int64(this1.high,this1.low);
	this1 = this2;
	if(this1.low == 0) {
		var ret1 = this1.high--;
		this1.high = this1.high | 0;
	}
	var ret1 = this1.low--;
	this1.low = this1.low | 0;
	return ret;
};
haxe_Int64.add = function(a,b) {
	var high = a.high + b.high | 0;
	var low = a.low + b.low | 0;
	if(haxe_Int32.ucompare(low,a.low) < 0) {
		var ret = high++;
		high = high | 0;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(high,low);
	return this1;
};
haxe_Int64.addInt = function(a,b) {
	var b_high = b >> 31;
	var b_low = b;
	var high = a.high + b_high | 0;
	var low = a.low + b_low | 0;
	if(haxe_Int32.ucompare(low,a.low) < 0) {
		var ret = high++;
		high = high | 0;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(high,low);
	return this1;
};
haxe_Int64.sub = function(a,b) {
	var high = a.high - b.high | 0;
	var low = a.low - b.low | 0;
	if(haxe_Int32.ucompare(a.low,b.low) < 0) {
		var ret = high--;
		high = high | 0;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(high,low);
	return this1;
};
haxe_Int64.subInt = function(a,b) {
	var b_high = b >> 31;
	var b_low = b;
	var high = a.high - b_high | 0;
	var low = a.low - b_low | 0;
	if(haxe_Int32.ucompare(a.low,b_low) < 0) {
		var ret = high--;
		high = high | 0;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(high,low);
	return this1;
};
haxe_Int64.intSub = function(a,b) {
	var a_high = a >> 31;
	var a_low = a;
	var high = a_high - b.high | 0;
	var low = a_low - b.low | 0;
	if(haxe_Int32.ucompare(a_low,b.low) < 0) {
		var ret = high--;
		high = high | 0;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(high,low);
	return this1;
};
haxe_Int64.mul = function(a,b) {
	var mask = 65535;
	var al = a.low & mask;
	var ah = a.low >>> 16;
	var bl = b.low & mask;
	var bh = b.low >>> 16;
	var p00 = haxe_Int32._mul(al,bl);
	var p10 = haxe_Int32._mul(ah,bl);
	var p01 = haxe_Int32._mul(al,bh);
	var p11 = haxe_Int32._mul(ah,bh);
	var low = p00;
	var high = (p11 + (p01 >>> 16) | 0) + (p10 >>> 16) | 0;
	p01 <<= 16;
	low = low + p01 | 0;
	if(haxe_Int32.ucompare(low,p01) < 0) {
		var ret = high++;
		high = high | 0;
	}
	p10 <<= 16;
	low = low + p10 | 0;
	if(haxe_Int32.ucompare(low,p10) < 0) {
		var ret = high++;
		high = high | 0;
	}
	high = high + (haxe_Int32._mul(a.low,b.high) + haxe_Int32._mul(a.high,b.low) | 0) | 0;
	var this1 = new haxe__$Int64__$_$_$Int64(high,low);
	return this1;
};
haxe_Int64.mulInt = function(a,b) {
	var b_high = b >> 31;
	var b_low = b;
	var mask = 65535;
	var al = a.low & mask;
	var ah = a.low >>> 16;
	var bl = b_low & mask;
	var bh = b_low >>> 16;
	var p00 = haxe_Int32._mul(al,bl);
	var p10 = haxe_Int32._mul(ah,bl);
	var p01 = haxe_Int32._mul(al,bh);
	var p11 = haxe_Int32._mul(ah,bh);
	var low = p00;
	var high = (p11 + (p01 >>> 16) | 0) + (p10 >>> 16) | 0;
	p01 <<= 16;
	low = low + p01 | 0;
	if(haxe_Int32.ucompare(low,p01) < 0) {
		var ret = high++;
		high = high | 0;
	}
	p10 <<= 16;
	low = low + p10 | 0;
	if(haxe_Int32.ucompare(low,p10) < 0) {
		var ret = high++;
		high = high | 0;
	}
	high = high + (haxe_Int32._mul(a.low,b_high) + haxe_Int32._mul(a.high,b_low) | 0) | 0;
	var this1 = new haxe__$Int64__$_$_$Int64(high,low);
	return this1;
};
haxe_Int64.div = function(a,b) {
	return haxe_Int64.divMod(a,b).quotient;
};
haxe_Int64.divInt = function(a,b) {
	var this1 = new haxe__$Int64__$_$_$Int64(b >> 31,b);
	return haxe_Int64.divMod(a,this1).quotient;
};
haxe_Int64.intDiv = function(a,b) {
	var this1 = new haxe__$Int64__$_$_$Int64(a >> 31,a);
	var x = haxe_Int64.divMod(this1,b).quotient;
	if(x.high != x.low >> 31) {
		throw haxe_Exception.thrown("Overflow");
	}
	var x1 = x.low;
	var this1 = new haxe__$Int64__$_$_$Int64(x1 >> 31,x1);
	return this1;
};
haxe_Int64.mod = function(a,b) {
	return haxe_Int64.divMod(a,b).modulus;
};
haxe_Int64.modInt = function(a,b) {
	var this1 = new haxe__$Int64__$_$_$Int64(b >> 31,b);
	var x = haxe_Int64.divMod(a,this1).modulus;
	if(x.high != x.low >> 31) {
		throw haxe_Exception.thrown("Overflow");
	}
	var x1 = x.low;
	var this1 = new haxe__$Int64__$_$_$Int64(x1 >> 31,x1);
	return this1;
};
haxe_Int64.intMod = function(a,b) {
	var this1 = new haxe__$Int64__$_$_$Int64(a >> 31,a);
	var x = haxe_Int64.divMod(this1,b).modulus;
	if(x.high != x.low >> 31) {
		throw haxe_Exception.thrown("Overflow");
	}
	var x1 = x.low;
	var this1 = new haxe__$Int64__$_$_$Int64(x1 >> 31,x1);
	return this1;
};
haxe_Int64.eq = function(a,b) {
	if(a.high == b.high) {
		return a.low == b.low;
	} else {
		return false;
	}
};
haxe_Int64.eqInt = function(a,b) {
	var b_high = b >> 31;
	var b_low = b;
	if(a.high == b_high) {
		return a.low == b_low;
	} else {
		return false;
	}
};
haxe_Int64.neq = function(a,b) {
	if(a.high == b.high) {
		return a.low != b.low;
	} else {
		return true;
	}
};
haxe_Int64.neqInt = function(a,b) {
	var b_high = b >> 31;
	var b_low = b;
	if(a.high == b_high) {
		return a.low != b_low;
	} else {
		return true;
	}
};
haxe_Int64.lt = function(a,b) {
	var v = a.high - b.high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a.low,b.low);
	}
	return (a.high < 0 ? b.high < 0 ? v : -1 : b.high >= 0 ? v : 1) < 0;
};
haxe_Int64.ltInt = function(a,b) {
	var b_high = b >> 31;
	var b_low = b;
	var v = a.high - b_high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a.low,b_low);
	}
	return (a.high < 0 ? b_high < 0 ? v : -1 : b_high >= 0 ? v : 1) < 0;
};
haxe_Int64.intLt = function(a,b) {
	var a_high = a >> 31;
	var a_low = a;
	var v = a_high - b.high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a_low,b.low);
	}
	return (a_high < 0 ? b.high < 0 ? v : -1 : b.high >= 0 ? v : 1) < 0;
};
haxe_Int64.lte = function(a,b) {
	var v = a.high - b.high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a.low,b.low);
	}
	return (a.high < 0 ? b.high < 0 ? v : -1 : b.high >= 0 ? v : 1) <= 0;
};
haxe_Int64.lteInt = function(a,b) {
	var b_high = b >> 31;
	var b_low = b;
	var v = a.high - b_high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a.low,b_low);
	}
	return (a.high < 0 ? b_high < 0 ? v : -1 : b_high >= 0 ? v : 1) <= 0;
};
haxe_Int64.intLte = function(a,b) {
	var a_high = a >> 31;
	var a_low = a;
	var v = a_high - b.high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a_low,b.low);
	}
	return (a_high < 0 ? b.high < 0 ? v : -1 : b.high >= 0 ? v : 1) <= 0;
};
haxe_Int64.gt = function(a,b) {
	var v = a.high - b.high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a.low,b.low);
	}
	return (a.high < 0 ? b.high < 0 ? v : -1 : b.high >= 0 ? v : 1) > 0;
};
haxe_Int64.gtInt = function(a,b) {
	var b_high = b >> 31;
	var b_low = b;
	var v = a.high - b_high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a.low,b_low);
	}
	return (a.high < 0 ? b_high < 0 ? v : -1 : b_high >= 0 ? v : 1) > 0;
};
haxe_Int64.intGt = function(a,b) {
	var a_high = a >> 31;
	var a_low = a;
	var v = a_high - b.high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a_low,b.low);
	}
	return (a_high < 0 ? b.high < 0 ? v : -1 : b.high >= 0 ? v : 1) > 0;
};
haxe_Int64.gte = function(a,b) {
	var v = a.high - b.high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a.low,b.low);
	}
	return (a.high < 0 ? b.high < 0 ? v : -1 : b.high >= 0 ? v : 1) >= 0;
};
haxe_Int64.gteInt = function(a,b) {
	var b_high = b >> 31;
	var b_low = b;
	var v = a.high - b_high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a.low,b_low);
	}
	return (a.high < 0 ? b_high < 0 ? v : -1 : b_high >= 0 ? v : 1) >= 0;
};
haxe_Int64.intGte = function(a,b) {
	var a_high = a >> 31;
	var a_low = a;
	var v = a_high - b.high | 0;
	if(v == 0) {
		v = haxe_Int32.ucompare(a_low,b.low);
	}
	return (a_high < 0 ? b.high < 0 ? v : -1 : b.high >= 0 ? v : 1) >= 0;
};
haxe_Int64.complement = function(a) {
	var this1 = new haxe__$Int64__$_$_$Int64(~a.high,~a.low);
	return this1;
};
haxe_Int64.and = function(a,b) {
	var this1 = new haxe__$Int64__$_$_$Int64(a.high & b.high,a.low & b.low);
	return this1;
};
haxe_Int64.or = function(a,b) {
	var this1 = new haxe__$Int64__$_$_$Int64(a.high | b.high,a.low | b.low);
	return this1;
};
haxe_Int64.xor = function(a,b) {
	var this1 = new haxe__$Int64__$_$_$Int64(a.high ^ b.high,a.low ^ b.low);
	return this1;
};
haxe_Int64.shl = function(a,b) {
	b &= 63;
	if(b == 0) {
		var this1 = new haxe__$Int64__$_$_$Int64(a.high,a.low);
		return this1;
	} else if(b < 32) {
		var this1 = new haxe__$Int64__$_$_$Int64(a.high << b | a.low >>> 32 - b,a.low << b);
		return this1;
	} else {
		var this1 = new haxe__$Int64__$_$_$Int64(a.low << b - 32,0);
		return this1;
	}
};
haxe_Int64.shr = function(a,b) {
	b &= 63;
	if(b == 0) {
		var this1 = new haxe__$Int64__$_$_$Int64(a.high,a.low);
		return this1;
	} else if(b < 32) {
		var this1 = new haxe__$Int64__$_$_$Int64(a.high >> b,a.high << 32 - b | a.low >>> b);
		return this1;
	} else {
		var this1 = new haxe__$Int64__$_$_$Int64(a.high >> 31,a.high >> b - 32);
		return this1;
	}
};
haxe_Int64.ushr = function(a,b) {
	b &= 63;
	if(b == 0) {
		var this1 = new haxe__$Int64__$_$_$Int64(a.high,a.low);
		return this1;
	} else if(b < 32) {
		var this1 = new haxe__$Int64__$_$_$Int64(a.high >>> b,a.high << 32 - b | a.low >>> b);
		return this1;
	} else {
		var this1 = new haxe__$Int64__$_$_$Int64(0,a.high >>> b - 32);
		return this1;
	}
};
haxe_Int64.get_high = function(this1) {
	return this1.high;
};
haxe_Int64.set_high = function(this1,x) {
	return this1.high = x;
};
haxe_Int64.get_low = function(this1) {
	return this1.low;
};
haxe_Int64.set_low = function(this1,x) {
	return this1.low = x;
};
var haxe__$Int64__$_$_$Int64 = function(high,low) {
	this.high = high;
	this.low = low;
};
$hxClasses["haxe._Int64.___Int64"] = haxe__$Int64__$_$_$Int64;
haxe__$Int64__$_$_$Int64.__name__ = "haxe._Int64.___Int64";
haxe__$Int64__$_$_$Int64.prototype = {
	high: null
	,low: null
	,toString: function() {
		return haxe_Int64.toString(this);
	}
	,__class__: haxe__$Int64__$_$_$Int64
};
var haxe_Int64Helper = function() { };
$hxClasses["haxe.Int64Helper"] = haxe_Int64Helper;
haxe_Int64Helper.__name__ = "haxe.Int64Helper";
haxe_Int64Helper.parseString = function(sParam) {
	var base_high = 0;
	var base_low = 10;
	var this1 = new haxe__$Int64__$_$_$Int64(0,0);
	var current = this1;
	var this1 = new haxe__$Int64__$_$_$Int64(0,1);
	var multiplier = this1;
	var sIsNegative = false;
	var s = StringTools.trim(sParam);
	if(s.charAt(0) == "-") {
		sIsNegative = true;
		s = s.substring(1,s.length);
	}
	var len = s.length;
	var _g = 0;
	var _g1 = len;
	while(_g < _g1) {
		var i = _g++;
		var digitInt = HxOverrides.cca(s,len - 1 - i) - 48;
		if(digitInt < 0 || digitInt > 9) {
			throw haxe_Exception.thrown("NumberFormatError");
		}
		if(digitInt != 0) {
			var digit_high = digitInt >> 31;
			var digit_low = digitInt;
			if(sIsNegative) {
				var mask = 65535;
				var al = multiplier.low & mask;
				var ah = multiplier.low >>> 16;
				var bl = digit_low & mask;
				var bh = digit_low >>> 16;
				var p00 = haxe_Int32._mul(al,bl);
				var p10 = haxe_Int32._mul(ah,bl);
				var p01 = haxe_Int32._mul(al,bh);
				var p11 = haxe_Int32._mul(ah,bh);
				var low = p00;
				var high = (p11 + (p01 >>> 16) | 0) + (p10 >>> 16) | 0;
				p01 <<= 16;
				low = low + p01 | 0;
				if(haxe_Int32.ucompare(low,p01) < 0) {
					var ret = high++;
					high = high | 0;
				}
				p10 <<= 16;
				low = low + p10 | 0;
				if(haxe_Int32.ucompare(low,p10) < 0) {
					var ret1 = high++;
					high = high | 0;
				}
				high = high + (haxe_Int32._mul(multiplier.low,digit_high) + haxe_Int32._mul(multiplier.high,digit_low) | 0) | 0;
				var b_high = high;
				var b_low = low;
				var high1 = current.high - b_high | 0;
				var low1 = current.low - b_low | 0;
				if(haxe_Int32.ucompare(current.low,b_low) < 0) {
					var ret2 = high1--;
					high1 = high1 | 0;
				}
				var this1 = new haxe__$Int64__$_$_$Int64(high1,low1);
				current = this1;
				if(!(current.high < 0)) {
					throw haxe_Exception.thrown("NumberFormatError: Underflow");
				}
			} else {
				var mask1 = 65535;
				var al1 = multiplier.low & mask1;
				var ah1 = multiplier.low >>> 16;
				var bl1 = digit_low & mask1;
				var bh1 = digit_low >>> 16;
				var p001 = haxe_Int32._mul(al1,bl1);
				var p101 = haxe_Int32._mul(ah1,bl1);
				var p011 = haxe_Int32._mul(al1,bh1);
				var p111 = haxe_Int32._mul(ah1,bh1);
				var low2 = p001;
				var high2 = (p111 + (p011 >>> 16) | 0) + (p101 >>> 16) | 0;
				p011 <<= 16;
				low2 = low2 + p011 | 0;
				if(haxe_Int32.ucompare(low2,p011) < 0) {
					var ret3 = high2++;
					high2 = high2 | 0;
				}
				p101 <<= 16;
				low2 = low2 + p101 | 0;
				if(haxe_Int32.ucompare(low2,p101) < 0) {
					var ret4 = high2++;
					high2 = high2 | 0;
				}
				high2 = high2 + (haxe_Int32._mul(multiplier.low,digit_high) + haxe_Int32._mul(multiplier.high,digit_low) | 0) | 0;
				var b_high1 = high2;
				var b_low1 = low2;
				var high3 = current.high + b_high1 | 0;
				var low3 = current.low + b_low1 | 0;
				if(haxe_Int32.ucompare(low3,current.low) < 0) {
					var ret5 = high3++;
					high3 = high3 | 0;
				}
				var this2 = new haxe__$Int64__$_$_$Int64(high3,low3);
				current = this2;
				if(current.high < 0) {
					throw haxe_Exception.thrown("NumberFormatError: Overflow");
				}
			}
		}
		var mask2 = 65535;
		var al2 = multiplier.low & mask2;
		var ah2 = multiplier.low >>> 16;
		var bl2 = base_low & mask2;
		var bh2 = base_low >>> 16;
		var p002 = haxe_Int32._mul(al2,bl2);
		var p102 = haxe_Int32._mul(ah2,bl2);
		var p012 = haxe_Int32._mul(al2,bh2);
		var p112 = haxe_Int32._mul(ah2,bh2);
		var low4 = p002;
		var high4 = (p112 + (p012 >>> 16) | 0) + (p102 >>> 16) | 0;
		p012 <<= 16;
		low4 = low4 + p012 | 0;
		if(haxe_Int32.ucompare(low4,p012) < 0) {
			var ret6 = high4++;
			high4 = high4 | 0;
		}
		p102 <<= 16;
		low4 = low4 + p102 | 0;
		if(haxe_Int32.ucompare(low4,p102) < 0) {
			var ret7 = high4++;
			high4 = high4 | 0;
		}
		high4 = high4 + (haxe_Int32._mul(multiplier.low,base_high) + haxe_Int32._mul(multiplier.high,base_low) | 0) | 0;
		var this3 = new haxe__$Int64__$_$_$Int64(high4,low4);
		multiplier = this3;
	}
	return current;
};
haxe_Int64Helper.fromFloat = function(f) {
	if(isNaN(f) || !isFinite(f)) {
		throw haxe_Exception.thrown("Number is NaN or Infinite");
	}
	var noFractions = f - f % 1;
	if(noFractions > 9007199254740991) {
		throw haxe_Exception.thrown("Conversion overflow");
	}
	if(noFractions < -9007199254740991) {
		throw haxe_Exception.thrown("Conversion underflow");
	}
	var this1 = new haxe__$Int64__$_$_$Int64(0,0);
	var result = this1;
	var neg = noFractions < 0;
	var rest = neg ? -noFractions : noFractions;
	var i = 0;
	while(rest >= 1) {
		var curr = rest % 2;
		rest /= 2;
		if(curr >= 1) {
			var a_high = 0;
			var a_low = 1;
			var b = i;
			b &= 63;
			var b1;
			if(b == 0) {
				var this1 = new haxe__$Int64__$_$_$Int64(a_high,a_low);
				b1 = this1;
			} else if(b < 32) {
				var this2 = new haxe__$Int64__$_$_$Int64(a_high << b | a_low >>> 32 - b,a_low << b);
				b1 = this2;
			} else {
				var this3 = new haxe__$Int64__$_$_$Int64(a_low << b - 32,0);
				b1 = this3;
			}
			var high = result.high + b1.high | 0;
			var low = result.low + b1.low | 0;
			if(haxe_Int32.ucompare(low,result.low) < 0) {
				var ret = high++;
				high = high | 0;
			}
			var this4 = new haxe__$Int64__$_$_$Int64(high,low);
			result = this4;
		}
		++i;
	}
	if(neg) {
		var high = ~result.high;
		var low = ~result.low + 1 | 0;
		if(low == 0) {
			var ret = high++;
			high = high | 0;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(high,low);
		result = this1;
	}
	return result;
};
var haxe_Log = function() { };
$hxClasses["haxe.Log"] = haxe_Log;
haxe_Log.__name__ = "haxe.Log";
haxe_Log.formatOutput = function(v,infos) {
	var str = Std.string(v);
	if(infos == null) {
		return str;
	}
	var pstr = infos.fileName + ":" + infos.lineNumber;
	if(infos.customParams != null) {
		var _g = 0;
		var _g1 = infos.customParams;
		while(_g < _g1.length) {
			var v = _g1[_g];
			++_g;
			str += ", " + Std.string(v);
		}
	}
	return pstr + ": " + str;
};
haxe_Log.trace = function(v,infos) {
	var str = haxe_Log.formatOutput(v,infos);
	if(typeof(console) != "undefined" && console.log != null) {
		console.log(str);
	}
};
var haxe_NativeStackTrace = function() { };
$hxClasses["haxe.NativeStackTrace"] = haxe_NativeStackTrace;
haxe_NativeStackTrace.__name__ = "haxe.NativeStackTrace";
haxe_NativeStackTrace.lastError = null;
haxe_NativeStackTrace.wrapCallSite = null;
haxe_NativeStackTrace.saveStack = function(e) {
	haxe_NativeStackTrace.lastError = e;
};
haxe_NativeStackTrace.callStack = function() {
	var e = new Error("");
	var stack = haxe_NativeStackTrace.tryHaxeStack(e);
	if(typeof(stack) == "undefined") {
		try {
			throw e;
		} catch( _g ) {
		}
		stack = e.stack;
	}
	return haxe_NativeStackTrace.normalize(stack,2);
};
haxe_NativeStackTrace.exceptionStack = function() {
	return haxe_NativeStackTrace.normalize(haxe_NativeStackTrace.tryHaxeStack(haxe_NativeStackTrace.lastError));
};
haxe_NativeStackTrace.toHaxe = function(s,skip) {
	if(skip == null) {
		skip = 0;
	}
	if(s == null) {
		return [];
	} else if(typeof(s) == "string") {
		var stack = s.split("\n");
		if(stack[0] == "Error") {
			stack.shift();
		}
		var m = [];
		var _g = 0;
		var _g1 = stack.length;
		while(_g < _g1) {
			var i = _g++;
			if(skip > i) {
				continue;
			}
			var line = stack[i];
			var matched = line.match(/^    at ([A-Za-z0-9_. ]+) \(([^)]+):([0-9]+):([0-9]+)\)$/);
			if(matched != null) {
				var path = matched[1].split(".");
				if(path[0] == "$hxClasses") {
					path.shift();
				}
				var meth = path.pop();
				var file = matched[2];
				var line1 = Std.parseInt(matched[3]);
				var column = Std.parseInt(matched[4]);
				m.push(haxe_StackItem.FilePos(meth == "Anonymous function" ? haxe_StackItem.LocalFunction() : meth == "Global code" ? null : haxe_StackItem.Method(path.join("."),meth),file,line1,column));
			} else {
				m.push(haxe_StackItem.Module(StringTools.trim(line)));
			}
		}
		return m;
	} else if(skip > 0 && Array.isArray(s)) {
		return s.slice(skip);
	} else {
		return s;
	}
};
haxe_NativeStackTrace.tryHaxeStack = function(e) {
	if(e == null) {
		return [];
	}
	var oldValue = Error.prepareStackTrace;
	Error.prepareStackTrace = haxe_NativeStackTrace.prepareHxStackTrace;
	var stack = e.stack;
	Error.prepareStackTrace = oldValue;
	return stack;
};
haxe_NativeStackTrace.prepareHxStackTrace = function(e,callsites) {
	var stack = [];
	var _g = 0;
	while(_g < callsites.length) {
		var site = callsites[_g];
		++_g;
		if(haxe_NativeStackTrace.wrapCallSite != null) {
			site = haxe_NativeStackTrace.wrapCallSite(site);
		}
		var method = null;
		var fullName = site.getFunctionName();
		if(fullName != null) {
			var idx = fullName.lastIndexOf(".");
			if(idx >= 0) {
				var className = fullName.substring(0,idx);
				var methodName = fullName.substring(idx + 1);
				method = haxe_StackItem.Method(className,methodName);
			} else {
				method = haxe_StackItem.Method(null,fullName);
			}
		}
		var fileName = site.getFileName();
		var fileAddr = fileName == null ? -1 : fileName.indexOf("file:");
		if(haxe_NativeStackTrace.wrapCallSite != null && fileAddr > 0) {
			fileName = fileName.substring(fileAddr + 6);
		}
		stack.push(haxe_StackItem.FilePos(method,fileName,site.getLineNumber(),site.getColumnNumber()));
	}
	return stack;
};
haxe_NativeStackTrace.normalize = function(stack,skipItems) {
	if(skipItems == null) {
		skipItems = 0;
	}
	if(Array.isArray(stack) && skipItems > 0) {
		return stack.slice(skipItems);
	} else if(typeof(stack) == "string") {
		switch(stack.substring(0,6)) {
		case "Error\n":case "Error:":
			++skipItems;
			break;
		default:
		}
		return haxe_NativeStackTrace.skipLines(stack,skipItems);
	} else {
		return stack;
	}
};
haxe_NativeStackTrace.skipLines = function(stack,skip,pos) {
	if(pos == null) {
		pos = 0;
	}
	if(skip > 0) {
		pos = stack.indexOf("\n",pos);
		if(pos < 0) {
			return "";
		} else {
			return haxe_NativeStackTrace.skipLines(stack,--skip,pos + 1);
		}
	} else {
		return stack.substring(pos);
	}
};
var haxe_Rest = {};
haxe_Rest.__properties__ = {get_length:"get_length"};
haxe_Rest.get_length = function(this1) {
	return this1.length;
};
haxe_Rest.of = function(array) {
	var this1 = array;
	return this1;
};
haxe_Rest._new = function(array) {
	var this1 = array;
	return this1;
};
haxe_Rest.get = function(this1,index) {
	return this1[index];
};
haxe_Rest.toArray = function(this1) {
	return this1.slice();
};
haxe_Rest.iterator = function(this1) {
	return new haxe_iterators_RestIterator(this1);
};
haxe_Rest.keyValueIterator = function(this1) {
	return new haxe_iterators_RestKeyValueIterator(this1);
};
haxe_Rest.append = function(this1,item) {
	var result = this1.slice();
	result.push(item);
	var this1 = result;
	return this1;
};
haxe_Rest.prepend = function(this1,item) {
	var result = this1.slice();
	result.unshift(item);
	var this1 = result;
	return this1;
};
haxe_Rest.toString = function(this1) {
	return "[" + this1.toString() + "]";
};
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
	this.__skipStack++;
};
$hxClasses["haxe.ValueException"] = haxe_ValueException;
haxe_ValueException.__name__ = "haxe.ValueException";
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
	value: null
	,unwrap: function() {
		return this.value;
	}
	,__class__: haxe_ValueException
});
var haxe_crypto_Sha1 = function() {
};
$hxClasses["haxe.crypto.Sha1"] = haxe_crypto_Sha1;
haxe_crypto_Sha1.__name__ = "haxe.crypto.Sha1";
haxe_crypto_Sha1.encode = function(s) {
	var sh = new haxe_crypto_Sha1();
	var h = sh.doEncode(haxe_crypto_Sha1.str2blks(s));
	return sh.hex(h);
};
haxe_crypto_Sha1.make = function(b) {
	var h = new haxe_crypto_Sha1().doEncode(haxe_crypto_Sha1.bytes2blks(b));
	var out = new haxe_io_Bytes(new ArrayBuffer(20));
	var p = 0;
	out.b[p++] = h[0] >>> 24;
	out.b[p++] = h[0] >> 16 & 255;
	out.b[p++] = h[0] >> 8 & 255;
	out.b[p++] = h[0] & 255;
	out.b[p++] = h[1] >>> 24;
	out.b[p++] = h[1] >> 16 & 255;
	out.b[p++] = h[1] >> 8 & 255;
	out.b[p++] = h[1] & 255;
	out.b[p++] = h[2] >>> 24;
	out.b[p++] = h[2] >> 16 & 255;
	out.b[p++] = h[2] >> 8 & 255;
	out.b[p++] = h[2] & 255;
	out.b[p++] = h[3] >>> 24;
	out.b[p++] = h[3] >> 16 & 255;
	out.b[p++] = h[3] >> 8 & 255;
	out.b[p++] = h[3] & 255;
	out.b[p++] = h[4] >>> 24;
	out.b[p++] = h[4] >> 16 & 255;
	out.b[p++] = h[4] >> 8 & 255;
	out.b[p++] = h[4] & 255;
	return out;
};
haxe_crypto_Sha1.str2blks = function(s) {
	var s1 = haxe_io_Bytes.ofString(s);
	var nblk = (s1.length + 8 >> 6) + 1;
	var blks = [];
	var _g = 0;
	var _g1 = nblk * 16;
	while(_g < _g1) {
		var i = _g++;
		blks[i] = 0;
	}
	var _g = 0;
	var _g1 = s1.length;
	while(_g < _g1) {
		var i = _g++;
		var p = i >> 2;
		blks[p] |= s1.b[i] << 24 - ((i & 3) << 3);
	}
	var i = s1.length;
	var p = i >> 2;
	blks[p] |= 128 << 24 - ((i & 3) << 3);
	blks[nblk * 16 - 1] = s1.length * 8;
	return blks;
};
haxe_crypto_Sha1.bytes2blks = function(b) {
	var nblk = (b.length + 8 >> 6) + 1;
	var blks = [];
	var _g = 0;
	var _g1 = nblk * 16;
	while(_g < _g1) {
		var i = _g++;
		blks[i] = 0;
	}
	var _g = 0;
	var _g1 = b.length;
	while(_g < _g1) {
		var i = _g++;
		var p = i >> 2;
		blks[p] |= b.b[i] << 24 - ((i & 3) << 3);
	}
	var i = b.length;
	var p = i >> 2;
	blks[p] |= 128 << 24 - ((i & 3) << 3);
	blks[nblk * 16 - 1] = b.length * 8;
	return blks;
};
haxe_crypto_Sha1.prototype = {
	doEncode: function(x) {
		var w = [];
		var a = 1732584193;
		var b = -271733879;
		var c = -1732584194;
		var d = 271733878;
		var e = -1009589776;
		var i = 0;
		while(i < x.length) {
			var olda = a;
			var oldb = b;
			var oldc = c;
			var oldd = d;
			var olde = e;
			var j = 0;
			while(j < 80) {
				if(j < 16) {
					w[j] = x[i + j];
				} else {
					var num = w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16];
					w[j] = num << 1 | num >>> 31;
				}
				var t = (a << 5 | a >>> 27) + this.ft(j,b,c,d) + e + w[j] + this.kt(j);
				e = d;
				d = c;
				c = b << 30 | b >>> 2;
				b = a;
				a = t;
				++j;
			}
			a += olda;
			b += oldb;
			c += oldc;
			d += oldd;
			e += olde;
			i += 16;
		}
		return [a,b,c,d,e];
	}
	,rol: function(num,cnt) {
		return num << cnt | num >>> 32 - cnt;
	}
	,ft: function(t,b,c,d) {
		if(t < 20) {
			return b & c | ~b & d;
		}
		if(t < 40) {
			return b ^ c ^ d;
		}
		if(t < 60) {
			return b & c | b & d | c & d;
		}
		return b ^ c ^ d;
	}
	,kt: function(t) {
		if(t < 20) {
			return 1518500249;
		}
		if(t < 40) {
			return 1859775393;
		}
		if(t < 60) {
			return -1894007588;
		}
		return -899497514;
	}
	,hex: function(a) {
		var str = "";
		var _g = 0;
		while(_g < a.length) {
			var num = a[_g];
			++_g;
			str += StringTools.hex(num,8);
		}
		return str.toLowerCase();
	}
	,__class__: haxe_crypto_Sha1
};
var haxe_ds_ArraySort = function() { };
$hxClasses["haxe.ds.ArraySort"] = haxe_ds_ArraySort;
haxe_ds_ArraySort.__name__ = "haxe.ds.ArraySort";
haxe_ds_ArraySort.sort = function(a,cmp) {
	haxe_ds_ArraySort.rec(a,cmp,0,a.length);
};
haxe_ds_ArraySort.rec = function(a,cmp,from,to) {
	var middle = from + to >> 1;
	if(to - from < 12) {
		if(to <= from) {
			return;
		}
		var _g = from + 1;
		var _g1 = to;
		while(_g < _g1) {
			var i = _g++;
			var j = i;
			while(j > from) {
				if(cmp(a[j],a[j - 1]) < 0) {
					haxe_ds_ArraySort.swap(a,j - 1,j);
				} else {
					break;
				}
				--j;
			}
		}
		return;
	}
	haxe_ds_ArraySort.rec(a,cmp,from,middle);
	haxe_ds_ArraySort.rec(a,cmp,middle,to);
	haxe_ds_ArraySort.doMerge(a,cmp,from,middle,to,middle - from,to - middle);
};
haxe_ds_ArraySort.doMerge = function(a,cmp,from,pivot,to,len1,len2) {
	var first_cut;
	var second_cut;
	var len11;
	var len22;
	if(len1 == 0 || len2 == 0) {
		return;
	}
	if(len1 + len2 == 2) {
		if(cmp(a[pivot],a[from]) < 0) {
			haxe_ds_ArraySort.swap(a,pivot,from);
		}
		return;
	}
	if(len1 > len2) {
		len11 = len1 >> 1;
		first_cut = from + len11;
		second_cut = haxe_ds_ArraySort.lower(a,cmp,pivot,to,first_cut);
		len22 = second_cut - pivot;
	} else {
		len22 = len2 >> 1;
		second_cut = pivot + len22;
		first_cut = haxe_ds_ArraySort.upper(a,cmp,from,pivot,second_cut);
		len11 = first_cut - from;
	}
	haxe_ds_ArraySort.rotate(a,cmp,first_cut,pivot,second_cut);
	var new_mid = first_cut + len22;
	haxe_ds_ArraySort.doMerge(a,cmp,from,first_cut,new_mid,len11,len22);
	haxe_ds_ArraySort.doMerge(a,cmp,new_mid,second_cut,to,len1 - len11,len2 - len22);
};
haxe_ds_ArraySort.rotate = function(a,cmp,from,mid,to) {
	if(from == mid || mid == to) {
		return;
	}
	var n = haxe_ds_ArraySort.gcd(to - from,mid - from);
	while(n-- != 0) {
		var val = a[from + n];
		var shift = mid - from;
		var p1 = from + n;
		var p2 = from + n + shift;
		while(p2 != from + n) {
			a[p1] = a[p2];
			p1 = p2;
			if(to - p2 > shift) {
				p2 += shift;
			} else {
				p2 = from + (shift - (to - p2));
			}
		}
		a[p1] = val;
	}
};
haxe_ds_ArraySort.gcd = function(m,n) {
	while(n != 0) {
		var t = m % n;
		m = n;
		n = t;
	}
	return m;
};
haxe_ds_ArraySort.upper = function(a,cmp,from,to,val) {
	var len = to - from;
	var half;
	var mid;
	while(len > 0) {
		half = len >> 1;
		mid = from + half;
		if(cmp(a[val],a[mid]) < 0) {
			len = half;
		} else {
			from = mid + 1;
			len = len - half - 1;
		}
	}
	return from;
};
haxe_ds_ArraySort.lower = function(a,cmp,from,to,val) {
	var len = to - from;
	var half;
	var mid;
	while(len > 0) {
		half = len >> 1;
		mid = from + half;
		if(cmp(a[mid],a[val]) < 0) {
			from = mid + 1;
			len = len - half - 1;
		} else {
			len = half;
		}
	}
	return from;
};
haxe_ds_ArraySort.swap = function(a,i,j) {
	var tmp = a[i];
	a[i] = a[j];
	a[j] = tmp;
};
haxe_ds_ArraySort.compare = function(a,cmp,i,j) {
	return cmp(a[i],a[j]);
};
var haxe_ds_BalancedTree = function() {
};
$hxClasses["haxe.ds.BalancedTree"] = haxe_ds_BalancedTree;
haxe_ds_BalancedTree.__name__ = "haxe.ds.BalancedTree";
haxe_ds_BalancedTree.__interfaces__ = [haxe_IMap];
haxe_ds_BalancedTree.iteratorLoop = function(node,acc) {
	if(node != null) {
		haxe_ds_BalancedTree.iteratorLoop(node.left,acc);
		acc.push(node.value);
		haxe_ds_BalancedTree.iteratorLoop(node.right,acc);
	}
};
haxe_ds_BalancedTree.prototype = {
	root: null
	,set: function(key,value) {
		this.root = this.setLoop(key,value,this.root);
	}
	,get: function(key) {
		var node = this.root;
		while(node != null) {
			var c = this.compare(key,node.key);
			if(c == 0) {
				return node.value;
			}
			if(c < 0) {
				node = node.left;
			} else {
				node = node.right;
			}
		}
		return null;
	}
	,remove: function(key) {
		try {
			this.root = this.removeLoop(key,this.root);
			return true;
		} catch( _g ) {
			haxe_NativeStackTrace.lastError = _g;
			if(typeof(haxe_Exception.caught(_g).unwrap()) == "string") {
				return false;
			} else {
				throw _g;
			}
		}
	}
	,exists: function(key) {
		var node = this.root;
		while(node != null) {
			var c = this.compare(key,node.key);
			if(c == 0) {
				return true;
			} else if(c < 0) {
				node = node.left;
			} else {
				node = node.right;
			}
		}
		return false;
	}
	,iterator: function() {
		var ret = [];
		haxe_ds_BalancedTree.iteratorLoop(this.root,ret);
		return new haxe_iterators_ArrayIterator(ret);
	}
	,keyValueIterator: function() {
		return new haxe_iterators_MapKeyValueIterator(this);
	}
	,keys: function() {
		var ret = [];
		this.keysLoop(this.root,ret);
		return new haxe_iterators_ArrayIterator(ret);
	}
	,copy: function() {
		var copied = new haxe_ds_BalancedTree();
		copied.root = this.root;
		return copied;
	}
	,setLoop: function(k,v,node) {
		if(node == null) {
			return new haxe_ds_TreeNode(null,k,v,null);
		}
		var c = this.compare(k,node.key);
		if(c == 0) {
			return new haxe_ds_TreeNode(node.left,k,v,node.right,node == null ? 0 : node._height);
		} else if(c < 0) {
			var nl = this.setLoop(k,v,node.left);
			return this.balance(nl,node.key,node.value,node.right);
		} else {
			var nr = this.setLoop(k,v,node.right);
			return this.balance(node.left,node.key,node.value,nr);
		}
	}
	,removeLoop: function(k,node) {
		if(node == null) {
			throw haxe_Exception.thrown("Not_found");
		}
		var c = this.compare(k,node.key);
		if(c == 0) {
			return this.merge(node.left,node.right);
		} else if(c < 0) {
			return this.balance(this.removeLoop(k,node.left),node.key,node.value,node.right);
		} else {
			return this.balance(node.left,node.key,node.value,this.removeLoop(k,node.right));
		}
	}
	,keysLoop: function(node,acc) {
		if(node != null) {
			this.keysLoop(node.left,acc);
			acc.push(node.key);
			this.keysLoop(node.right,acc);
		}
	}
	,merge: function(t1,t2) {
		if(t1 == null) {
			return t2;
		}
		if(t2 == null) {
			return t1;
		}
		var t = this.minBinding(t2);
		return this.balance(t1,t.key,t.value,this.removeMinBinding(t2));
	}
	,minBinding: function(t) {
		if(t == null) {
			throw haxe_Exception.thrown("Not_found");
		} else if(t.left == null) {
			return t;
		} else {
			return this.minBinding(t.left);
		}
	}
	,removeMinBinding: function(t) {
		if(t.left == null) {
			return t.right;
		} else {
			return this.balance(this.removeMinBinding(t.left),t.key,t.value,t.right);
		}
	}
	,balance: function(l,k,v,r) {
		var hl = l == null ? 0 : l._height;
		var hr = r == null ? 0 : r._height;
		if(hl > hr + 2) {
			var _this = l.left;
			var _this1 = l.right;
			if((_this == null ? 0 : _this._height) >= (_this1 == null ? 0 : _this1._height)) {
				return new haxe_ds_TreeNode(l.left,l.key,l.value,new haxe_ds_TreeNode(l.right,k,v,r));
			} else {
				return new haxe_ds_TreeNode(new haxe_ds_TreeNode(l.left,l.key,l.value,l.right.left),l.right.key,l.right.value,new haxe_ds_TreeNode(l.right.right,k,v,r));
			}
		} else if(hr > hl + 2) {
			var _this = r.right;
			var _this1 = r.left;
			if((_this == null ? 0 : _this._height) > (_this1 == null ? 0 : _this1._height)) {
				return new haxe_ds_TreeNode(new haxe_ds_TreeNode(l,k,v,r.left),r.key,r.value,r.right);
			} else {
				return new haxe_ds_TreeNode(new haxe_ds_TreeNode(l,k,v,r.left.left),r.left.key,r.left.value,new haxe_ds_TreeNode(r.left.right,r.key,r.value,r.right));
			}
		} else {
			return new haxe_ds_TreeNode(l,k,v,r,(hl > hr ? hl : hr) + 1);
		}
	}
	,compare: function(k1,k2) {
		return Reflect.compare(k1,k2);
	}
	,toString: function() {
		if(this.root == null) {
			return "{}";
		} else {
			return "{" + this.root.toString() + "}";
		}
	}
	,clear: function() {
		this.root = null;
	}
	,__class__: haxe_ds_BalancedTree
};
var haxe_ds_TreeNode = function(l,k,v,r,h) {
	if(h == null) {
		h = -1;
	}
	this.left = l;
	this.key = k;
	this.value = v;
	this.right = r;
	if(h == -1) {
		var tmp;
		var _this = this.left;
		var _this1 = this.right;
		if((_this == null ? 0 : _this._height) > (_this1 == null ? 0 : _this1._height)) {
			var _this = this.left;
			tmp = _this == null ? 0 : _this._height;
		} else {
			var _this = this.right;
			tmp = _this == null ? 0 : _this._height;
		}
		this._height = tmp + 1;
	} else {
		this._height = h;
	}
};
$hxClasses["haxe.ds.TreeNode"] = haxe_ds_TreeNode;
haxe_ds_TreeNode.__name__ = "haxe.ds.TreeNode";
haxe_ds_TreeNode.prototype = {
	left: null
	,right: null
	,key: null
	,value: null
	,_height: null
	,toString: function() {
		return (this.left == null ? "" : this.left.toString() + ", ") + ("" + Std.string(this.key) + "=" + Std.string(this.value)) + (this.right == null ? "" : ", " + this.right.toString());
	}
	,__class__: haxe_ds_TreeNode
};
var haxe_ds_EnumValueMap = function() {
	haxe_ds_BalancedTree.call(this);
};
$hxClasses["haxe.ds.EnumValueMap"] = haxe_ds_EnumValueMap;
haxe_ds_EnumValueMap.__name__ = "haxe.ds.EnumValueMap";
haxe_ds_EnumValueMap.__interfaces__ = [haxe_IMap];
haxe_ds_EnumValueMap.__super__ = haxe_ds_BalancedTree;
haxe_ds_EnumValueMap.prototype = $extend(haxe_ds_BalancedTree.prototype,{
	compare: function(k1,k2) {
		var d = k1._hx_index - k2._hx_index;
		if(d != 0) {
			return d;
		}
		var p1 = Type.enumParameters(k1);
		var p2 = Type.enumParameters(k2);
		if(p1.length == 0 && p2.length == 0) {
			return 0;
		}
		return this.compareArgs(p1,p2);
	}
	,compareArgs: function(a1,a2) {
		var ld = a1.length - a2.length;
		if(ld != 0) {
			return ld;
		}
		var _g = 0;
		var _g1 = a1.length;
		while(_g < _g1) {
			var i = _g++;
			var d = this.compareArg(a1[i],a2[i]);
			if(d != 0) {
				return d;
			}
		}
		return 0;
	}
	,compareArg: function(v1,v2) {
		if(Reflect.isEnumValue(v1) && Reflect.isEnumValue(v2)) {
			return this.compare(v1,v2);
		} else if(((v1) instanceof Array) && ((v2) instanceof Array)) {
			return this.compareArgs(v1,v2);
		} else {
			return Reflect.compare(v1,v2);
		}
	}
	,copy: function() {
		var copied = new haxe_ds_EnumValueMap();
		copied.root = this.root;
		return copied;
	}
	,__class__: haxe_ds_EnumValueMap
});
var haxe_ds_HashMap = {};
haxe_ds_HashMap._new = function() {
	var this1 = new haxe_ds__$HashMap_HashMapData();
	return this1;
};
haxe_ds_HashMap.set = function(this1,k,v) {
	var _this = this1.keys;
	var key = k.hashCode();
	_this.h[key] = k;
	var _this = this1.values;
	var key = k.hashCode();
	_this.h[key] = v;
};
haxe_ds_HashMap.get = function(this1,k) {
	var _this = this1.values;
	var key = k.hashCode();
	return _this.h[key];
};
haxe_ds_HashMap.exists = function(this1,k) {
	var _this = this1.values;
	var key = k.hashCode();
	return _this.h.hasOwnProperty(key);
};
haxe_ds_HashMap.remove = function(this1,k) {
	this1.values.remove(k.hashCode());
	return this1.keys.remove(k.hashCode());
};
haxe_ds_HashMap.keys = function(this1) {
	return this1.keys.iterator();
};
haxe_ds_HashMap.copy = function(this1) {
	var copied = new haxe_ds__$HashMap_HashMapData();
	copied.keys = this1.keys.copy();
	copied.values = this1.values.copy();
	return copied;
};
haxe_ds_HashMap.iterator = function(this1) {
	return this1.values.iterator();
};
haxe_ds_HashMap.keyValueIterator = function(this1) {
	return new haxe_iterators_HashMapKeyValueIterator(this1);
};
haxe_ds_HashMap.clear = function(this1) {
	this1.keys.h = { };
	this1.values.h = { };
};
var haxe_ds__$HashMap_HashMapData = function() {
	this.keys = new haxe_ds_IntMap();
	this.values = new haxe_ds_IntMap();
};
$hxClasses["haxe.ds._HashMap.HashMapData"] = haxe_ds__$HashMap_HashMapData;
haxe_ds__$HashMap_HashMapData.__name__ = "haxe.ds._HashMap.HashMapData";
haxe_ds__$HashMap_HashMapData.prototype = {
	keys: null
	,values: null
	,__class__: haxe_ds__$HashMap_HashMapData
};
var haxe_ds_IntMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.IntMap"] = haxe_ds_IntMap;
haxe_ds_IntMap.__name__ = "haxe.ds.IntMap";
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
haxe_ds_IntMap.prototype = {
	h: null
	,set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) {
			return false;
		}
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) if(this.h.hasOwnProperty(key)) a.push(+key);
		return new haxe_iterators_ArrayIterator(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,keyValueIterator: function() {
		return new haxe_iterators_MapKeyValueIterator(this);
	}
	,copy: function() {
		var copied = new haxe_ds_IntMap();
		var key = this.keys();
		while(key.hasNext()) {
			var key1 = key.next();
			copied.h[key1] = this.h[key1];
		}
		return copied;
	}
	,toString: function() {
		var s_b = "";
		s_b += "{";
		var it = this.keys();
		var i = it;
		while(i.hasNext()) {
			var i1 = i.next();
			s_b += i1 == null ? "null" : "" + i1;
			s_b += " => ";
			s_b += Std.string(Std.string(this.h[i1]));
			if(it.hasNext()) {
				s_b += ", ";
			}
		}
		s_b += "}";
		return s_b;
	}
	,clear: function() {
		this.h = { };
	}
	,__class__: haxe_ds_IntMap
};
var haxe_ds_List = function() {
	this.length = 0;
};
$hxClasses["haxe.ds.List"] = haxe_ds_List;
haxe_ds_List.__name__ = "haxe.ds.List";
haxe_ds_List.prototype = {
	h: null
	,q: null
	,length: null
	,add: function(item) {
		var x = new haxe_ds__$List_ListNode(item,null);
		if(this.h == null) {
			this.h = x;
		} else {
			this.q.next = x;
		}
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = new haxe_ds__$List_ListNode(item,this.h);
		this.h = x;
		if(this.q == null) {
			this.q = x;
		}
		this.length++;
	}
	,first: function() {
		if(this.h == null) {
			return null;
		} else {
			return this.h.item;
		}
	}
	,last: function() {
		if(this.q == null) {
			return null;
		} else {
			return this.q.item;
		}
	}
	,pop: function() {
		if(this.h == null) {
			return null;
		}
		var x = this.h.item;
		this.h = this.h.next;
		if(this.h == null) {
			this.q = null;
		}
		this.length--;
		return x;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l.item == v) {
				if(prev == null) {
					this.h = l.next;
				} else {
					prev.next = l.next;
				}
				if(this.q == l) {
					this.q = prev;
				}
				this.length--;
				return true;
			}
			prev = l;
			l = l.next;
		}
		return false;
	}
	,iterator: function() {
		return new haxe_ds__$List_ListIterator(this.h);
	}
	,keyValueIterator: function() {
		return new haxe_ds__$List_ListKeyValueIterator(this.h);
	}
	,toString: function() {
		var s_b = "";
		var first = true;
		var l = this.h;
		s_b += "{";
		while(l != null) {
			if(first) {
				first = false;
			} else {
				s_b += ", ";
			}
			s_b += Std.string(Std.string(l.item));
			l = l.next;
		}
		s_b += "}";
		return s_b;
	}
	,join: function(sep) {
		var s_b = "";
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) {
				first = false;
			} else {
				s_b += sep == null ? "null" : "" + sep;
			}
			s_b += Std.string(l.item);
			l = l.next;
		}
		return s_b;
	}
	,filter: function(f) {
		var l2 = new haxe_ds_List();
		var l = this.h;
		while(l != null) {
			var v = l.item;
			l = l.next;
			if(f(v)) {
				l2.add(v);
			}
		}
		return l2;
	}
	,map: function(f) {
		var b = new haxe_ds_List();
		var l = this.h;
		while(l != null) {
			var v = l.item;
			l = l.next;
			b.add(f(v));
		}
		return b;
	}
	,__class__: haxe_ds_List
};
var haxe_ds__$List_ListNode = function(item,next) {
	this.item = item;
	this.next = next;
};
$hxClasses["haxe.ds._List.ListNode"] = haxe_ds__$List_ListNode;
haxe_ds__$List_ListNode.__name__ = "haxe.ds._List.ListNode";
haxe_ds__$List_ListNode.prototype = {
	item: null
	,next: null
	,__class__: haxe_ds__$List_ListNode
};
var haxe_ds__$List_ListIterator = function(head) {
	this.head = head;
};
$hxClasses["haxe.ds._List.ListIterator"] = haxe_ds__$List_ListIterator;
haxe_ds__$List_ListIterator.__name__ = "haxe.ds._List.ListIterator";
haxe_ds__$List_ListIterator.prototype = {
	head: null
	,hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		var val = this.head.item;
		this.head = this.head.next;
		return val;
	}
	,__class__: haxe_ds__$List_ListIterator
};
var haxe_ds__$List_ListKeyValueIterator = function(head) {
	this.head = head;
	this.idx = 0;
};
$hxClasses["haxe.ds._List.ListKeyValueIterator"] = haxe_ds__$List_ListKeyValueIterator;
haxe_ds__$List_ListKeyValueIterator.__name__ = "haxe.ds._List.ListKeyValueIterator";
haxe_ds__$List_ListKeyValueIterator.prototype = {
	idx: null
	,head: null
	,hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		var val = this.head.item;
		this.head = this.head.next;
		return { value : val, key : this.idx++};
	}
	,__class__: haxe_ds__$List_ListKeyValueIterator
};
var haxe_ds_Map = {};
haxe_ds_Map.set = function(this1,key,value) {
	this1.set(key,value);
};
haxe_ds_Map.get = function(this1,key) {
	return this1.get(key);
};
haxe_ds_Map.exists = function(this1,key) {
	return this1.exists(key);
};
haxe_ds_Map.remove = function(this1,key) {
	return this1.remove(key);
};
haxe_ds_Map.keys = function(this1) {
	return this1.keys();
};
haxe_ds_Map.iterator = function(this1) {
	return this1.iterator();
};
haxe_ds_Map.keyValueIterator = function(this1) {
	return this1.keyValueIterator();
};
haxe_ds_Map.copy = function(this1) {
	return this1.copy();
};
haxe_ds_Map.toString = function(this1) {
	return this1.toString();
};
haxe_ds_Map.clear = function(this1) {
	this1.clear();
};
haxe_ds_Map.arrayWrite = function(this1,k,v) {
	this1.set(k,v);
	return v;
};
haxe_ds_Map.toStringMap = function(t) {
	return new haxe_ds_StringMap();
};
haxe_ds_Map.toIntMap = function(t) {
	return new haxe_ds_IntMap();
};
haxe_ds_Map.toEnumValueMapMap = function(t) {
	return new haxe_ds_EnumValueMap();
};
haxe_ds_Map.toObjectMap = function(t) {
	return new haxe_ds_ObjectMap();
};
haxe_ds_Map.fromStringMap = function(map) {
	return map;
};
haxe_ds_Map.fromIntMap = function(map) {
	return map;
};
haxe_ds_Map.fromObjectMap = function(map) {
	return map;
};
var haxe_ds_ObjectMap = function() {
	this.h = { __keys__ : { }};
};
$hxClasses["haxe.ds.ObjectMap"] = haxe_ds_ObjectMap;
haxe_ds_ObjectMap.__name__ = "haxe.ds.ObjectMap";
haxe_ds_ObjectMap.__interfaces__ = [haxe_IMap];
haxe_ds_ObjectMap.count = null;
haxe_ds_ObjectMap.assignId = function(obj) {
	return (obj.__id__ = $global.$haxeUID++);
};
haxe_ds_ObjectMap.getId = function(obj) {
	return obj.__id__;
};
haxe_ds_ObjectMap.prototype = {
	h: null
	,set: function(key,value) {
		var id = key.__id__;
		if(id == null) {
			id = (key.__id__ = $global.$haxeUID++);
		}
		this.h[id] = value;
		this.h.__keys__[id] = key;
	}
	,get: function(key) {
		return this.h[key.__id__];
	}
	,exists: function(key) {
		return this.h.__keys__[key.__id__] != null;
	}
	,remove: function(key) {
		var id = key.__id__;
		if(this.h.__keys__[id] == null) {
			return false;
		}
		delete(this.h[id]);
		delete(this.h.__keys__[id]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) {
			a.push(this.h.__keys__[key]);
		}
		}
		return new haxe_iterators_ArrayIterator(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i.__id__];
		}};
	}
	,keyValueIterator: function() {
		return new haxe_iterators_MapKeyValueIterator(this);
	}
	,copy: function() {
		var copied = new haxe_ds_ObjectMap();
		var key = this.keys();
		while(key.hasNext()) {
			var key1 = key.next();
			copied.set(key1,this.h[key1.__id__]);
		}
		return copied;
	}
	,toString: function() {
		var s_b = "";
		s_b += "{";
		var it = this.keys();
		var i = it;
		while(i.hasNext()) {
			var i1 = i.next();
			s_b += Std.string(Std.string(i1));
			s_b += " => ";
			s_b += Std.string(Std.string(this.h[i1.__id__]));
			if(it.hasNext()) {
				s_b += ", ";
			}
		}
		s_b += "}";
		return s_b;
	}
	,clear: function() {
		this.h = { __keys__ : { }};
	}
	,__class__: haxe_ds_ObjectMap
};
var haxe_ds_ReadOnlyArray = {};
haxe_ds_ReadOnlyArray.__properties__ = {get_length:"get_length"};
haxe_ds_ReadOnlyArray.get_length = function(this1) {
	return this1.length;
};
haxe_ds_ReadOnlyArray.get = function(this1,i) {
	return this1[i];
};
haxe_ds_ReadOnlyArray.concat = function(this1,a) {
	return this1.concat(a);
};
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
$hxClasses["haxe.ds.StringMap"] = haxe_ds_StringMap;
haxe_ds_StringMap.__name__ = "haxe.ds.StringMap";
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.createCopy = function(h) {
	var copy = new haxe_ds_StringMap();
	for (var key in h) copy.h[key] = h[key];
	return copy;
};
haxe_ds_StringMap.stringify = function(h) {
	var s = "{";
	var first = true;
	for (var key in h) {
		if (first) first = false; else s += ',';
		s += key + ' => ' + Std.string(h[key]);
	}
	return s + "}";
};
haxe_ds_StringMap.prototype = {
	h: null
	,exists: function(key) {
		return Object.prototype.hasOwnProperty.call(this.h,key);
	}
	,get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
	,remove: function(key) {
		if(Object.prototype.hasOwnProperty.call(this.h,key)) {
			delete(this.h[key]);
			return true;
		} else {
			return false;
		}
	}
	,keys: function() {
		return new haxe_ds__$StringMap_StringMapKeyIterator(this.h);
	}
	,iterator: function() {
		return new haxe_ds__$StringMap_StringMapValueIterator(this.h);
	}
	,keyValueIterator: function() {
		return new haxe_ds__$StringMap_StringMapKeyValueIterator(this.h);
	}
	,copy: function() {
		return haxe_ds_StringMap.createCopy(this.h);
	}
	,clear: function() {
		this.h = Object.create(null);
	}
	,toString: function() {
		return haxe_ds_StringMap.stringify(this.h);
	}
	,__class__: haxe_ds_StringMap
};
var haxe_ds__$StringMap_StringMapKeyIterator = function(h) {
	this.h = h;
	this.keys = Object.keys(h);
	this.length = this.keys.length;
	this.current = 0;
};
$hxClasses["haxe.ds._StringMap.StringMapKeyIterator"] = haxe_ds__$StringMap_StringMapKeyIterator;
haxe_ds__$StringMap_StringMapKeyIterator.__name__ = "haxe.ds._StringMap.StringMapKeyIterator";
haxe_ds__$StringMap_StringMapKeyIterator.prototype = {
	h: null
	,keys: null
	,length: null
	,current: null
	,hasNext: function() {
		return this.current < this.length;
	}
	,next: function() {
		return this.keys[this.current++];
	}
	,__class__: haxe_ds__$StringMap_StringMapKeyIterator
};
var haxe_ds__$StringMap_StringMapValueIterator = function(h) {
	this.h = h;
	this.keys = Object.keys(h);
	this.length = this.keys.length;
	this.current = 0;
};
$hxClasses["haxe.ds._StringMap.StringMapValueIterator"] = haxe_ds__$StringMap_StringMapValueIterator;
haxe_ds__$StringMap_StringMapValueIterator.__name__ = "haxe.ds._StringMap.StringMapValueIterator";
haxe_ds__$StringMap_StringMapValueIterator.prototype = {
	h: null
	,keys: null
	,length: null
	,current: null
	,hasNext: function() {
		return this.current < this.length;
	}
	,next: function() {
		return this.h[this.keys[this.current++]];
	}
	,__class__: haxe_ds__$StringMap_StringMapValueIterator
};
var haxe_ds__$StringMap_StringMapKeyValueIterator = function(h) {
	this.h = h;
	this.keys = Object.keys(h);
	this.length = this.keys.length;
	this.current = 0;
};
$hxClasses["haxe.ds._StringMap.StringMapKeyValueIterator"] = haxe_ds__$StringMap_StringMapKeyValueIterator;
haxe_ds__$StringMap_StringMapKeyValueIterator.__name__ = "haxe.ds._StringMap.StringMapKeyValueIterator";
haxe_ds__$StringMap_StringMapKeyValueIterator.prototype = {
	h: null
	,keys: null
	,length: null
	,current: null
	,hasNext: function() {
		return this.current < this.length;
	}
	,next: function() {
		var key = this.keys[this.current++];
		return { key : key, value : this.h[key]};
	}
	,__class__: haxe_ds__$StringMap_StringMapKeyValueIterator
};
var haxe_ds_WeakMap = function() {
	throw new haxe_exceptions_NotImplementedException("Not implemented for this platform",null,{ fileName : "haxe/ds/WeakMap.hx", lineNumber : 39, className : "haxe.ds.WeakMap", methodName : "new"});
};
$hxClasses["haxe.ds.WeakMap"] = haxe_ds_WeakMap;
haxe_ds_WeakMap.__name__ = "haxe.ds.WeakMap";
haxe_ds_WeakMap.__interfaces__ = [haxe_IMap];
haxe_ds_WeakMap.prototype = {
	set: function(key,value) {
	}
	,get: function(key) {
		return null;
	}
	,exists: function(key) {
		return false;
	}
	,remove: function(key) {
		return false;
	}
	,keys: function() {
		return null;
	}
	,iterator: function() {
		return null;
	}
	,keyValueIterator: function() {
		return null;
	}
	,copy: function() {
		return null;
	}
	,toString: function() {
		return null;
	}
	,clear: function() {
	}
	,__class__: haxe_ds_WeakMap
};
var haxe_exceptions_PosException = function(message,previous,pos) {
	haxe_Exception.call(this,message,previous);
	if(pos == null) {
		this.posInfos = { fileName : "(unknown)", lineNumber : 0, className : "(unknown)", methodName : "(unknown)"};
	} else {
		this.posInfos = pos;
	}
	this.__skipStack++;
};
$hxClasses["haxe.exceptions.PosException"] = haxe_exceptions_PosException;
haxe_exceptions_PosException.__name__ = "haxe.exceptions.PosException";
haxe_exceptions_PosException.__super__ = haxe_Exception;
haxe_exceptions_PosException.prototype = $extend(haxe_Exception.prototype,{
	posInfos: null
	,toString: function() {
		return "" + haxe_Exception.prototype.toString.call(this) + " in " + this.posInfos.className + "." + this.posInfos.methodName + " at " + this.posInfos.fileName + ":" + this.posInfos.lineNumber;
	}
	,__class__: haxe_exceptions_PosException
});
var haxe_exceptions_NotImplementedException = function(message,previous,pos) {
	if(message == null) {
		message = "Not implemented";
	}
	haxe_exceptions_PosException.call(this,message,previous,pos);
	this.__skipStack++;
};
$hxClasses["haxe.exceptions.NotImplementedException"] = haxe_exceptions_NotImplementedException;
haxe_exceptions_NotImplementedException.__name__ = "haxe.exceptions.NotImplementedException";
haxe_exceptions_NotImplementedException.__super__ = haxe_exceptions_PosException;
haxe_exceptions_NotImplementedException.prototype = $extend(haxe_exceptions_PosException.prototype,{
	__class__: haxe_exceptions_NotImplementedException
});
var haxe_io_Bytes = function(data) {
	this.length = data.byteLength;
	this.b = new Uint8Array(data);
	this.b.bufferValue = data;
	data.hxBytes = this;
	data.bytes = this.b;
};
$hxClasses["haxe.io.Bytes"] = haxe_io_Bytes;
haxe_io_Bytes.__name__ = "haxe.io.Bytes";
haxe_io_Bytes.alloc = function(length) {
	return new haxe_io_Bytes(new ArrayBuffer(length));
};
haxe_io_Bytes.ofString = function(s,encoding) {
	if(encoding == haxe_io_Encoding.RawNative) {
		var buf = new Uint8Array(s.length << 1);
		var _g = 0;
		var _g1 = s.length;
		while(_g < _g1) {
			var i = _g++;
			var c = s.charCodeAt(i);
			buf[i << 1] = c & 255;
			buf[i << 1 | 1] = c >> 8;
		}
		return new haxe_io_Bytes(buf.buffer);
	}
	var a = [];
	var i = 0;
	while(i < s.length) {
		var c = s.charCodeAt(i++);
		if(55296 <= c && c <= 56319) {
			c = c - 55232 << 10 | s.charCodeAt(i++) & 1023;
		}
		if(c <= 127) {
			a.push(c);
		} else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe_io_Bytes(new Uint8Array(a).buffer);
};
haxe_io_Bytes.ofData = function(b) {
	var hb = b.hxBytes;
	if(hb != null) {
		return hb;
	}
	return new haxe_io_Bytes(b);
};
haxe_io_Bytes.ofHex = function(s) {
	if((s.length & 1) != 0) {
		throw haxe_Exception.thrown("Not a hex string (odd number of digits)");
	}
	var a = [];
	var i = 0;
	var len = s.length >> 1;
	while(i < len) {
		var high = s.charCodeAt(i * 2);
		var low = s.charCodeAt(i * 2 + 1);
		high = (high & 15) + ((high & 64) >> 6) * 9;
		low = (low & 15) + ((low & 64) >> 6) * 9;
		a.push((high << 4 | low) & 255);
		++i;
	}
	return new haxe_io_Bytes(new Uint8Array(a).buffer);
};
haxe_io_Bytes.fastGet = function(b,pos) {
	return b.bytes[pos];
};
haxe_io_Bytes.prototype = {
	length: null
	,b: null
	,data: null
	,get: function(pos) {
		return this.b[pos];
	}
	,set: function(pos,v) {
		this.b[pos] = v;
	}
	,blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		if(srcpos == 0 && len == src.b.byteLength) {
			this.b.set(src.b,pos);
		} else {
			this.b.set(src.b.subarray(srcpos,srcpos + len),pos);
		}
	}
	,fill: function(pos,len,value) {
		var _g = 0;
		var _g1 = len;
		while(_g < _g1) {
			var i = _g++;
			this.b[pos++] = value;
		}
	}
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		return new haxe_io_Bytes(this.b.buffer.slice(pos + this.b.byteOffset,pos + this.b.byteOffset + len));
	}
	,compare: function(other) {
		var b1 = this.b;
		var b2 = other.b;
		var len = this.length < other.length ? this.length : other.length;
		var _g = 0;
		var _g1 = len;
		while(_g < _g1) {
			var i = _g++;
			if(b1[i] != b2[i]) {
				return b1[i] - b2[i];
			}
		}
		return this.length - other.length;
	}
	,initData: function() {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
	}
	,getDouble: function(pos) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		return this.data.getFloat64(pos,true);
	}
	,getFloat: function(pos) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		return this.data.getFloat32(pos,true);
	}
	,setDouble: function(pos,v) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		this.data.setFloat64(pos,v,true);
	}
	,setFloat: function(pos,v) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		this.data.setFloat32(pos,v,true);
	}
	,getUInt16: function(pos) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		return this.data.getUint16(pos,true);
	}
	,setUInt16: function(pos,v) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		this.data.setUint16(pos,v,true);
	}
	,getInt32: function(pos) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		return this.data.getInt32(pos,true);
	}
	,setInt32: function(pos,v) {
		if(this.data == null) {
			this.data = new DataView(this.b.buffer,this.b.byteOffset,this.b.byteLength);
		}
		this.data.setInt32(pos,v,true);
	}
	,getInt64: function(pos) {
		var this1 = new haxe__$Int64__$_$_$Int64(this.getInt32(pos + 4),this.getInt32(pos));
		return this1;
	}
	,setInt64: function(pos,v) {
		this.setInt32(pos,v.low);
		this.setInt32(pos + 4,v.high);
	}
	,getString: function(pos,len,encoding) {
		if(pos < 0 || len < 0 || pos + len > this.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		if(encoding == null) {
			encoding = haxe_io_Encoding.UTF8;
		}
		var s = "";
		var b = this.b;
		var i = pos;
		var max = pos + len;
		switch(encoding._hx_index) {
		case 0:
			var debug = pos > 0;
			while(i < max) {
				var c = b[i++];
				if(c < 128) {
					if(c == 0) {
						break;
					}
					s += String.fromCodePoint(c);
				} else if(c < 224) {
					var code = (c & 63) << 6 | b[i++] & 127;
					s += String.fromCodePoint(code);
				} else if(c < 240) {
					var c2 = b[i++];
					var code1 = (c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127;
					s += String.fromCodePoint(code1);
				} else {
					var c21 = b[i++];
					var c3 = b[i++];
					var u = (c & 15) << 18 | (c21 & 127) << 12 | (c3 & 127) << 6 | b[i++] & 127;
					s += String.fromCodePoint(u);
				}
			}
			break;
		case 1:
			while(i < max) {
				var c = b[i++] | b[i++] << 8;
				s += String.fromCodePoint(c);
			}
			break;
		}
		return s;
	}
	,readString: function(pos,len) {
		return this.getString(pos,len);
	}
	,toString: function() {
		return this.getString(0,this.length);
	}
	,toHex: function() {
		var s_b = "";
		var chars = [];
		var str = "0123456789abcdef";
		var _g = 0;
		var _g1 = str.length;
		while(_g < _g1) {
			var i = _g++;
			chars.push(HxOverrides.cca(str,i));
		}
		var _g = 0;
		var _g1 = this.length;
		while(_g < _g1) {
			var i = _g++;
			var c = this.b[i];
			s_b += String.fromCodePoint(chars[c >> 4]);
			s_b += String.fromCodePoint(chars[c & 15]);
		}
		return s_b;
	}
	,getData: function() {
		return this.b.bufferValue;
	}
	,__class__: haxe_io_Bytes
};
var haxe_io_BytesBuffer = function() {
	this.pos = 0;
	this.size = 0;
};
$hxClasses["haxe.io.BytesBuffer"] = haxe_io_BytesBuffer;
haxe_io_BytesBuffer.__name__ = "haxe.io.BytesBuffer";
haxe_io_BytesBuffer.prototype = {
	buffer: null
	,view: null
	,u8: null
	,pos: null
	,size: null
	,get_length: function() {
		return this.pos;
	}
	,addByte: function(byte) {
		if(this.pos == this.size) {
			this.grow(1);
		}
		this.view.setUint8(this.pos++,byte);
	}
	,add: function(src) {
		if(this.pos + src.length > this.size) {
			this.grow(src.length);
		}
		if(this.size == 0) {
			return;
		}
		var sub = new Uint8Array(src.b.buffer,src.b.byteOffset,src.length);
		this.u8.set(sub,this.pos);
		this.pos += src.length;
	}
	,addString: function(v,encoding) {
		this.add(haxe_io_Bytes.ofString(v,encoding));
	}
	,addInt32: function(v) {
		if(this.pos + 4 > this.size) {
			this.grow(4);
		}
		this.view.setInt32(this.pos,v,true);
		this.pos += 4;
	}
	,addInt64: function(v) {
		if(this.pos + 8 > this.size) {
			this.grow(8);
		}
		this.view.setInt32(this.pos,v.low,true);
		this.view.setInt32(this.pos + 4,v.high,true);
		this.pos += 8;
	}
	,addFloat: function(v) {
		if(this.pos + 4 > this.size) {
			this.grow(4);
		}
		this.view.setFloat32(this.pos,v,true);
		this.pos += 4;
	}
	,addDouble: function(v) {
		if(this.pos + 8 > this.size) {
			this.grow(8);
		}
		this.view.setFloat64(this.pos,v,true);
		this.pos += 8;
	}
	,addBytes: function(src,pos,len) {
		if(pos < 0 || len < 0 || pos + len > src.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		if(this.pos + len > this.size) {
			this.grow(len);
		}
		if(this.size == 0) {
			return;
		}
		var sub = new Uint8Array(src.b.buffer,src.b.byteOffset + pos,len);
		this.u8.set(sub,this.pos);
		this.pos += len;
	}
	,grow: function(delta) {
		var req = this.pos + delta;
		var nsize = this.size == 0 ? 16 : this.size;
		while(nsize < req) nsize = nsize * 3 >> 1;
		var nbuf = new ArrayBuffer(nsize);
		var nu8 = new Uint8Array(nbuf);
		if(this.size > 0) {
			nu8.set(this.u8);
		}
		this.size = nsize;
		this.buffer = nbuf;
		this.u8 = nu8;
		this.view = new DataView(this.buffer);
	}
	,getBytes: function() {
		if(this.size == 0) {
			return new haxe_io_Bytes(new ArrayBuffer(0));
		}
		var b = new haxe_io_Bytes(this.buffer);
		b.length = this.pos;
		return b;
	}
	,__class__: haxe_io_BytesBuffer
	,__properties__: {get_length:"get_length"}
};
var haxe_io_Encoding = $hxEnums["haxe.io.Encoding"] = { __ename__:"haxe.io.Encoding",__constructs__:null
	,UTF8: {_hx_name:"UTF8",_hx_index:0,__enum__:"haxe.io.Encoding",toString:$estr}
	,RawNative: {_hx_name:"RawNative",_hx_index:1,__enum__:"haxe.io.Encoding",toString:$estr}
};
haxe_io_Encoding.__constructs__ = [haxe_io_Encoding.UTF8,haxe_io_Encoding.RawNative];
haxe_io_Encoding.__empty_constructs__ = [haxe_io_Encoding.UTF8,haxe_io_Encoding.RawNative];
var haxe_io_Error = $hxEnums["haxe.io.Error"] = { __ename__:"haxe.io.Error",__constructs__:null
	,Blocked: {_hx_name:"Blocked",_hx_index:0,__enum__:"haxe.io.Error",toString:$estr}
	,Overflow: {_hx_name:"Overflow",_hx_index:1,__enum__:"haxe.io.Error",toString:$estr}
	,OutsideBounds: {_hx_name:"OutsideBounds",_hx_index:2,__enum__:"haxe.io.Error",toString:$estr}
	,Custom: ($_=function(e) { return {_hx_index:3,e:e,__enum__:"haxe.io.Error",toString:$estr}; },$_._hx_name="Custom",$_.__params__ = ["e"],$_)
};
haxe_io_Error.__constructs__ = [haxe_io_Error.Blocked,haxe_io_Error.Overflow,haxe_io_Error.OutsideBounds,haxe_io_Error.Custom];
haxe_io_Error.__empty_constructs__ = [haxe_io_Error.Blocked,haxe_io_Error.Overflow,haxe_io_Error.OutsideBounds];
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
$hxClasses["haxe.iterators.ArrayIterator"] = haxe_iterators_ArrayIterator;
haxe_iterators_ArrayIterator.__name__ = "haxe.iterators.ArrayIterator";
haxe_iterators_ArrayIterator.prototype = {
	array: null
	,current: null
	,hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
	,__class__: haxe_iterators_ArrayIterator
};
var haxe_iterators_ArrayKeyValueIterator = function(array) {
	this.current = 0;
	this.array = array;
};
$hxClasses["haxe.iterators.ArrayKeyValueIterator"] = haxe_iterators_ArrayKeyValueIterator;
haxe_iterators_ArrayKeyValueIterator.__name__ = "haxe.iterators.ArrayKeyValueIterator";
haxe_iterators_ArrayKeyValueIterator.prototype = {
	current: null
	,array: null
	,hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return { value : this.array[this.current], key : this.current++};
	}
	,__class__: haxe_iterators_ArrayKeyValueIterator
};
var haxe_iterators_DynamicAccessIterator = function(access) {
	this.access = access;
	this.keys = Reflect.fields(access);
	this.index = 0;
};
$hxClasses["haxe.iterators.DynamicAccessIterator"] = haxe_iterators_DynamicAccessIterator;
haxe_iterators_DynamicAccessIterator.__name__ = "haxe.iterators.DynamicAccessIterator";
haxe_iterators_DynamicAccessIterator.prototype = {
	access: null
	,keys: null
	,index: null
	,hasNext: function() {
		return this.index < this.keys.length;
	}
	,next: function() {
		return this.access[this.keys[this.index++]];
	}
	,__class__: haxe_iterators_DynamicAccessIterator
};
var haxe_iterators_DynamicAccessKeyValueIterator = function(access) {
	this.access = access;
	this.keys = Reflect.fields(access);
	this.index = 0;
};
$hxClasses["haxe.iterators.DynamicAccessKeyValueIterator"] = haxe_iterators_DynamicAccessKeyValueIterator;
haxe_iterators_DynamicAccessKeyValueIterator.__name__ = "haxe.iterators.DynamicAccessKeyValueIterator";
haxe_iterators_DynamicAccessKeyValueIterator.prototype = {
	access: null
	,keys: null
	,index: null
	,hasNext: function() {
		return this.index < this.keys.length;
	}
	,next: function() {
		var key = this.keys[this.index++];
		return { value : this.access[key], key : key};
	}
	,__class__: haxe_iterators_DynamicAccessKeyValueIterator
};
var haxe_iterators_HashMapKeyValueIterator = function(map) {
	this.map = map;
	this.keys = map.keys.iterator();
};
$hxClasses["haxe.iterators.HashMapKeyValueIterator"] = haxe_iterators_HashMapKeyValueIterator;
haxe_iterators_HashMapKeyValueIterator.__name__ = "haxe.iterators.HashMapKeyValueIterator";
haxe_iterators_HashMapKeyValueIterator.prototype = {
	map: null
	,keys: null
	,hasNext: function() {
		return this.keys.hasNext();
	}
	,next: function() {
		var key = this.keys.next();
		var _this = this.map.values;
		var key1 = key.hashCode();
		return { value : _this.h[key1], key : key};
	}
	,__class__: haxe_iterators_HashMapKeyValueIterator
};
var haxe_iterators_MapKeyValueIterator = function(map) {
	this.map = map;
	this.keys = map.keys();
};
$hxClasses["haxe.iterators.MapKeyValueIterator"] = haxe_iterators_MapKeyValueIterator;
haxe_iterators_MapKeyValueIterator.__name__ = "haxe.iterators.MapKeyValueIterator";
haxe_iterators_MapKeyValueIterator.prototype = {
	map: null
	,keys: null
	,hasNext: function() {
		return this.keys.hasNext();
	}
	,next: function() {
		var key = this.keys.next();
		return { value : this.map.get(key), key : key};
	}
	,__class__: haxe_iterators_MapKeyValueIterator
};
var haxe_iterators_RestIterator = function(args) {
	this.current = 0;
	this.args = args;
};
$hxClasses["haxe.iterators.RestIterator"] = haxe_iterators_RestIterator;
haxe_iterators_RestIterator.__name__ = "haxe.iterators.RestIterator";
haxe_iterators_RestIterator.prototype = {
	args: null
	,current: null
	,hasNext: function() {
		return this.current < this.args.length;
	}
	,next: function() {
		return this.args[this.current++];
	}
	,__class__: haxe_iterators_RestIterator
};
var haxe_iterators_RestKeyValueIterator = function(args) {
	this.current = 0;
	this.args = args;
};
$hxClasses["haxe.iterators.RestKeyValueIterator"] = haxe_iterators_RestKeyValueIterator;
haxe_iterators_RestKeyValueIterator.__name__ = "haxe.iterators.RestKeyValueIterator";
haxe_iterators_RestKeyValueIterator.prototype = {
	args: null
	,current: null
	,hasNext: function() {
		return this.current < this.args.length;
	}
	,next: function() {
		return { key : this.current, value : this.args[this.current++]};
	}
	,__class__: haxe_iterators_RestKeyValueIterator
};
var haxe_iterators_StringIterator = function(s) {
	this.offset = 0;
	this.s = s;
};
$hxClasses["haxe.iterators.StringIterator"] = haxe_iterators_StringIterator;
haxe_iterators_StringIterator.__name__ = "haxe.iterators.StringIterator";
haxe_iterators_StringIterator.prototype = {
	offset: null
	,s: null
	,hasNext: function() {
		return this.offset < this.s.length;
	}
	,next: function() {
		return this.s.charCodeAt(this.offset++);
	}
	,__class__: haxe_iterators_StringIterator
};
var haxe_iterators_StringIteratorUnicode = function(s) {
	this.offset = 0;
	this.s = s;
};
$hxClasses["haxe.iterators.StringIteratorUnicode"] = haxe_iterators_StringIteratorUnicode;
haxe_iterators_StringIteratorUnicode.__name__ = "haxe.iterators.StringIteratorUnicode";
haxe_iterators_StringIteratorUnicode.unicodeIterator = function(s) {
	return new haxe_iterators_StringIteratorUnicode(s);
};
haxe_iterators_StringIteratorUnicode.prototype = {
	offset: null
	,s: null
	,hasNext: function() {
		return this.offset < this.s.length;
	}
	,next: function() {
		var s = this.s;
		var index = this.offset++;
		var c = s.charCodeAt(index);
		if(c >= 55296 && c <= 56319) {
			c = c - 55232 << 10 | s.charCodeAt(index + 1) & 1023;
		}
		var c1 = c;
		if(c1 >= 65536) {
			this.offset++;
		}
		return c1;
	}
	,__class__: haxe_iterators_StringIteratorUnicode
};
var haxe_iterators_StringKeyValueIterator = function(s) {
	this.offset = 0;
	this.s = s;
};
$hxClasses["haxe.iterators.StringKeyValueIterator"] = haxe_iterators_StringKeyValueIterator;
haxe_iterators_StringKeyValueIterator.__name__ = "haxe.iterators.StringKeyValueIterator";
haxe_iterators_StringKeyValueIterator.prototype = {
	offset: null
	,s: null
	,hasNext: function() {
		return this.offset < this.s.length;
	}
	,next: function() {
		return { key : this.offset, value : this.s.charCodeAt(this.offset++)};
	}
	,__class__: haxe_iterators_StringKeyValueIterator
};
var js_Boot = function() { };
$hxClasses["js.Boot"] = js_Boot;
js_Boot.__name__ = "js.Boot";
js_Boot.isClass = function(o) {
	return o.__name__;
};
js_Boot.isInterface = function(o) {
	return o.__isInterface__;
};
js_Boot.isEnum = function(e) {
	return e.__ename__;
};
js_Boot.getClass = function(o) {
	if(o == null) {
		return null;
	} else if(((o) instanceof Array)) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o.__enum__) {
			var e = $hxEnums[o.__enum__];
			var con = e.__constructs__[o._hx_index];
			var n = con._hx_name;
			if(con.__params__) {
				s = s + "\t";
				return n + "(" + ((function($this) {
					var $r;
					var _g = [];
					{
						var _g1 = 0;
						var _g2 = con.__params__;
						while(true) {
							if(!(_g1 < _g2.length)) {
								break;
							}
							var p = _g2[_g1];
							_g1 = _g1 + 1;
							_g.push(js_Boot.__string_rec(o[p],s));
						}
					}
					$r = _g;
					return $r;
				}(this))).join(",") + ")";
			} else {
				return n;
			}
		}
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			haxe_NativeStackTrace.lastError = _g;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g = 0;
		var _g1 = intf.length;
		while(_g < _g1) {
			var i = _g++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) {
				return true;
			}
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		return ((o) instanceof Array);
	case Bool:
		return typeof(o) == "boolean";
	case Dynamic:
		return o != null;
	case Float:
		return typeof(o) == "number";
	case Int:
		if(typeof(o) == "number") {
			return ((o | 0) === o);
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(js_Boot.__downcastCheck(o,cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(((o) instanceof cl)) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == Class ? o.__name__ != null : false) {
			return true;
		}
		if(cl == Enum ? o.__ename__ != null : false) {
			return true;
		}
		return o.__enum__ != null ? $hxEnums[o.__enum__] == cl : false;
	}
};
js_Boot.__downcastCheck = function(o,cl) {
	if(!((o) instanceof cl)) {
		if(cl.__isInterface__) {
			return js_Boot.__interfLoop(js_Boot.getClass(o),cl);
		} else {
			return false;
		}
	} else {
		return true;
	}
};
js_Boot.__implements = function(o,iface) {
	return js_Boot.__interfLoop(js_Boot.getClass(o),iface);
};
js_Boot.__cast = function(o,t) {
	if(o == null || js_Boot.__instanceof(o,t)) {
		return o;
	} else {
		throw haxe_Exception.thrown("Cannot cast " + Std.string(o) + " to " + Std.string(t));
	}
};
js_Boot.__toStr = null;
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var js_Lib = function() { };
$hxClasses["js.Lib"] = js_Lib;
js_Lib.__name__ = "js.Lib";
js_Lib.__properties__ = {get_undefined:"get_undefined"};
js_Lib.debug = function() {
	debugger;
};
js_Lib.alert = function(v) {
	alert(js_Boot.__string_rec(v,""));
};
js_Lib.eval = function(code) {
	return eval(code);
};
js_Lib.get_undefined = function() {
	return undefined;
};
js_Lib.rethrow = function() {
};
js_Lib.getOriginalException = function() {
	return null;
};
js_Lib.getNextHaxeUID = function() {
	return $global.$haxeUID++;
};
var js_lib__$ArrayBuffer_ArrayBufferCompat = function() { };
$hxClasses["js.lib._ArrayBuffer.ArrayBufferCompat"] = js_lib__$ArrayBuffer_ArrayBufferCompat;
js_lib__$ArrayBuffer_ArrayBufferCompat.__name__ = "js.lib._ArrayBuffer.ArrayBufferCompat";
js_lib__$ArrayBuffer_ArrayBufferCompat.sliceImpl = function(begin,end) {
	var u = new Uint8Array(this,begin,end == null ? null : end - begin);
	var resultArray = new Uint8Array(u.byteLength);
	resultArray.set(u);
	return resultArray.buffer;
};
var js_lib_HaxeIterator = function(jsIterator) {
	this.jsIterator = jsIterator;
	this.lastStep = jsIterator.next();
};
$hxClasses["js.lib.HaxeIterator"] = js_lib_HaxeIterator;
js_lib_HaxeIterator.__name__ = "js.lib.HaxeIterator";
js_lib_HaxeIterator.iterator = function(jsIterator) {
	return new js_lib_HaxeIterator(jsIterator);
};
js_lib_HaxeIterator.prototype = {
	jsIterator: null
	,lastStep: null
	,hasNext: function() {
		return !this.lastStep.done;
	}
	,next: function() {
		var v = this.lastStep.value;
		this.lastStep = this.jsIterator.next();
		return v;
	}
	,__class__: js_lib_HaxeIterator
};
var js_lib_KeyValue = {};
js_lib_KeyValue.__properties__ = {get_value:"get_value",get_key:"get_key"};
js_lib_KeyValue.get_key = function(this1) {
	return this1[0];
};
js_lib_KeyValue.get_value = function(this1) {
	return this1[1];
};
var js_lib_ObjectEntry = {};
js_lib_ObjectEntry.__properties__ = {get_value:"get_value",get_key:"get_key"};
js_lib_ObjectEntry.get_key = function(this1) {
	return this1[0];
};
js_lib_ObjectEntry.get_value = function(this1) {
	return this1[1];
};
var seedyrng_GeneratorInterface = function() { };
$hxClasses["seedyrng.GeneratorInterface"] = seedyrng_GeneratorInterface;
seedyrng_GeneratorInterface.__name__ = "seedyrng.GeneratorInterface";
seedyrng_GeneratorInterface.__isInterface__ = true;
seedyrng_GeneratorInterface.prototype = {
	get_seed: null
	,set_seed: null
	,get_state: null
	,set_state: null
	,get_usesAllBits: null
	,nextInt: null
	,__class__: seedyrng_GeneratorInterface
	,__properties__: {get_usesAllBits:"get_usesAllBits",set_state:"set_state",get_state:"get_state",set_seed:"set_seed",get_seed:"get_seed"}
};
var seedyrng_Random = function(seed,generator) {
	if(seed == null) {
		var this1 = new haxe__$Int64__$_$_$Int64(seedyrng_Random.randomSystemInt(),seedyrng_Random.randomSystemInt());
		seed = this1;
	}
	if(generator == null) {
		generator = new seedyrng_Xorshift128Plus();
	}
	this.generator = generator;
	this.set_seed(seed);
};
$hxClasses["seedyrng.Random"] = seedyrng_Random;
seedyrng_Random.__name__ = "seedyrng.Random";
seedyrng_Random.__interfaces__ = [seedyrng_GeneratorInterface];
seedyrng_Random.randomSystemInt = function() {
	var value = Std.random(255) << 24 | Std.random(255) << 16 | Std.random(255) << 8 | Std.random(255);
	return value;
};
seedyrng_Random.prototype = {
	generator: null
	,get_seed: function() {
		return this.generator.get_seed();
	}
	,set_seed: function(value) {
		return this.generator.set_seed(value);
	}
	,get_state: function() {
		return this.generator.get_state();
	}
	,set_state: function(value) {
		return this.generator.set_state(value);
	}
	,get_usesAllBits: function() {
		return this.generator.get_usesAllBits();
	}
	,nextInt: function() {
		return this.generator.nextInt();
	}
	,nextFullInt: function() {
		if(this.generator.get_usesAllBits()) {
			return this.generator.nextInt();
		} else {
			var num1 = this.generator.nextInt();
			var num2 = this.generator.nextInt();
			num2 = num2 >>> 16 | num2 << 16;
			return num1 ^ num2;
		}
	}
	,setStringSeed: function(seed) {
		this.setBytesSeed(haxe_io_Bytes.ofString(seed));
	}
	,setBytesSeed: function(seed) {
		var hash = haxe_crypto_Sha1.make(seed);
		this.set_seed(hash.getInt64(0));
	}
	,random: function() {
		var upper = this.nextFullInt() & 2097151;
		var lower = this.nextFullInt();
		var lhs = upper * Math.pow(2,32);
		var floatNum = UInt.toFloat(lower) + lhs;
		var result = floatNum * Math.pow(2,-53);
		return result;
	}
	,randomInt: function(lower,upper) {
		return Math.floor(this.random() * (upper - lower + 1)) + lower;
	}
	,uniform: function(lower,upper) {
		return this.random() * (upper - lower) + lower;
	}
	,choice: function(array) {
		return array[this.randomInt(0,array.length - 1)];
	}
	,shuffle: function(array) {
		var _g = 0;
		var _g1 = array.length - 1;
		while(_g < _g1) {
			var index = _g++;
			var randIndex = this.randomInt(index,array.length - 1);
			var tempA = array[index];
			var tempB = array[randIndex];
			array[index] = tempB;
			array[randIndex] = tempA;
		}
	}
	,__class__: seedyrng_Random
	,__properties__: {get_usesAllBits:"get_usesAllBits",set_state:"set_state",get_state:"get_state",set_seed:"set_seed",get_seed:"get_seed"}
};
var seedyrng_Xorshift128Plus = function() {
	this._currentAvailable = false;
	var this1 = new haxe__$Int64__$_$_$Int64(0,1);
	this.set_seed(this1);
};
$hxClasses["seedyrng.Xorshift128Plus"] = seedyrng_Xorshift128Plus;
seedyrng_Xorshift128Plus.__name__ = "seedyrng.Xorshift128Plus";
seedyrng_Xorshift128Plus.__interfaces__ = [seedyrng_GeneratorInterface];
seedyrng_Xorshift128Plus.prototype = {
	_seed: null
	,_state0: null
	,_state1: null
	,_current: null
	,_currentAvailable: null
	,get_usesAllBits: function() {
		return false;
	}
	,get_seed: function() {
		return this._seed;
	}
	,set_seed: function(value) {
		var b_high = 0;
		var b_low = 0;
		if(!(value.high != b_high || value.low != b_low)) {
			var this1 = new haxe__$Int64__$_$_$Int64(0,1);
			value = this1;
		}
		this._seed = value;
		this._state0 = value;
		this._state1 = seedyrng_Xorshift128Plus.SEED_1;
		this._currentAvailable = false;
		return value;
	}
	,get_state: function() {
		var bytes = new haxe_io_Bytes(new ArrayBuffer(33));
		bytes.setInt64(0,this._seed);
		bytes.setInt64(8,this._state0);
		bytes.setInt64(16,this._state1);
		bytes.b[24] = this._currentAvailable ? 1 : 0;
		if(this._currentAvailable) {
			bytes.setInt64(25,this._current);
		}
		return bytes;
	}
	,set_state: function(value) {
		if(value.length != 33) {
			throw haxe_Exception.thrown("Wrong state size " + value.length);
		}
		this._seed = value.getInt64(0);
		this._state0 = value.getInt64(8);
		this._state1 = value.getInt64(16);
		this._currentAvailable = value.b[24] == 1;
		if(this._currentAvailable) {
			this._current = value.getInt64(25);
		}
		return value;
	}
	,stepNext: function() {
		var x = this._state0;
		var y = this._state1;
		this._state0 = y;
		var b = 23;
		b &= 63;
		var b1;
		if(b == 0) {
			var this1 = new haxe__$Int64__$_$_$Int64(x.high,x.low);
			b1 = this1;
		} else if(b < 32) {
			var this1 = new haxe__$Int64__$_$_$Int64(x.high << b | x.low >>> 32 - b,x.low << b);
			b1 = this1;
		} else {
			var this1 = new haxe__$Int64__$_$_$Int64(x.low << b - 32,0);
			b1 = this1;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(x.high ^ b1.high,x.low ^ b1.low);
		x = this1;
		var a_high = x.high ^ y.high;
		var a_low = x.low ^ y.low;
		var b = 17;
		b &= 63;
		var b1;
		if(b == 0) {
			var this1 = new haxe__$Int64__$_$_$Int64(x.high,x.low);
			b1 = this1;
		} else if(b < 32) {
			var this1 = new haxe__$Int64__$_$_$Int64(x.high >> b,x.high << 32 - b | x.low >>> b);
			b1 = this1;
		} else {
			var this1 = new haxe__$Int64__$_$_$Int64(x.high >> 31,x.high >> b - 32);
			b1 = this1;
		}
		var a_high1 = a_high ^ b1.high;
		var a_low1 = a_low ^ b1.low;
		var b = 26;
		b &= 63;
		var b1;
		if(b == 0) {
			var this1 = new haxe__$Int64__$_$_$Int64(y.high,y.low);
			b1 = this1;
		} else if(b < 32) {
			var this1 = new haxe__$Int64__$_$_$Int64(y.high >> b,y.high << 32 - b | y.low >>> b);
			b1 = this1;
		} else {
			var this1 = new haxe__$Int64__$_$_$Int64(y.high >> 31,y.high >> b - 32);
			b1 = this1;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(a_high1 ^ b1.high,a_low1 ^ b1.low);
		this._state1 = this1;
		var a = this._state1;
		var high = a.high + y.high | 0;
		var low = a.low + y.low | 0;
		if(haxe_Int32.ucompare(low,a.low) < 0) {
			var ret = high++;
			high = high | 0;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(high,low);
		this._current = this1;
	}
	,nextInt: function() {
		if(this._currentAvailable) {
			this._currentAvailable = false;
			return this._current.low;
		} else {
			this.stepNext();
			this._currentAvailable = true;
			return this._current.high;
		}
	}
	,__class__: seedyrng_Xorshift128Plus
	,__properties__: {get_usesAllBits:"get_usesAllBits",set_state:"set_state",get_state:"get_state",set_seed:"set_seed",get_seed:"get_seed"}
};
function $getIterator(o) { if( o instanceof Array ) return new haxe_iterators_ArrayIterator(o); else return o.iterator(); }
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
$hxClasses["Math"] = Math;
if( String.fromCodePoint == null ) String.fromCodePoint = function(c) { return c < 0x10000 ? String.fromCharCode(c) : String.fromCharCode((c>>10)+0xD7C0)+String.fromCharCode((c&0x3FF)+0xDC00); }
String.prototype.__class__ = $hxClasses["String"] = String;
String.__name__ = "String";
$hxClasses["Array"] = Array;
Array.__name__ = "Array";
Date.prototype.__class__ = $hxClasses["Date"] = Date;
Date.__name__ = "Date";
var Int = { };
var Dynamic = { };
var Float = Number;
var Bool = Boolean;
var Class = { };
var Enum = { };
haxe_ds_ObjectMap.count = 0;
js_Boot.__toStr = ({ }).toString;
if(ArrayBuffer.prototype.slice == null) {
	ArrayBuffer.prototype.slice = js_lib__$ArrayBuffer_ArrayBufferCompat.sliceImpl;
}
EReg.escapeRe = new RegExp("[.*+?^${}()|[\\]\\\\]","g");
haxe_SysTools.winMetaCharacters = [32,40,41,37,33,94,34,60,62,38,124,10,13,44,59];
StringTools.winMetaCharacters = haxe_SysTools.winMetaCharacters;
StringTools.MIN_SURROGATE_CODE_POINT = 65536;
haxe_Int32._mul = Math.imul != null ? Math.imul : function(a,b) {
	return a * (b & 65535) + (a * (b >>> 16) << 16 | 0) | 0;
};
seedyrng_Xorshift128Plus.PARAMETER_A = 23;
seedyrng_Xorshift128Plus.PARAMETER_B = 17;
seedyrng_Xorshift128Plus.PARAMETER_C = 26;
seedyrng_Xorshift128Plus.SEED_1 = (function($this) {
	var $r;
	var this1 = new haxe__$Int64__$_$_$Int64(842650776,685298713);
	$r = this1;
	return $r;
}(this));
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
