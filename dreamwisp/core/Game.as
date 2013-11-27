package dreamwisp.core {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.input.InputDispatcher;
	import dreamwisp.input.InputDispatcher;
	import dreamwisp.ui.menu.MenuScreen;
	import dreamwisp.visual.IGraphicsFactory;
	import flash.display.Stage;
	//import dreamwisp.ui.menu.MenuControl;
	import dreamwisp.world.base.Location;
	import flash.display.Sprite;
	import flash.events.Event;
	import tools.Belt;
	
	public dynamic class Game {
				
		public var view:Sprite;// = new Sprite();
		public var world:Location;// = new World();
		//public var menuControl:MenuControl;
		
		public var input:InputDispatcher;
				
		protected var screenManager:ScreenManager;
		protected var graphicsFactory:IGraphicsFactory;
		
		public var menus:Vector.<MenuScreen> = new <MenuScreen>[null];
						
		public function Game(stage:Stage = null) {
			//MonsterDebugger.trace(this, Data.worldData);
			Data.prepare();
			view = new Sprite();
			if (stage) input = new InputDispatcher(stage, null);
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
		
		/**
		 * The main game loop
		 */
		public function loop(e:Event):void {
			screenManager.update();
			screenManager.render();
		}
		
	}
	
}