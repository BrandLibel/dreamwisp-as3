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
		public var x:int;
		public var y:int;
		public var radius:int;
		public var rotation:int;
		public var scale:Number = 1;

		/// RGB color
		public var color:uint;
		public var duration:Number;
		public var percentLife:Number = 1;

		public var velocityX:Number;
		public var velocityY:Number;
		public var friction:Number = 0.97;
		public var rotationSpeed:Number;
		
		public var bitmap:Bitmap;
		public var srcImage:BitmapData;
		public var rect:Rectangle;
		private var point:Point;
		
		private static const ORIGIN:Point = new Point(0, 0);
		
		public function Particle() 
		{
			bitmap = new Bitmap(new BitmapData(8, 8));
			
			rect = new Rectangle();
			point = new Point();
		}
		
		public final function update(canvas:BitmapData):void 
		{
			x += velocityX;
			y += velocityY;
			velocityX *= friction;
			velocityY *= friction;
			point.x = x;
			point.y = y;
			
			scale = percentLife * percentLife;
			bitmap.scaleX *= scale;
			bitmap.scaleY *= scale;
			
			bitmap.alpha = percentLife;
			
			percentLife -= 1.0 / duration;
			
			if (percentLife <= 0)
				percentLife = 0;
			
			/*var matrix:Matrix = new Matrix(1, 0, 0, 1, x, y);
			var colorTransform:ColorTransform = bitmap.transform.colorTransform;
			colorTransform.alphaMultiplier = bitmap.alpha;
			canvas.draw(bitmap, matrix, colorTransform);*/
			
			const bitmapData:BitmapData = bitmap.bitmapData;
			bitmapData.copyPixels(srcImage, rect, ORIGIN);
			bitmapData.lock();
			
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
			
			const length:uint = rect.width * rect.height;
			for (var i:int = 0; i < length; i++) 
			{
				const x:int = i % rect.width;
				const y:int = i / rect.height;
				
				//const ARGB:uint = bitmapData.getPixel32(x, y);
				const alpha:uint = 255 * percentLife;
				const red:uint = (color >> 16) & 0xFF;
				const green:uint = (color >> 8) & 0xFF;
				const blue:uint = color & 0xFF;
				const newARGB:uint = ( (alpha << 24) | (red << 16) | (green << 8) | blue );
				
				bitmapData.setPixel32(x, y, newARGB);
			}
			
			bitmapData.unlock();
			const prevX:Number = rect.x;
			const prevY:Number = rect.y;
			rect.x = 0;
			rect.y = 0;
			canvas.copyPixels(bitmapData, rect, point, null, null, true);
			rect.x = prevX;
			rect.y = prevY;
		}
		
	}

}