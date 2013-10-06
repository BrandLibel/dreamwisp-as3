package dreamwisp.state {
	
	import flash.display.Sprite;
	
	/**
	 * The GameStateSystem is a core class that allows multiple GameStates
	 * to be represented in the same Game at the same time.
	 * 
	 * Only the topmost GameState in the stack has update() and render()
	 * called by this class. When added to the tree, each GameState gets a reference
	 * to the GameState below it. It decides whether or not to update the object 'below'.
	 * 
	 * @author Brandon
	 */
	
	public class GameStateSystem {
		
		/// Active gameStates in a stack-like behavior.
		private var gameStates:Vector.<IGameState> = new Vector.<IGameState>;
		/// List of all possible game states.
		private var gameStateBank:Vector.<IGameState> = new Vector.<IGameState>;
		private var sprite:Sprite;
		
		public function GameStateSystem() {
			
		}
		
		public function update():void {
			top.update();
		}
		
		public function render():void {
			top.render();
		}
		
		public function addState(gameState:IGameState):void {
			gameStates.push( gameState );
			if (gameStates.length > 1) gameState.below = gameStates[gameStates.length -2];
		}
		
		/**
		 * Removes the top item in the stack.
		 * @param	gameState
		 * @return	The item that was removed.
		 */
		public function removeState():IGameState {
			return gameStates.pop();
		}
		
		public function get top():IGameState {
			return gameStates[gameStates.length - 1];
		}
		
	}

}