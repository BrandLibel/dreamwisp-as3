package tools {
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	public final class Belt {
		
		private static var instance:Belt = new Belt();
		
		public final function Belt() {
			if (instance){
				throw new Error ("Do not create an instance of this class; this is static.");
			}
		}
		
		public static function getInstance():Belt {
			return instance;
		}
		
		public static function valueIsBetween(value:Number, limit1:Number, limit2:Number, inclusive:Boolean = true):Boolean {
			var min:Number;
			var max:Number;
			min = (limit1 < limit2) ? limit1 : limit2;
			max = (limit2 > limit1) ? limit2 : limit1;
			
			if (min < value && value < max) return true;
			if (min <= value && value <= max) {
				if (inclusive) return true;
			}
			return false;
		}
		
		public static function isArrayEqual(arr1:Array, arr2:Array):Boolean {
			if (arr1.length != arr2.length){
				return false;
			}
			for (var i:int = 0; i < arr1.length; i++){
				if (arr1[i] != arr2[i]){
					return false;
				}
			}
			return true;
		}
		
		public static function getXInRelationTo(xPos:int, targetX:int):int {
			if (xPos - targetX < 0){
				//trace("you are to the left");
				return -1; //target is to the left
			} else if (xPos - targetX > 0){
				//trace("you are to the right");
				return 1; //target is to the right
			} else {
				return 0;
			}
		}
		
		public static function getDistance(Obj1:Object, Obj2:Object):Number {
			var dx:int = Obj1.x-Obj2.x;
			var dy:int = Obj1.y-Obj2.y;
			return Math.abs(Math.sqrt(dx*dx+dy*dy));
		}
		
		public static function toARGB(rgb:uint, newAlpha:uint):uint {
			var argb:uint = 0;
			argb = (rgb);
			argb += (newAlpha<<24);
			return argb;
		}
		
		public static function getSignOf(number:Number):int {
			//var sign:int = number / Math.abs(number);
			return (number < 0) ? -1 : 1;//sign;
		}
		
		/// Converts a 2d array to a string
		public static function arrayToString(a:Array, tabs:uint = 0):String {
			var outputString:String = "";
			var comma:String = ",";
			var tab:String = "	";
			for (var i:uint = 0; i < a.length; i++){
				if (i == a.length - 1) comma = "";
				for (var j:uint = 0; j < tabs; j++) { outputString += tab; }
				//outputString += tab + tab;
				outputString += ("[" + a[i] + "]" + comma +"\n");
			}
			return outputString;
		}
		
		public static const CLASS_MOVIECLIP:uint = 0;
		
		public static function addClassFromLibrary(className:String, classType:uint):* {
			var xClass:Class = getDefinitionByName(className) as Class;
			var newClass:*;
			switch (classType) {
				case CLASS_MOVIECLIP:
					// when dealing with MovieClips from .swc files, remember to right-click > options > include completely
					newClass = new xClass() as MovieClip;
					break;
			}
			//var newClass:MovieClip = new xClass() as MovieClip;
			return newClass;
		}
		
		public static function toFixed(number:Number, decPlaces:uint):Number {
			var precision:Number = Math.pow(10, decPlaces);
			return (Math.round(number * precision)/precision);
		}
		
		public static function getDecimalPlaces(number:Number):uint {
			var original:Number = number;
			var rounded:Number = number;
			var i:int = 0;
			for (i; i < int.MAX_VALUE; i++) {
				rounded = toFixed(number, i);
				if (original == rounded) break;
			}
			return i;
		}
		
		public static function copyVariables(source:Object, target:Object):void {
			for (var name:String in source) {
				if (target[name]) target[name] = source[name];
			}
		}
		
		public static function convertToBitmap(displayObject:DisplayObject):Bitmap {
			MonsterDebugger.trace(displayObject, displayObject.width + "x" + displayObject.height);
			var bitmapData:BitmapData = new BitmapData(displayObject.width, displayObject.height, true, 0x000000);
			// draw using coordinates with respect to itself; prevents cutoff converting to bitmap
			var bounds:Rectangle = displayObject.getBounds(displayObject);
			bitmapData.draw(displayObject, new Matrix(1,0,0,1,-bounds.left,-bounds.top));
			return new Bitmap(bitmapData);
		}
		
	}
}