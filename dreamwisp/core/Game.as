package dreamwisp.core 
{
	import dreamwisp.data.SaveSystem;
	import dreamwisp.input.InputState;
	import dreamwisp.visual.ContainerView;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.getTimer;
	
	public dynamic class Game
	{
		public var sprite:Sprite;
		public var screenManager:ScreenManager;
		public var saveSystem:SaveSystem;
		
		public var inputState:InputState;
		
		public function Game(stage:Stage = null)
		{
			sprite = new Sprite();
			if (stage) inputState = new InputState(stage);
			screenManager = new ScreenManager(this);
		}
		
		/**
		 * Perfrom a simple linear resize of the entire game sprite.
		 * @param	stage reference to the main stage
		 * @param	width the static project UI width
		 * @param	height the static project UI height
		 */
		public function rescale(stage:Stage, width:Number, height:Number):void 
		{
			var deviceWidth:Number = Math.min(stage.fullScreenWidth, stage.fullScreenHeight);
			var deviceHeight:Number = Math.max(stage.fullScreenWidth, stage.fullScreenHeight);
			var appWidth:Number = width;
			var appHeight:Number = height;
			var appScale:Number = 1;
			
			// if device is wider than GUI's aspect ratio, height determines scale
			if ( (deviceWidth / deviceHeight) > (width / height) )
			{
				appScale = deviceHeight / height;
				appWidth = deviceWidth / appScale;
			}
			// if device is taller than GUI's aspect ratio, width determines scale
			else
			{
				appScale = deviceWidth / width;
				appHeight = deviceHeight / appScale;
			}
			
			sprite.scaleX = appScale;
			sprite.scaleY = appScale;
		}
		
		public function loadGame():void { }
		
		public function save():void { }
		
		// Game updates per second
		private static const TICKS_PER_SECOND:int = 30;
		// framerate / ticks per second = frames per tick
		private static const SKIP_TICKS:uint = 1000 / TICKS_PER_SECOND;
		private static const MAX_FRAMESKIP:int = 5;
		
		private var nextGameTick:uint = getTimer();
		private var loops:uint = 0;
		private var interpolation:Number = 1;
		
		/**
		 * The main game loop, allowing update() to run at TICKS_PER_SECOND
		 * and render() to run at the SWF set framerate using interpolation.
		 * @param	e
		 */ 
		public function run():void 
		{
			loops = 0;
			while ( getTimer() > nextGameTick && loops < MAX_FRAMESKIP) 
			{
				screenManager.update(inputState);
				inputState.reset();
				nextGameTick += SKIP_TICKS;
				loops++;
			}
			// interpolation is the position a render is called between frames.
			interpolation = Number( getTimer() + SKIP_TICKS - nextGameTick ) / Number ( SKIP_TICKS );
			
			screenManager.render(interpolation);
		}
		
	}
	
}