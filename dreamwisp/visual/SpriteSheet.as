package dreamwisp.visual 
{
	//import com.demonsters.debugger.MonsterDebugger;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	/**
	 * SpriteSheet is the sprite sheet image bundled with its JSON data file.
	 * @author Brandon
	 */

	public class SpriteSheet 
	{
		private var image:BitmapData;
		private var dictionary:Dictionary;
		
		public function SpriteSheet(image:BitmapData, rawJSON:Object) 
		{
			this.image = image;
			// store all valid rawJSON sections into a dictionary
			dictionary = new Dictionary();
			var sectionNames:Array = [];
			for (var title:String in rawJSON)
			{
				// skip over objects or invalid arrays
				if (!(rawJSON[title] is Array))
					continue;
				if (!isValid( rawJSON[title] ))
					continue;
				sectionNames.push( title );
			}
			for (var i:int = 0; i < sectionNames.length; i++) 
				dictionary[sectionNames[i]] = rawJSON[sectionNames[i]];
			
		}
		
		public function getImage():BitmapData
		{
			return image;
		}
		
		public function access(sectionName:String, subSection:uint):Object 
		{
			return dictionary[sectionName][subSection];
		}
		
		/**
		 * Verifies that all items in the section has necessary fields for being drawn.
		 */
		private function isValid(section:Array):Boolean 
		{
			// go through the section array, checking for the needed properties, etc.
			for each (var item:Object in section) 
			{
				//if (!section.hasOwnProperty("sourceImage"))
				//	return false;
				if (!item.frame && !item.frames)
					return false;
				if (!item.spriteSourceSize)
					return false;
			}
			
			return true;
		}
	}

}