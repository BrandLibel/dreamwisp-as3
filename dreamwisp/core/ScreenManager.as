package dreamwisp.core {
	
	import flash.display.Sprite;
	
	/**
	 * The ScreenManager is a core class that allows multiple GameScreens
	 * to be represented in the same Game at the same time.
	 * 
	 * Only the topmost GameScreen in the stack has update() and render()
	 * called by this class. When added to the tree, each GameState gets a reference
	 * to the GameState below it. It decides whether or not to update the object 'below'.
	 * 
	 * @author Brandon
	 */
	
	public class ScreenManager {
		
		/// Active gameStates in a stack-like behavior.
		private var screens:Vector.<GameScreen> = new Vector.<GameScreen>;
		private var tempScreensList:Vector.<GameScreen> = new Vector.<GameScreen>;
		/// List of all possible game states.
		private var gameStateBank:Vector.<GameScreen> = new Vector.<GameScreen>;
		private var sprite:Sprite;
		
		public function ScreenManager() {
			
		}
		
		public function update():void {
			top.update();
			
			// For this update tick, make a copy of the screen list to avoid confusion
			// if updating one screen adds/removes others and alters the list.
			tempScreensList.length = 0;
			for each (var tempScreen:GameScreen in screens) {
				tempScreensList.push(tempScreen);
			}
			
			var screen:GameScreen;
			
			while (tempScreensList.length > 0) {
				screen = tempScreensList[tempScreensList.length - 1];
				screen.update();
			}
		}
		
		public function render():void {
			top.render();
		}
		
		public function addScreen(screen:GameScreen):void {
			screen.screenManager = this;
			
			screens.push(screen);
		}
		
		public function removeScreen(screen:GameScreen):void {
			
		}
		
		public function addState(gameState:GameScreen):void {
			screens.push( gameState );
			if (screens.length > 1) gameState.below = screens[screens.length -2];
		}
		
		/**
		 * Removes the top item in the stack.
		 * @param	gameState
		 * @return	The item that was removed.
		 */
		public function removeState():GameScreen {
			return screens.pop();
		}
		
		public function get top():GameScreen {
			return screens[screens.length - 1];
		}
		
	}

}