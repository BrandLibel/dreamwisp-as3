package dreamwisp.visual.particles 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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

		public var color:int;
		public var duration:Number;
		public var percentLife:Number = 1;

		public var velocityX:Number;
		public var velocityY:Number;
		public var friction:Number = 0.97;
		public var rotationSpeed:Number;
		
		public var bitmap:Bitmap;
		private var rect:Rectangle;
		private var point:Point;
		
		public function Particle() 
		{
			var bitmapData:BitmapData = new BitmapData(8, 8);
			bitmap = new Bitmap(bitmapData);
			
			rect = new Rectangle(0, 0, 8, 8);
			point = new Point(0, 0);
			bitmapData.copyPixels(Data.tileSheet, rect, point);
		}
		
		public function init():void 
		{
			bitmap.visible = true;
		}
		
		public function update(canvas:BitmapData):void 
		{
			x += velocityX;
			y += velocityY;
			velocityX *= friction;
			velocityY *= friction;
			point.x = x;
			point.y = y;
			
			scale = percentLife * percentLife;
			bitmap.scaleX = scale;
			bitmap.scaleY = scale;
			
			percentLife -= 1.0 / duration;
			
			if (percentLife <= 0)
				bitmap.visible = false;
				
			canvas.copyPixels(bitmap.bitmapData, rect, point);
		}
		
	}

}