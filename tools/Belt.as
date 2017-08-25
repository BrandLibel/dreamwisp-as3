package tools
{
	//import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.visual.Frame;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public final class Belt
	{
		
		public final function Belt()
		{
		
		}
		
		public static function randomNumber(bound1:Number, bound2:Number):Number{
			var min:Number = (bound1 < bound2) ? bound1 : bound2;
			var max:Number = (bound1 > bound2) ? bound1 : bound2;
			return (Math.random() * (max - min)) + min;
		}
		
		public static function valueIsBetween(value:Number, limit1:Number, limit2:Number, inclusive:Boolean = true):Boolean
		{
			var min:Number;
			var max:Number;
			min = (limit1 < limit2) ? limit1 : limit2;
			max = (limit2 > limit1) ? limit2 : limit1;
			
			if (min < value && value < max)
				return true;
			if (min <= value && value <= max)
			{
				if (inclusive)
					return true;
			}
			return false;
		}
		
		public static function isArrayEqual(arr1:Array, arr2:Array):Boolean
		{
			if (arr1.length != arr2.length)
			{
				return false;
			}
			for (var i:int = 0; i < arr1.length; i++)
			{
				if (arr1[i] != arr2[i])
				{
					return false;
				}
			}
			return true;
		}
		
		public static function getXInRelationTo(xPos:int, targetX:int):int
		{
			if (xPos - targetX < 0)
			{
				//trace("you are to the left");
				return -1; //target is to the left
			}
			else if (xPos - targetX > 0)
			{
				//trace("you are to the right");
				return 1; //target is to the right
			}
			else
			{
				return 0;
			}
		}
		
		public static function getDistance(Obj1:Object, Obj2:Object):Number
		{
			var dx:int = Obj1.x - Obj2.x;
			var dy:int = Obj1.y - Obj2.y;
			return Math.abs(Math.sqrt(dx * dx + dy * dy));
		}
		
		public static function getSignOf(number:Number):int
		{
			//var sign:int = number / Math.abs(number);
			return (number < 0) ? -1 : 1; //sign;
		}
		
		/// Converts a 2d array to a string
		public static function arrayToString(a:Array, tabs:uint = 0):String
		{
			var outputString:String = "";
			var comma:String = ",";
			var tab:String = "	";
			for (var i:uint = 0; i < a.length; i++)
			{
				if (i == a.length - 1)
					comma = "";
				for (var j:uint = 0; j < tabs; j++)
				{
					outputString += tab;
				}
				//outputString += tab + tab;
				outputString += ("[" + a[i] + "]" + comma + "\n");
			}
			return outputString;
		}
		
		public static function tabs(num:uint):String
		{
			const tab:String = "\t";
			var str:String = "";
			for (var i:int = 0; i < num; i++) 
			{
				str += tab;
			}
			return str;
		}
		
		public static const CLASS_MOVIECLIP:uint = 0;
		
		public static function addClassFromLibrary(className:String, classType:uint):*
		{
			var xClass:Class = getDefinitionByName(className) as Class;
			var newClass:*;
			switch (classType)
			{
				case CLASS_MOVIECLIP: 
					// when dealing with MovieClips from .swc files, remember to right-click > options > include completely
					newClass = new xClass() as MovieClip;
					break;
			}
			//var newClass:MovieClip = new xClass() as MovieClip;
			return newClass;
		}
		
		/// Round a number to a certain amount of decimal places
		public static function toFixed(number:Number, decPlaces:uint):Number
		{
			var precision:Number = Math.pow(10, decPlaces);
			return (Math.round(number * precision) / precision);
		}
		
		public static function getDecimalPlaces(number:Number):uint
		{
			var original:Number = number;
			var rounded:Number = number;
			var i:int = 0;
			for (i; i < int.MAX_VALUE; i++)
			{
				rounded = toFixed(number, i);
				if (original == rounded)
					break;
			}
			return i;
		}
		
		public static function copyVariables(source:Object, target:Object):void
		{
			for (var name:String in source)
			{
				if (target[name])
					target[name] = source[name];
			}
		}
		
		public static function scaleFromCenter(displayObject:DisplayObject, sX:Number, sY:Number):void 
		{
			var prevW:Number = displayObject.width;
			var prevH:Number = displayObject.height;
			displayObject.scaleX = sX;
			displayObject.scaleY = sY;
			displayObject.x += (prevW - displayObject.width) / 2;
			displayObject.y += (prevH - displayObject.height) / 2;
		}
		
		public static function scaleToWidth(sprite:*, value:Number):void {
			var multiplier:Number = value / sprite.width;
			sprite.width = value;
			sprite.height = multiplier * sprite.height;
		}
		public static function scaleToHeight(sprite:*, value:Number):void {
			var multiplier:Number = value / sprite.height;
			sprite.height = value;
			sprite.width = multiplier * sprite.width;
		}
		
		/// Transfer all children from a simple MC into a Sprite
		public static function mcToSprite(mc:MovieClip, xDistrMultiplier:Number = 1, yDistrMultiplier:Number = 1):Sprite
		{
			var sprite:Sprite = new Sprite();
			var numChildren:int = mc.numChildren;
			for (var i:int = 0; i < numChildren; i++) 
			{
				var child:DisplayObject = mc.getChildAt(0);
				child.x = child.x * xDistrMultiplier;
				child.y = child.y * yDistrMultiplier;
				sprite.addChild(child);
			}
			return sprite;
		}
		
		public static function convertToBitmap(displayObject:DisplayObject):Bitmap
		{
			//MonsterDebugger.trace(displayObject, displayObject.width + "x" + displayObject.height);
			var bitmapData:BitmapData = new BitmapData(displayObject.width, displayObject.height, true, 0x000000);
			// draw using coordinates with respect to itself; prevents cutoff converting to bitmap
			var bounds:Rectangle = displayObject.getBounds(displayObject);
			bitmapData.drawWithQuality(displayObject, new Matrix(1, 0, 0, 1, -bounds.left, -bounds.top), null, null, null, false, StageQuality.BEST);
			return new Bitmap(bitmapData);
		}
		
		public static function mcToFrames(mc:MovieClip, scale:Number = 1):Vector.<Frame> 
		{
			var frames:Vector.<Frame> = new Vector.<Frame>;
			var matrix:Matrix = new Matrix(1, 0, 0, 1);
			
			for (var i:int = 0; i < mc.totalFrames; i++) 
			{
				// note: movieclips in flash pro should have a center registration point
				// e.g. their x & y are negative and half of the width & height
				
				var bounds:Rectangle = mc.getRect(mc);
				matrix.tx = -bounds.x;
				matrix.ty = -bounds.y;
				
				// Math.ceil is necessary to prevent clipping when an MC dimension ends up on fraction of a pixel
				// e.g. width is 19.95
				var bitmapData:BitmapData = new BitmapData(Math.ceil(bounds.width), Math.ceil(bounds.height), true, 0);
				bitmapData.draw(mc, matrix);
				
				var fr:Frame = new Frame();
				fr.bitmapData = bitmapData;
				fr.x = -matrix.tx;
				fr.y = -matrix.ty;
				fr.originalWidth = Math.abs(bounds.x) * 2;
				fr.originalHeight = Math.abs(bounds.y) * 2;
				fr.label = mc.currentLabel;
				
				frames.push(fr);
				mc.nextFrame();
			}
			return frames;
		}
		
		public static function flipBitmapData(original:BitmapData, x:Number = 1, y:Number = 1):BitmapData 
		{
			var flipped:BitmapData = new BitmapData(original.width, original.height, true, 0);
			var matrix:Matrix
			if (x != 1)
				matrix = new Matrix( x, 0, 0, 1, original.width, 0);
			else if (y != 1)
				matrix = new Matrix( 1, 0, 0, y, 0, original.height);
			flipped.draw(original, matrix, null, null, null, true);
			return flipped;
		}
		
		public static function randomSign():int
		{
			return (Math.random() > 0.5) ? 1 : -1;
		}
		
		private static var keyDict:Dictionary;
		
		public static function getKeyDict():Dictionary
		{
			if (keyDict == null)
			{
				var keyDescription:XML = describeType(Keyboard);
				var keyNames:XMLList = keyDescription..constant.@name;

				keyDict = new Dictionary();

				var len:int = keyNames.length();
				for(var i:int = 0; i < len; i++) {
					keyDict[Keyboard[keyNames[i]]] = keyNames[i];
				}
			}
			return keyDict;
		}
		
		public static function nameOfKey(keyCode:uint):String
		{
			return getKeyDict()[keyCode];
		}
		
		/* COLOR RELATED FUNCTIONS */
		
		public static function combineRGB(r:uint, g:uint, b:uint):uint
		{
			return (r << 16) | (g << 8) | b << 0;
		}
		
		/**
		 * 
		 * @param	rgb1
		 * @param	rgb2
		 * @param	t
		 * @param	tTotal
		 * @param	rInterp main render interpolation calculated by game loop
		 * @return
		 */
		public static function interpolateColor(rgb1:uint, rgb2:uint, t:uint, tTotal:uint, rInterp:Number = 1):uint
		{
			var r1:uint = (rgb1 >> 16 & 0xFF);
			var g1:uint = (rgb1 >>  8 & 0xFF);
			var b1:uint = (rgb1 >>  0 & 0xFF);
			
			var r2:uint = (rgb2 >> 16 & 0xFF);
			var g2:uint = (rgb2 >>  8 & 0xFF);
			var b2:uint = (rgb2 >>  0 & 0xFF);
			
			var interpolation:Number = (t % tTotal) / tTotal;
			interpolation *= rInterp;
			
			var r3:uint = r1 + (r2 - r1) * interpolation;
			var g3:uint = g1 + (g2 - g1) * interpolation;
			var b3:uint = b1 + (b2 - b1) * interpolation;
			return r3 << 16 | g3 << 8 | b3;
		}
		
		/**
		 * Converts a RGB color into three 0.0 - 1.0 multiplier values.
		 * These are for tinting displayObjects via ColorTransform multipliers.
		 */
		public static function rgbToMultipliers(rgb:uint):Array
		{
			var colors:Array = [];
			colors[0] = (rgb >> 16 & 0xFF) / 0xFF;
			colors[1] = (rgb >>  8 & 0xFF) / 0xFF;
			colors[2] = (rgb >>  0 & 0xFF) / 0xFF;
			return colors;
		}
		
		public static function rgbToHSV(rgb:uint):Array
		{
			var r:Number = (rgb >> 16 & 0xFF) / 0xFF;
			var g:Number = (rgb >>  8 & 0xFF) / 0xFF;
			var b:Number = (rgb >>  0 & 0xFF) / 0xFF;
			
			const cMax:Number = Math.max(r, g, b);
			const cMin:Number = Math.min(r, g, b);
			const delta:Number = cMax - cMin;
			
			var h:Number;
			if (cMax == r)
				h = 60 * (int((g - b) / delta) % 6);
			else if (cMax == g)
				h = 60 * (((b - r) / delta) + 2);
			else if (cMax == b)
				h = 60 * (((r - g) / delta) + 4);
				
			// correct negative values; happens whenever h is -60
			if (h < 0)
				h += 360;
				
			var s:Number;
			if (cMax == 0)
				s = 0;
			else
				s = delta / cMax;
			
			var v:Number = cMax;
			
			return [h, s, v];
		}
		
		/// Converts a HSV color into an array of r, g, b multiplier (0.0 - 1.0) values
		public static function hsvToMultipliers(h:int, s:Number, v:Number):Array 
		{
			var c:Number = v * s;
			var x:Number = c * (1 - Math.abs(((h / 60) % 2) - 1));
			var m:Number = v - c;
			
			// r, g, b end up as values between 0.0 - 1.0
			var r:Number;
			var g:Number;
			var b:Number;
			
			if (h < 60)
			{
				r = c;
				g = x;
				b = 0;
			}
			else if (h < 120)
			{
				r = x;
				g = c;
				b = 0;
			}
			else if (h < 180)
			{
				r = 0;
				g = c;
				b = x;
			}
			else if (h < 240)
			{
				r = 0;
				g = x;
				b = c;
			}
			else if (h < 300)
			{
				r = x;
				g = 0;
				b = c;
			}
			else if (h < 360)
			{
				r = c;
				g = 0;
				b = x;
			}
			
			return [r + m, g + m, b + m];
		}
		
		public static function hsvToRGB(h:int, s:Number, v:Number):uint
		{
			var rgb:Array = hsvToMultipliers(h, s, v);
			return (rgb[0] * 0xFF) << 16 | (rgb[1] * 0xFF) << 8 | (rgb[0] * 0xFF);
		}
		
		public static function toARGB(rgb:uint, newAlpha:uint):uint
		{
			var argb:uint = 0;
			argb = (rgb);
			argb += (newAlpha << 24);
			return argb;
		}
		
		public static function cmykToRGB( C:Number, M:Number, Y:Number, K:Number):uint
		{
			var Rnum:Number = 0.0;
			var Gnum:Number = 0.0;
			var Bnum:Number = 0.0;

			Rnum = 255 * (1 - C) * (1 - K);
			Gnum = 255 * (1 - M) * (1 - K);
			Bnum = 255 * (1 - Y) * (1 - K);

			var R:uint = Math.round(Rnum);
			var G:uint = Math.round(Gnum);
			var B:uint = Math.round(Bnum);
			
			return combineRGB(R, G, B);
		}
		
		/**
		 * 
		 * @param	stringHash For example, #ffffff
		 */
		public static function stringHashToRGB(stringHash:String):uint
		{
			return uint("0x" + stringHash.slice(1));
		}

		
		/**
		 * Applies a color transformation to the provided displayObject
		 * @param	displayObject the thing to apply color transform to
		 * @param	r the red multiplier (0.0 - 1.0)
		 * @param	g the green multiplier (0.0 - 1.0)
		 * @param	b the blue multiplier (0.0 - 1.0)
		 */ 
		public static function applyTint(displayObject:DisplayObject, r:Number, g:Number, b:Number):ColorTransform 
		{
			var colorTransform:ColorTransform = displayObject.transform.colorTransform;
			colorTransform.redMultiplier = r;
			colorTransform.greenMultiplier = g;
			colorTransform.blueMultiplier = b;
			displayObject.transform.colorTransform = colorTransform;
			return colorTransform;
		}
		
	}
}