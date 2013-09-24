package dreamwisp.core {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.input.InputDispatcher;
	import dreamwisp.input.InputDispatcher;
	import dreamwisp.ui.menu.Menu;
	import dreamwisp.state.IGameState;
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
				
		protected var gameState:IGameState;
		
		public var menus:Vector.<Menu> = new <Menu>[null];
						
		public function Game(stage:Stage = null) {
			//MonsterDebugger.trace(this, Data.worldData);
			Data.prepare();
			view = new Sprite();
			if (stage) input = new InputDispatcher(stage, gameState);
			//newGame();
		}
		
		public function newGame():void {
			trace("This is never reached if overriden");
		}
		
		public function loadGame():void {
	
		}
		
		public function save():void {
			
		}
		
		/*public function bridgeStates(oldState:IGameState, newState:IGameState):void {
			// use menucontrol findstate()
			oldState.transition.fadeOut(0.05);
			//oldState.transition.finishedExit.add(changeState);
			changeState(newState);
		}*/
		
		/**
		 * 
		 * @param	newState
		 * @param	transition Must contain: type, targetVal, speed. 
		 * 			Optional: startVal.
		 */
		public function changeState(newState:IGameState, transition:Object = null):void {
			
			if (gameState) {
				//MonsterDebugger.trace(this, view.getChildIndex(gameState.view.container));
				//MonsterDebugger.trace(this, view.getChildIndex(newState.view.container));
				// controlling the visual layering of gameStates, so the newState is always on top
				if (view.getChildIndex(newState.view.container) < view.getChildIndex(gameState.view.container)) {
					view.swapChildren(gameState.view.container, newState.view.container);
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
			gameState = newState;
			gameState.setGame(this);
			gameState.enter();
			
			
			if (transition) {
				gameState.transition.start(transition);
			} else {
				// TransitionManager always affects the visual, reset to prevent 
				gameState.transition.reset();
			}
			
			if (input) input.receptor = gameState;
		}
		
		/**
		 * The main game loop
		 */
		public function loop(e:Event):void {
			gameState.update();
			gameState.render();
		}
		
	}
	
}