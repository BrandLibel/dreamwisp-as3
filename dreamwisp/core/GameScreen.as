package dreamwisp.core {
	
	import dreamwisp.core.Game;
	import dreamwisp.core.ScreenManager;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import dreamwisp.input.InputState;
	import dreamwisp.input.KeyMap;
	import dreamwisp.swift.geom.SwiftRectangle;
	import dreamwisp.visual.camera.Camera;
	import dreamwisp.visual.camera.ICamUser;
	import dreamwisp.visual.ContainerView;
	import dreamwisp.entity.EntityManager;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public class GameScreen {
		
		public var screenManager:ScreenManager;
		/// Whether this screen allows logic & drawing of those behind it.
		public var canRunScreensBelow:Boolean = false;
		public var canBelowHandleInput:Boolean = false;
		public var isPopup:Boolean = false;
		public var isConcurrent:Boolean = false;
		
		public var game:Game;
				
		protected var paused:Boolean = false;
	
		public var view:ContainerView;
		
		protected var keyMap:KeyMap;
		
		// transition related
		public static const STATE_TRANSITION_IN:uint = 0;
		public static const STATE_TRANSITION_OUT:uint = 1;
		public static const STATE_ACTIVE:uint = 2;
		public static const STATE_HIDDEN:uint = 3;
		private static const DIR_ON:int = 1;
		private static const DIR_OFF:int = -1;
		public var state:uint;
		/// Indicates the screen is transitioning off to die.
		private var isExiting:Boolean = false;
		/// Indicates progress of transition. 0 is fully out, 1 is fully in.
		/// Can be used as a multiplier for many visual properties (x, y, alpha, etc.)
		protected var transitionPosition:Number = 0;
		protected var transitionTimeIn:Number = 0.05;
		protected var transitionTimeOut:Number = 0.05;
		private var transitionDelta:Number;
		/// The transitionPosition above which this screen is considered active for input.
		protected var activeThreshold:Number = 0;
				
		public var rect:SwiftRectangle;
		public var entityManager:EntityManager;
		public var camera:Camera;
		
		public function GameScreen(game:Game) {
			this.game = game;
		}
		
		public function cleanup():void {
			
		}
		
		public function pause():void {
			paused = true;
		}
		
		public function resume():void {
			paused = false;
		}
		
		public function handleInput(inputState:InputState):void {
			// if this screen personally handles key input, let it
			if (keyMap)
				keyMap.readInput(inputState);
			// if the entitys want to handle input in their special way, let them
			if (entityManager)
				entityManager.handleInput(inputState);
		}
		
		public function update():void {
			if (state == STATE_TRANSITION_IN) {
				if (!updateTransition(DIR_ON))
					state = STATE_ACTIVE;
			}
			else if (state == STATE_TRANSITION_OUT) {
				if (!updateTransition(DIR_OFF)) {
					// finished transition off, don't render anymore
					state = STATE_HIDDEN;
					// screen marked as 'exiting' means it gets removed as well
					if (isExiting) screenManager.removeScreen( this );
				}
			}
			
			if (inActiveHalf()) {
				if (entityManager) entityManager.update();
			}
		}
		
		public function render(interpolation:Number):void {
			//if (paused) return;
			renderTransition(interpolation);
			if (entityManager) entityManager.render(interpolation);
			if (view) {
				// TODO: this block is temporary; it allows the ContainerView to be synced
				// 		 with the x and y values of the actual Location (necessary for proper placement
				//		 of Levels in Areas). 
				if (rect) {
					view.x = rect.x;
					view.y = rect.y;
				}
				
				view.render(interpolation);
			}
			if (inActiveHalf())
				if (camera) camera.render(interpolation);
		}
		
		private function updateTransition(direction:int):Boolean {
			//TODO: use timer & milliseconds to determine delta
			transitionDelta = (direction < 0) ? transitionTimeOut : transitionTimeIn;
			
			transitionPosition += transitionDelta * direction;
			
			// Reached the end of the transition
			if ( (direction == DIR_OFF && transitionPosition <= 0) ||
				 (direction == DIR_ON && transitionPosition >= 1)) {
				return false;
			}
			// Still transitioning.
			return true;
		}
		
		/**
		 * Draws the transition in the style decided by the Screen.
		 * @param	direction
		 */
		protected function renderTransition(interpolation:Number):void {
			var direction:int = (state == STATE_TRANSITION_IN) ? 1 : -1;
			var transitionOffset:Number = Number(Math.pow(transitionPosition, 2));
			
			view.alpha = transitionPosition;// += (transitionDelta * interpolation);
			//view.x = -direction * (1 - transitionPosition) * 768;
			//view.scaleX = transitionPosition;
			//view.scaleY = transitionPosition;
		}
		
		public function inTransition():Boolean {
			return (state == STATE_TRANSITION_IN || state == STATE_TRANSITION_OUT);
		}
		
		public function inActiveHalf():Boolean {
			return ((state == STATE_TRANSITION_IN && transitionPosition >= activeThreshold) || state == STATE_ACTIVE);
		}
		
		/**
		 * Tell the screen to start gradually transitioning in.
		 */
		public function enter():void {
			if (transitionTimeIn > 0) {
				transitionPosition = 0;
				state = STATE_TRANSITION_IN;
			}
			else {
				transitionPosition = 1;
				state = STATE_ACTIVE;
			}
			//renderTransition();
		}

		/**
		 * Tell the screen to start gradually transitioning out.
		 */
		public function exit():void {
			if (transitionTimeOut > 0) {
				transitionPosition = 1;
				state = STATE_TRANSITION_OUT;
				isExiting = true;
			}
			// subclass says it has no transition
			else {
				// go invisible instantly
				transitionPosition = 0;
				render(1);
				screenManager.removeScreen(this);
			}
		}
		
	}

}