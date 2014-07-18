package dreamwisp.core {
	
	import dreamwisp.input.InputState;
	
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
		private var waitList:Vector.<GameScreen> = new Vector.<GameScreen>;
		private var game:Game;
				
		public function ScreenManager(game:Game) {
			this.game = game;
		}
		
		//TODO: Allow ScreenManager to keep a shared menubackground that related screens use.
		//		When transitioning, only the content would transition and the background would
		//		remain in place. 
		
		public function update(inputState:InputState):void {
			// item on the wait list already exists in master list and is holding up the line
			// process it immediately so it is removed
			if (waitList.length > 0 && top == waitList[0])
				activateScreen();
			// no screens, try taking one from the waiting list
			// if a screen is concurrent, force the waitList and let both screens
			// run their transitions together.
			if (screens.length == 0 || (waitList.length != 0 && waitList[0].isConcurrent) ||
				screens[screens.length-1].isConcurrent)
				activateScreen();
			// a popup needs to enter despite the existence of an unexited screen
			if (waitList.length > 0 && waitList[0].isPopup)
				activateScreen();
			// For this update tick, make a copy of the screen list to avoid confusion
			// if updating one screen adds/removes others and alters the list.
			tempScreensList.length = 0;
			for each (var tempScreen:GameScreen in screens)
				tempScreensList.push(tempScreen);
			
			var screen:GameScreen;
			var coveredByOtherScreen:Boolean = false;
			while (tempScreensList.length > 0) {
				// pop the screen being worked on from the working list
				screen = tempScreensList.pop();
				
				// run screen if uncovered. it always runs if in middle of a transition
				// ...because 
				// when a screen bypasses waitlist, the screen under it doesn't get
				// to reach this finished/hidden state until the bypassing screen
				// exits itself. This is because the bypasser runs concurrently with the
				// screen below until it finishes and reaches STATE_ACTIVE, causing the
				// screen below to think it is covered and miss the last update cycle. 
				// This then causes the screen after the bypasser to come
				// in early because processPendingScreen() gets caused twice in a row.
				// The latter part of the OR makes sure it can properly register as hidden.
				if (!coveredByOtherScreen || screen.inTransition()) {
					// screens between transition in and active state are considered in Active half
					
					// TODO: Prevent input spillover to next screen when input causes a Popup screen to close.
					// This is NOT caused because the two screens in same while loop as the Popup inputs itself out
					// These problems are probably caused by the user holding down a key longer than a frame 1/30th of a second. 
					// The screen changes in one frame, the game updates and the input resets. In the next frame, InputState
					// reads the over 1/30th key hold and registers the key as pressed. When InputState is then passed in to 
					// the KeyMap of a Screen/Entity, the keymap also registers it as a press and launches any of the relevant
					// PressAction functions. THIS IS BAD.
					if (screen.inActiveHalf())
						screen.handleInput(inputState);
						
					screen.update();
					if (screen.state == GameScreen.STATE_HIDDEN) {
						// necessary because if it gets hidden before rendering,
						// the screen will still appear at a very low alpha
						screen.render(1);
						// let a waiting screen come in when screen finishes transitioning out
						activateScreen();
					}
				}
				
				// active screens 
				if (screen.state == GameScreen.STATE_ACTIVE || screen.isPopup) {
					if (!screen.canRunScreensBelow)
						coveredByOtherScreen = true;
				}
			}
		}
		
		public function render(interpolation:Number):void {
			for each (var screen:GameScreen in screens) {
				if (screen.state == GameScreen.STATE_HIDDEN)
					continue;
				screen.render(interpolation);
			}
		}
		
		public function pendScreen(screen:GameScreen):void {
			screen.screenManager = this;
			waitList.push( screen );
			//MonsterDebugger.trace(this, waitList, "", "Wait List");
			if (screens.length != 0 && !screen.isPopup) {
				// exit all screens below that aren't the new screen
				for each (var screenBelow:GameScreen in screens) {
					if (screenBelow == screen) continue;
					screenBelow.exit();
				}
			}
		}
		
		/**
		 * Instantly remove a screen
		 * @param	screen
		 */
		public function removeScreen(screen:GameScreen):void {
			screens.splice( screens.indexOf(screen), 1);
			tempScreensList.splice( screens.indexOf(screen), 1);
			game.removeContainerView( screen.view );
		}
		
		/**
		 * Moves the first screen in the waiting list to the active list.
		 */
		private function activateScreen():void {
			if (waitList.length == 0) return;
			var screen:GameScreen = waitList.shift();
			
			// preventing duplicates from entering the list
			if (screens.indexOf(screen) == -1) {
				screen.enter();
				screens.push(screen);
				// only add displayObject to screen if needed
				game.addContainerView(screen.view);
			}
		}
		
		public function get top():GameScreen {
			if (screens.length > 0)
				return screens[screens.length - 1];
			return null;
		}
		
	}

}