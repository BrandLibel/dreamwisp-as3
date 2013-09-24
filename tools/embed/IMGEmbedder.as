package tools.embed {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	/**
	 * 
	 */
	
	public class IMGEmbedder {
		
		public static function load(Embedded:Class):BitmapData {
			var dispObj:DisplayObject = new Embedded();
			var bitmapData:BitmapData = new BitmapData(dispObj.width, dispObj.height, true, 0x00000000);
			bitmapData.draw(dispObj);
			return bitmapData;
		}
		
	}

}