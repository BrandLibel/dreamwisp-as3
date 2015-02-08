package dreamwisp.core.screens 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class MenuButtonMC extends MenuButton 
	{
		private var movieClip:MovieClip;
		private var playVelocity:int = 0;
		
		private var hasLock:Boolean = false;
		
		public function MenuButtonMC(graphic:DisplayObject, btnCode:String) 
		{
			super(graphic, btnCode);
			movieClip = MovieClip(graphic);
			
			// verify movieClip has all frame labels necessary
			movieClip.gotoAndStop("over");
			movieClip.gotoAndStop("up");
			
			movieClip.useHandCursor = false;
			movieClip.mouseEnabled = false;
		}
		
		override public function update():void 
		{
			if (playVelocity == 1)
			{
				movieClip.nextFrame();
				if (movieClip.currentFrameLabel == "over")
					playVelocity = 0;
			}
			else if (playVelocity == -1)
			{
				movieClip.prevFrame();
				if (movieClip.currentFrameLabel == "up")
					playVelocity = 0;
			}
		}
		
		override public function select():void 
		{
			// play forwards
			playVelocity = 1;
		}
		
		override public function deselect():void 
		{
			// play backwards
			playVelocity = -1;
		}
		
		override public function lock():void 
		{
			hasLock = true;
			movieClip.alpha = 0.5;
		}
		
		override public function unlock():void 
		{
			hasLock = false;
			movieClip.alpha = 1;
		}
		
		override public function isLocked():Boolean { return hasLock; }
		
		override public function hitTestPoint(x:int, y:int):Boolean 
		{
			return movieClip.hitTestPoint(x, y);
		}
		
		override public function getDisplayObject():DisplayObject { return movieClip; }
	}

}