package dreamwisp.core {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.input.InputState;
	import dreamwisp.ui.menu.MenuScreen;
	import dreamwisp.visual.IGraphicsFactory;
	import flash.display.Stage;
	import flash.utils.getTimer;
	import dreamwisp.world.base.Location;
	import flash.display.Sprite;
	import flash.events.Event;
	import tools.Belt;
	
	public dynamic class Game {
				
		public var view:Sprite;
		public var world:Location;
		
		protected var inputState:InputState;
				
		protected var screenManager:ScreenManager;
		protected var graphicsFactory:IGraphicsFactory;
		
		public var menus:Vector.<MenuScreen> = new <MenuScreen>[null];
						
		public function Game(stage:Stage = null) {
			//MonsterDebugger.trace(this, Data.worldData);
			Data.prepare();
			view = new Sprite();
			if (stage) inputState = new InputState(stage);
			screenManager = new ScreenManager(this);
			
			//newGame();
		}
		
		public function newGame():void {
			trace("This is never reached if overriden");
		}
		
		public function loadGame():void {
	
		}
		
		public function save():void {
			
		}
		
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
		public function run():void {
			loops = 0;
			while ( getTimer() > nextGameTick && loops < MAX_FRAMESKIP) {
				screenManager.update(inputState.update());
				nextGameTick += SKIP_TICKS;
				loops++;
			}
			// interpolation is the position a render is called between frames.
			interpolation = Number( getTimer() + SKIP_TICKS - nextGameTick ) / Number ( SKIP_TICKS );
			
			screenManager.render(interpolation);
		}
		
	}
	
}