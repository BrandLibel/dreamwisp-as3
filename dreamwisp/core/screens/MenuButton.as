package dreamwisp.core.screens 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class MenuButton 
	{
		private var button:SimpleButton;
		public var btnCode:String;
		
		public function MenuButton(graphic:DisplayObject, btnCode:String)
		{
			if (graphic is SimpleButton)
			{				
				button = SimpleButton(graphic);
				button.useHandCursor = false;
				button.mouseEnabled = false;
			}
			
			this.btnCode = btnCode;
		}
		
		public function update():void 
		{
			
		}
		
		public function select():void 
		{
			const upState:DisplayObject = button.upState;
			button.upState = button.overState;
			button.overState = upState;
		}
		
		public function deselect():void 
		{
			select();
		}
		
		public function hitTestPoint(x:int, y:int):Boolean 
		{
			return button.hitTestPoint(x, y);
		}
		
		/// Disables the button and lowers its alpha
		public function lock():void 
		{
			button.enabled = false;
			button.alpha = 0.5;
		}
		
		public function isLocked():Boolean { return !button.enabled }
		
		/// Returns the button or movieClip displayObject that represents this button.
		public function getDisplayObject():DisplayObject { return button; }
		
	}

}