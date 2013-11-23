package dreamwisp.core {
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Sprite;
	import project.world.World;
	
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
		/// Buffer list that allows screens to fully transition off before adding new ones.
		private var waitingList:Vector.<GameScreen> = new Vector.<GameScreen>;
		private var game:Game;
		
		public function ScreenManager(game:Game) {
			this.game = game;
			
		}
		
		public function update():void {
			//top.update();
			// no screens, try taking one from the waiting list
			if (screens.length == 0)
				processPendingScreens();
			// For this update tick, make a copy of the screen list to avoid confusion
			// if updating one screen adds/removes others and alters the list.
			tempScreensList.length = 0;
			for each (var tempScreen:GameScreen in screens) {
				tempScreensList.push(tempScreen);
			}
			
			var screen:GameScreen;
			var otherScreenHasFocus:Boolean = false;
			var coveredByOtherScreen:Boolean = false;
			while (tempScreensList.length > 0) {
				// pop the screen being worked on from the working list
				screen = tempScreensList[tempScreensList.length - 1];
				tempScreensList.pop();
				// run logic and draw if uncovered by others
				if (!coveredByOtherScreen) {
					screen.update();
					screen.render();
					//if (screen is World)
						//MonsterDebugger.trace(this, screen.view.alpha);
					// if, upon updating, screen becomes hidden, let a waiting screen come in 
					if (screen.screenState == GameScreen.STATE_HIDDEN) {
						processPendingScreens();
					}
				}
				if (!otherScreenHasFocus) // handleInput();
				// active screens
				if (screen.screenState == GameScreen.STATE_TRANSITION_IN ||
					screen.screenState == GameScreen.STATE_ACTIVE) {
					if (!screen.canRunScreensBelow)
						coveredByOtherScreen = true;
				}
			}
		}
		
		public function render():void {
			top.render();
		}
		
		public function pendScreen(screen:GameScreen):void {
			screen.screenManager = this;
			
			waitingList.push( screen );
			
			// ask current screen to transition off if necessary? use if statements
			if (screens.length != 0) top.exit();
			// if (screen.bypassWaitList) add directly to screens
			// used when two screens transition at the same time
			/*if (!screen.canRunScreensBelow)
				top.screenState = GameScreen.STATE_TRANSITION_OUT;*/
		}
		
		/**
		 * Instantly remove a screen
		 * @param	screen
		 */
		public function removeScreen(screen:GameScreen):void {
			screens.splice( screens.indexOf(screen), 1);
			tempScreensList.splice( screens.indexOf(screen), 1);
		}
		
		/**
		 * Moves a screen from the waiting list to the active list.
		 */
		public function processPendingScreens():void {
			if (waitingList.length == 0) return;
			var screen:GameScreen = waitingList.shift();
			screen.enter();
			game.input.receptor = screen;
			// only add displayObject to screen if needed
			if (!game.view.contains(screen.view.container))
				game.view.addChild( screen.view.container );
			screens.push( screen );
			
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