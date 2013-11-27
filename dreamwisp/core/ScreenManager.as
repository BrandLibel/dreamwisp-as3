package dreamwisp.core {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.visual.IGraphicsObject;
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
		private var waitList:Vector.<GameScreen> = new Vector.<GameScreen>;
		private var game:Game;
				
		public function ScreenManager(game:Game) {
			this.game = game;
		}
		
		//TODO: Allow ScreenManager to keep a shared menubackground that related screens use.
		//		When transitioning, only the content would transition and the background would
		//		remain in place. 
		
		public function update():void {
			game.input.receptor = top;
			// item on the wait list already exists in master list and is holding up the line
			// process it immediately so it is removed
			if (waitList.length > 0 && top == waitList[0])
				processPendingScreens();
			// no screens, try taking one from the waiting list
			// if a screen is concurrent, force the waitList and let both screens
			// run their transitions together.
			if (screens.length == 0 || (waitList.length != 0 && waitList[0].isConcurrent) ||
				screens[screens.length-1].isConcurrent)
				processPendingScreens();
			// a popup needs to enter despite the existence of an unexited screen
			if (waitList.length > 0 && waitList[0].isPopup)
				processPendingScreens();
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
					screen.update();
					if (screen.state == GameScreen.STATE_HIDDEN) {
						// necessary because if it gets hidden before rendering,
						// the screen will still appear at a very low alpha
						screen.render();
						// let a waiting screen come in when screen finishes transitioning out
						processPendingScreens();
					}
				}
				
				// active screens 
				if (screen.state == GameScreen.STATE_ACTIVE || screen.isPopup) {
					if (!screen.canRunScreensBelow)
						coveredByOtherScreen = true;
				}
			}
		}
		
		public function render():void {
			for each (var screen:GameScreen in screens) {
				if (screen.state == GameScreen.STATE_HIDDEN)
					continue;
				screen.render();
			}
		}
		
		public function pendScreen(screen:GameScreen):void {
			//TODO: A screen can be added to the waitList even though it is 
			//		already present in the master list. This happens
			//		because when a popup screen appears it does not tell the screen
			//		below it to exit. So when the popup screen exits itself and returns 
			//		to the previous screen, it pends a duplicate of the previous screen
			//		into the waitList, 
			screen.screenManager = this;
			// only consider adding if it hasn't already been added, attemps to fix above bug
			// problem: cannot start game
			//if (screens.indexOf(screen) == -1)
				waitList.push( screen );
			//MonsterDebugger.trace(this, waitList, "", "Wait List");
			// Attempts to fix the above bug by treating the covered screen as removed
			// problem: unintuitive, messy. Do not remove, simply have isPopup set isCoveredByScreen.
			//if (screen.isPopup)
				//removeScreen( top );
			if (screens.length != 0 && !screen.isPopup) {
				// exit all screens below that aren't the new screen
				for each (var screenBelow:GameScreen in screens) {
					if (screenBelow == screen) continue;
					screenBelow.exit();
				}
				//top.exit();
			}
		}
		
		/**
		 * Instantly remove a screen
		 * @param	screen
		 */
		public function removeScreen(screen:GameScreen):void {
			screens.splice( screens.indexOf(screen), 1);
			tempScreensList.splice( screens.indexOf(screen), 1);
			//game.view.removeChild( screen.view.container );
		}
		
		/**
		 * Moves a screen from the waiting list to the active list.
		 */
		public function processPendingScreens():void {
			if (waitList.length == 0) return;
			var screen:GameScreen = waitList.shift();
			
			// preventing duplicates from entering the list
			if (screens.indexOf(screen) == -1) {
				screen.enter();
				screens.push(screen);
				// only add displayObject to screen if needed
				if (!game.view.contains(screen.view.container))
					game.view.addChild( screen.view.container );
			}
			
			//MonsterDebugger.trace(this, screens, "", "Master List");
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
			if (screens.length > 0)
				return screens[screens.length - 1];
			return null;
		}
		
	}

}