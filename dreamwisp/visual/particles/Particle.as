package dreamwisp.visual.particles 
{
	import flash.display.Sprite;
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
		public var scale:int;

		public var color:int;
		public var duration:Number;
		public var percentLife:Number = 1;

		public var velocityX:Number;
		public var velocityY:Number;
		public var rotationSpeed:Number;
		
		public var sprite:Sprite;
		
		public function Particle() 
		{
			sprite = new Sprite();
			sprite.cacheAsBitmap = true;
			sprite.graphics.beginFill(0x3DC9FE);
			sprite.graphics.drawRect(0, 0, 6, 6);
		}
		
	}

}