package dreamwisp.visual {
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class BasicGraphicsFactory implements IGraphicsFactory {
		
		private var graphics:Object;
		
		/**
		 * 
		 * @param	graphics A hash-table with name and bitmapData/displayObject pairs.
		 */
		public function BasicGraphicsFactory(graphics:Object) {
			this.graphics = graphics;
		}
		
		/* INTERFACE dreamwisp.visual.IGraphicsFactory */
		
		/**
		 * 
		 * @param	type
		 * @param	name
		 * @param	data Object with all data required by a specific GraphicsOject.
		 * @return
		 */
		public function getGraphicsObject(type:String, name:String, data:Object = null):IGraphicsObject {
			MonsterDebugger.trace(this, graphics[name]);
			if (type == "Bitmap")
				return new PassiveGraphic(Bitmap(graphics[name]), data.x, data.y);
			if (type == "AutoScrollGraphic")
				return new AutoScrollGraphic(new Bitmap(graphics[name]), data.x, data.y, data.scrollSpeedX, data.scrollSpeedY);
			// type is SpritesheetAnimation
				// give reference to the spriteSheet graphics["sourceSpriteSheetName"] and the relevant animation data
			// type is MovieclipAnimation
				// give MC graphic, and the relevant animation data
			return null;
		}
		
	}

}