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
		
	}

}