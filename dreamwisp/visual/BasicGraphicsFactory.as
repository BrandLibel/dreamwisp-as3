package dreamwisp.visual {
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import tools.Belt;
	
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
			var displayObject:DisplayObject = findDisplayObject(name);
			if (type == "PassiveGraphic")
				return new PassiveGraphic(displayObject, data.x, data.y);
			if (type == "AutoScrollGraphic")
				return new AutoScrollGraphic(displayObject, data.x, data.y, data.scrollSpeedX, data.scrollSpeedY);
			// type is SpritesheetAnimation
				// give reference to the spriteSheet graphics["sourceSpriteSheetName"] and the relevant animation data
			// type is MovieclipAnimation
				// give MC graphic, and the relevant animation data
			return null;
		}
		
		private function findDisplayObject(name:String):DisplayObject {
			// search imported .swc files for a movieClip with this class name
			if (!graphics.hasOwnProperty(name))
				return Belt.addClassFromLibrary(name, Belt.CLASS_MOVIECLIP);
			// instantiate a new bitmap with the data found
			if (graphics[name] is BitmapData)
				return new Bitmap(graphics[name]);
			return graphics[name];
		}
		
	}

}