package dreamwisp.ui.menu {
	
	import dreamwisp.visual.Animatable;
	import dreamwisp.visual.AnimHandler;
	import flash.geom.Rectangle;
	import tools.Belt;
	import flash.display.MovieClip;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	/**
	 * ...
	 * @author Brandon
	 */
	 
	//TODO: make Asset extend Entity, with only an AnimHandler and View 
	//	making AnimHandler the component replacing Animation
	 
	public class Asset extends AnimHandler {
		
		private const LEFT:String = "left";
		private const CENTER:String = "center";
		private const RIGHT:String = "right";
		
		private const TOP:String = "top";
		private const MIDDLE:String = "middle";
		private const BOTTOM:String = "bottom";
		
		private var _movieClip:MovieClip;
		private var _displayList:uint;
		private var scrollRect:Rectangle;
				
		public function Asset(data:Object) {
			/// Attaching the movieClip from library by string name
			_movieClip = Belt.addClassFromLibrary(data.classLink, Belt.CLASS_MOVIECLIP);
			//_movieClip.cacheAsBitmap = true;
			/// Setting the x and y position of the movieClip 
			_movieClip.x = (data.x is String) ? decipherValue(data.x) : data.x;
			_movieClip.y = (data.y is String) ? decipherValue(data.y) : data.y;
			
			if (data.canScroll) {
				if (data.scrollSpeedX != 0) {
					//x.animateTo(data.scrollLimitX, data.scrollSpeedX);
					x.init(0, 0, data.scrollLimitX, true);
					x.setActions(null, x.toMin, null);
					//x.reachedMin = x.bounce;
					//x.reachedMax = x.bounce;
					x.animate(data.scrollSpeedX, 0, data.scrollLimitX, data.updateRate);
				}
				if (data.scrollSpeedY != 0) {
					//y.animateTo(data.scrollLimitY, data.scrollSpeedY);
					y.init(0, 0, data.scrollLimitY, true);
					y.animate(data.scrollSpeedX, 0, data.scrollLimitY, data.updateRate);
				}
				
				scrollRect = new Rectangle(0, 0, Data.STAGE_WIDTH, Data.STAGE_HEIGHT);
				_movieClip.scrollRect = scrollRect;
				actual = scrollRect;
			} 
			nullify();
		}
		
		/**
		 * If the x or y values were set to a string keyword, this determines the appropriate
		 * value according to 
		 * @param	value The string value representing behavior 
		 * @return
		 */
		private function decipherValue(value:String):uint {
			var result:uint = 0;
			switch (value) {
				/// for x values
				case LEFT:
					break;
				case CENTER: 
					result = (Data.STAGE_WIDTH - _movieClip.width) / 2;
					break;
				case RIGHT:
					break;
				/// for y values
				case TOP:
					result = 0 + (_movieClip.height / 2);
					break;
				case MIDDLE:
					break;
				case BOTTOM:
					break;
			}
			return result;
		}
		
		override public function render():void {
			super.render();
			_movieClip.scrollRect = scrollRect;
		}
		
		public function get movieClip():MovieClip { return _movieClip; }
		
		/// This asset's index on the display list.		
		public function get displayList():uint { return _displayList; }
		
		
	}

}