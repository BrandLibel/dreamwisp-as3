package dreamwisp.visual
{
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import tools.Belt;
	
	/**
	 * ChameleonGraphic holds a still image that can be manipulated.
	 * @author Brandon
	 */
	
	public class PassiveGraphic extends GraphicsObject
	{
		
		private var bitmap:Bitmap;
		
		public function PassiveGraphic(displayObject:DisplayObject, x:Object = 0, y:Object = 0)
		{
			this.bitmap = Belt.convertToBitmap(displayObject);
			super(displayObject, x, y);
		}
		
		override public function getGraphicsData():DisplayObject
		{
			return bitmap;
		}
	
	}

}