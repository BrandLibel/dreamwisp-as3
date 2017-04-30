package dreamwisp.visual.particles 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class Particle 
	{
		internal var x:Number;
		internal var y:Number;
		internal var radius:int;
		internal var rotation:int;
		internal var scale:Number = 1;

		/// RGB color
		internal var color:uint;
		internal var alpha:Number = 1;
		internal var duration:Number;
		internal var percentLife:Number = 1;

		internal var velocityX:Number;
		internal var velocityY:Number;
		internal var origVelX:Number;
		internal var origVelY:Number;
		internal var friction:Number = 0.97;
		internal var rotationSpeed:Number;
		
		internal var bitmap:Bitmap;
		internal var srcImage:BitmapData;
		internal var rect:Rectangle;
		internal var point:Point;
		
		/// Takes Particle as argument, operates on position and velocity
		internal var moveBehavior:Function;
		/// Takes Particle as argument, operates on rect scaleX and scaleY
		internal var sizeBehavior:Function;
		/// Takes Particle as argument, operates on color and alpha
		internal var colorBehavior:Function;
		
		
		private static const ORIGIN:Point = new Point(0, 0);
		
		public function Particle() 
		{
			bitmap = new Bitmap(new BitmapData(8, 8));
			rect = new Rectangle();
			point = new Point();
		}
		
		public final function update(canvas:BitmapData):void 
		{
			moveBehavior.call(null, this);
			sizeBehavior.call(null, this);
			colorBehavior.call(null, this);
			
			percentLife -= 1.0 / duration;
			
			if (percentLife <= 0)
				percentLife = 0;
			
			/*var matrix:Matrix = new Matrix(1, 0, 0, 1, x, y);
			var colorTransform:ColorTransform = bitmap.transform.colorTransform;
			colorTransform.alphaMultiplier = bitmap.alpha;
			canvas.draw(bitmap, matrix, colorTransform);*/
			
			const bitmapData:BitmapData = bitmap.bitmapData;
			bitmapData.copyPixels(srcImage, rect, ORIGIN);
			
			const length:uint = rect.width * rect.height;
			var prevX:Number = rect.x;
			var prevY:Number = rect.y;
			rect.x = 0;
			rect.y = 0;
			
			var vector:Vector.<uint> = bitmapData.getVector(rect);
			for (var i:int = 0; i < length; i++) 
			{
				var x:int = i % rect.width;
				var y:int = i / rect.height;
				
				var ARGB:uint = vector[i];
				var alpha:uint = ((ARGB >> 24) & 0xFF) * this.alpha;
				var red:uint = (color >> 16) & 0xFF;
				var green:uint = (color >> 8) & 0xFF;
				var blue:uint = color & 0xFF;
				vector[i] = ( (alpha << 24) | (red << 16) | (green << 8) | blue );
			}
			bitmapData.setVector(rect, vector);
			
			canvas.copyPixels(bitmapData, rect, point, null, null, true);
			rect.x = prevX;
			rect.y = prevY;
			
			// OLD: lock(), getVector(), setPixel(), unlock() - slower than getPixel()
			//bitmapData.lock();
			/*const vector:Vector.<uint> = bitmapData.getVector(rect);
			for (var i:int = 0; i < vector.length; i++) 
			{
				const x:int = i % rect.width;
				const y:int = i / rect.height;
				const ARGB:uint = vector[i];
				const alpha:uint = 255 * percentLife;
				const red:uint = (ARGB >> 16) & 0xFF;
				const green:uint = (ARGB >> 8) & 0xFF;
				const blue:uint = ARGB & 0xFF;
					
				const newARGB:uint = ( (alpha << 24) | (red << 16) | (green << 8) | blue );
				bitmapData.setPixel32(x, y, newARGB);
			}*/
			
			// OLD: lock(), getPixel(), setPixel(), unlock() - slower than setVector()
			/*for (var i:int = 0; i < length; i++) 
			{
				const x:int = i % rect.width;
				const y:int = i / rect.height;
				
				const ARGB:uint = bitmapData.getPixel32(x, y);
				const alpha:uint = ((ARGB >> 24) & 0xFF) * this.alpha;
				const red:uint = (color >> 16) & 0xFF;
				const green:uint = (color >> 8) & 0xFF;
				const blue:uint = color & 0xFF;
				const newARGB:uint = ( (alpha << 24) | (red << 16) | (green << 8) | blue );
				
				bitmapData.setPixel32(x, y, newARGB);
			}
			bitmapData.unlock();*/
		}
		
	}

}