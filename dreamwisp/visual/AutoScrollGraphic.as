package dreamwisp.visual
{
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * AutoScrollGraphic is a graphics object that continually
	 * scrolls an art asset
	 * @author Brandon
	 */
	
	public class AutoScrollGraphic extends GraphicsObject
	{
		
		/*
		   {
		   "classLink": "Nebula",
		   "type": "AutoScrollGraphic",
		   "canScroll": true,
		   "updateRate": 1,
		   "scrollSpeedX": 1,
		   "scrollSpeedY": 0,
		   "scrollLimitX": 4609,
		   "scrollLimitY": 0,
		   "animated": false,
		   "x": 0,
		   "y": 0
		   },
		 */
		
		private var scrollingGraphic:DisplayObject;
		private var scrollRect:Rectangle;
		
		/// Width of the scrollRect 'window'
		private var viewWidth:Number;
		/// Height of the scrollRect 'window'
		private var viewHeight:Number;
		
		private var xVelocity:int;
		private var yVelocity:int;
		
		public function AutoScrollGraphic(displayObject:DisplayObject,
			x:Object = 0, y:Object = 0, xVelocity:int = 0, yVelocity:int = 0)
		{
			super(displayObject, x, y);
			scrollingGraphic = displayObject;
			width = displayObject.width;
			height = displayObject.height;
			this.yVelocity = yVelocity;
			this.xVelocity = xVelocity;
		}
		
		/* INTERFACE dreamwisp.visual.IGraphicsObject */
		
		override public function update():void
		{
			//MonsterDebugger.trace(this, scrollRect.x);
			
			scrollRect.x += xVelocity;
			scrollRect.y += yVelocity;
			// horizontal movement
			if (xVelocity > 0)
			{
				if (scrollRect.x > rightBound())
					scrollRect.x = 0;
			}
			if (xVelocity < 0)
			{
				if (scrollRect.x < 0)
					scrollRect.x = rightBound();
			}
			// vertical movement
			if (yVelocity > 0)
			{
				//if (y > scrollLimitY) 
			}
			if (yVelocity < 0)
			{
				
			}
		}
		
		override public function render():void
		{
			scrollingGraphic.scrollRect = scrollRect;
		}
		
		override public function initialize():void
		{
			scrollRect = new Rectangle(0, 0, parentWidth, parentHeight);
			scrollingGraphic.scrollRect = scrollRect;
		}
		
		override public function getGraphicsData():DisplayObject
		{
			return scrollingGraphic;
		}
		
		private function leftBound():Number
		{
			return (x);
		}
		
		private function topBound():Number
		{
			return (y);
		}
		
		/// returns the right line where the scroll rect resets
		private function rightBound():Number
		{
			return (width - parentWidth);
		}
		
		/// returns the bottom line where the scroll rect resets
		private function bottomBound():Number
		{
			return (height - parentHeight);
		}
	
	}

}