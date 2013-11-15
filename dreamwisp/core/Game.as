package dreamwisp.core {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.input.InputDispatcher;
	import dreamwisp.input.InputDispatcher;
	import dreamwisp.ui.menu.Menu;
	import dreamwisp.visual.IGraphicsFactory;
	import dreamwisp.visual.VisualHandler;
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
		public var visualHandler:VisualHandler;
				
		protected var gameScreen:GameScreen;
		protected var graphicsFactory:IGraphicsFactory;
		
		public var menus:Vector.<Menu> = new <Menu>[null];
						
		public function Game(stage:Stage = null) {
			//MonsterDebugger.trace(this, Data.worldData);
			Data.prepare();
			view = new Sprite();
			if (stage) input = new InputDispatcher(stage, gameScreen);
			//newGame();
		}
		
		public function newGame():void {
			trace("This is never reached if overriden");
		}
		
		public function loadGame():void {
	
		}
		
		public function save():void {
			
		}
		
		public function hideAllMenus():void {
			for each (var menu:Menu in menus) {
				if (menu) menu.view.container.visible = false;
			}
		}
		
		/**
		 * 
		 * @param	newState
		 * @param	transition Must contain: type, targetVal, speed. 
		 * 			Optional: startVal.
		 */
		public function changeState(newState:GameScreen, transition:Object = null):void {
			
			if (gameScreen) {
				//MonsterDebugger.trace(this, view.getChildIndex(gameState.view.container));
				//MonsterDebugger.trace(this, view.getChildIndex(newState.view.container));
				// controlling the visual layering of gameStates, so the newState is always on top
				if (view.getChildIndex(newState.view.container) < view.getChildIndex(gameScreen.view.container)) {
					view.swapChildren(gameScreen.view.container, newState.view.container);
				}
				//MonsterDebugger.trace(this, view.getChildIndex(gameState.view.container));
				//MonsterDebugger.trace(this, view.getChildIndex(newState.view.container));
				newState.view.container.alpha = 1;
				/*MonsterDebugger.trace(this,
					view.getChildIndex(menus[1].view.container) 
					+ "," + view.getChildIndex(menus[2].view.container)
					+ "," + view.getChildIndex(world.view.container)
				);*/
			}
			gameScreen = newState;
			gameScreen.setGame(this);
			gameScreen.enter();
			
			
			if (transition) {
				gameScreen.transition.start(transition);
			} else {
				// TransitionManager always affects the visual, reset to prevent 
				gameScreen.transition.reset();
			}
			
			if (input) input.receptor = gameScreen;
		}
		
		/**
		 * The main game loop
		 */
		public function loop(e:Event):void {
			if (!gameScreen) return;
			gameScreen.update();
			gameScreen.render();
		}
		
	}
	
}