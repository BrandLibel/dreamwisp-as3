package dreamwisp.ui 
{
	import flash.text.TextField;
	
	/**
	 * TypeWriter transfers a String to a TextField bit-by-bit.
	 * @author Brandon
	 */
	
	public class TypeWriter 
	{
		private var textField:TextField;
		private var loadedText:String;
		private var displayedText:String;
		private var transferSpeed:uint;
		
		public function TypeWriter(textField:TextField, transferSpeed:uint = 1)
		{
			this.textField = textField;
			this.transferSpeed = transferSpeed;
		}
		
		public function load(text:String):void 
		{
			loadedText = text;
			displayedText = "";
		}
		
		/**
		 * Transfers a cut of the loaded text onto the display.
		 * @return true if still has text to transfer, false otherwise
		 */
		public function write():Boolean
		{
			var charsToTransfer:uint = transferSpeed;
			while (charsToTransfer > 0)
			{
				var cutString:String = loadedText.substr(0, 1);
				// counts an HTML tag as a single character.
				if (cutString == "<")
					cutString = loadedText.substr(0, loadedText.indexOf(">"));
				displayedText += cutString;
				loadedText = loadedText.substr(cutString.length);
				charsToTransfer--;
			}
			
			if (loadedText.length == 0)
				return false;
			return true;
		}
		
		/**
		 * Completely transfer all loaded text to the display
		 */
		public function finish():void 
		{
			displayedText += loadedText;
			loadedText = "";
		}
		
		public function render():void 
		{
			textField.htmlText = displayedText;
		}
		
	}
}