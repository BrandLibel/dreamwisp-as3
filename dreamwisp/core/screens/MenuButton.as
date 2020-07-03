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
		private var isOriginal:Boolean = true;
		public var btnCode:String;
		public var btnNum:uint;
		protected var hasLock:Boolean = false;
		
		public function MenuButton(graphic:DisplayObject, btnCode:String, btnNum:uint)
		{
			if (graphic is SimpleButton)
			{				
				button = graphic as SimpleButton;
				button.useHandCursor = false;
				button.mouseEnabled = false;
				button.enabled = false;
			}
			
			this.btnCode = btnCode;
			this.btnNum = btnNum;
		}
		
		public function update():void 
		{
			
		}
		
		public function select():void 
		{
			if (isOriginal)
			{
				const upState:DisplayObject = button.upState;
				button.upState = button.overState;
				button.overState = upState;
				isOriginal = false;
			}
		}
		
		public function deselect():void 
		{
			if (!isOriginal)
			{
				const upState:DisplayObject = button.upState;
				button.upState = button.overState;
				button.overState = upState;
				isOriginal = true;
			}
		}
		
		public function hitTestPoint(x:int, y:int):Boolean 
		{
			return button.hitTestPoint(x, y);
		}
		
		/// Disables the button and lowers its alpha
		public function lock():void 
		{
			hasLock = true;
			button.alpha = 0.5;
		}
		
		public function unlock():void 
		{
			hasLock = false;
			button.alpha = 1;
		}
		
		public function toggleLock():void 
		{
			if (isLocked())
				unlock();
			else
				lock();
		}
		
		public function isOriginalState():Boolean { return isOriginal; }
		
		public function isLocked():Boolean { return hasLock; }
		
		/// Returns the button or movieClip displayObject that represents this button.
		public function getDisplayObject():DisplayObject { return button; }
		
	}

}