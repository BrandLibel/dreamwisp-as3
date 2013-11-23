package dreamwisp.core {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.core.Game;
	import dreamwisp.entity.components.Body;
	import dreamwisp.input.IInputManager;
	import dreamwisp.input.IInputReceptor;
	import dreamwisp.core.ScreenManager;
	import dreamwisp.swift.geom.SwiftRectangle;
	import dreamwisp.visual.camera.Camera;
	import dreamwisp.visual.camera.ICamUser;
	import dreamwisp.visual.ContainerView;
	import dreamwisp.world.base.EntityManager;
	import org.osflash.signals.Signal;
	import project.world.World;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public class GameScreen implements IInputManager {
		
		public var screenManager:ScreenManager;
		/// Whether this screen allows logic & drawing of those behind it.
		public var canRunScreensBelow:Boolean = false;
		public var canBelowHandleInput:Boolean = false;
		public var canUpdateBelow:Boolean = false;
		public var canRenderBelow:Boolean = false;
		
		protected var game:Game;
				
		protected var paused:Boolean = false;
		protected var takesInput:Boolean = true;
	
		private var _view:ContainerView;
		
		// transition related
		public static const STATE_TRANSITION_IN:uint = 0;
		public static const STATE_TRANSITION_OUT:uint = 1;
		public static const STATE_ACTIVE:uint = 2;
		public static const STATE_HIDDEN:uint = 3;
		private static const DIR_ON:int = 1;
		private static const DIR_OFF:int = -1;
		public var screenState:uint;
		/// Indicates the screen is transitioning off to die.
		private var isExiting:Boolean = false;
		/// Indicates progress of transition. 0 is fully out, 1 is fully in.
		/// Can be used as a multiplier for many visual properties (x, y, alpha, etc.)
		private var transitionPosition:Number = 1;
		protected var transitionTimeIn:Number = 0.05;
		protected var transitionTimeOut:Number = 0.05;
				
		private var _heardMouseInput:Signal;
		private var _heardKeyInput:Signal;
		private var _enabledInput:Signal;
		private var _disabledInput:Signal;
		
		private var _rect:SwiftRectangle;
		private var _entityManager:EntityManager;
		private var _camera:Camera;
		
		public function GameScreen() {
			heardMouseInput = new Signal(String, int, int);
			heardKeyInput = new Signal(String, uint);
		}
		
		public function cleanup():void {
			
		}
		
		public function pause():void {
			paused = true;
		}
		
		public function resume():void {
			paused = false;
		}
		
		public function enableInput():void {
			takesInput = true;
		}
		
		public function disableInput():void {
			takesInput = false;
		}
		
		public function update(coveredByOtherScreen:Boolean = false):void {
			
			//WORK IN PROGRESS - GAME SCREEN STATE MACHINE
			//note: microsoft's system has an update() that is always called.
			//		the virtual handleInput() with param inputState can be implemented
			//		by a subclass. inputState holds all input information - where the
			//		mouse is, what keys are being held, etc.
			
			if (screenState == STATE_TRANSITION_IN) {
				takesInput = true;
				if (camera) camera.update();
				if (!updateTransition(DIR_ON))
					screenState = STATE_ACTIVE;
			}
			// TODO: disable input while transition out, to prevent waitlist from getting duplicates
			if (screenState == STATE_TRANSITION_OUT) {
				takesInput = false;
				if (!updateTransition(DIR_OFF)) {
					// finished transition off, hide or remove
					screenState = STATE_HIDDEN;
					if (isExiting) screenManager.removeScreen( this );
				}
			}
			// mocking transition visual data
			//view.alpha = transitionPosition;
			//view.container.alpha = transitionPosition;
			if (screenState == STATE_ACTIVE) {
				// update everything it can
				if (entityManager) entityManager.update();
				if (camera) camera.update();
			}
			
			
		}
		
		private function updateTransition(direction:int):Boolean {
			//TODO: use timer & milliseconds to determine delta
			const transitionDelta:Number = transitionTimeIn;
			
			transitionPosition += transitionDelta * direction;
			//MonsterDebugger.trace(this, "transition: " + transitionPosition);
			// Reached the end of the transition?
			if ( (direction == DIR_OFF && transitionPosition <= 0) ||
				 (direction == DIR_ON && transitionPosition >= 1)) {
				return false;
			}
			// Still transitioning.
			return true;
		}
		
		public function render():void {
			//if (paused) return;
			view.alpha = transitionPosition;
			if (this is World)
				MonsterDebugger.trace(this, this.view.alpha);
			//view.x = (1 - transitionPosition) * 768;
			if (entityManager) entityManager.render();
			if (view) {
				// TODO: this block is temporary; it allows the ContainerView to be synced
				// 		 with the x and y values of the actual Location (necessary for proper placement
				//		 of Levels in Areas). 
				if (rect) {
					view.x = rect.x;
					view.y = rect.y;
				}
				
				view.render();
			}
		}
		
		/**
		 * Tell the screen to start gradually transitioning in.
		 */
		public function enter():void {
			if (transitionTimeIn > 0) {
				transitionPosition = 0;
				view.alpha = transitionPosition;
				screenState = STATE_TRANSITION_IN;
			}
			else 
				screenState = STATE_ACTIVE;
		}

		/**
		 * Tell the screen to start gradually transitioning out.
		 */
		public function exit():void {
			if (transitionTimeOut > 0) {
				screenState = STATE_TRANSITION_OUT;
				isExiting = true;
			}
			else // subclass says it has no transition
				screenManager.removeScreen(this);
		}
		
		public function setGame(game:Game):void {
			this.game = game;
		}

		public function hearMouseInput(type:String, mouseX:int, mouseY:int):void {
			if (paused || !takesInput) return;
			heardMouseInput.dispatch(type, mouseX, mouseY);
		}
		
		public function hearKeyInput(type:String, keyCode:uint):void {
			if (paused || !takesInput) return;
			heardKeyInput.dispatch(type, keyCode);
		}
		
		public function positionCamera(user:ICamUser = null, boundary:SwiftRectangle = null, focus:Body = null):void {
			if (camera) {
				camera.user = user;
				camera.setBounds(boundary);
				camera.focus = focus;
			}
		}
				
		public function addInputReceptor(receptor:IInputReceptor):void {
			MonsterDebugger.trace(this, "Added input receptor");
			receptor.enabledInput.add( addInputReceptor );
			receptor.disabledInput.add ( removeInputReceptor );
			heardMouseInput.add( receptor.hearMouseInput );
			heardKeyInput.add( receptor.hearKeyInput );
		}
		
		public function removeInputReceptor(receptor:IInputReceptor):void {
			receptor.disabledInput.remove( removeInputReceptor );
			heardMouseInput.remove( receptor.hearMouseInput );
			heardKeyInput.remove( receptor.hearKeyInput );
		}
		
		public function get heardMouseInput():Signal { return _heardMouseInput; }
		public function set heardMouseInput(value:Signal):void { _heardMouseInput = value; }
		
		public function get heardKeyInput():Signal { return _heardKeyInput; }
		public function set heardKeyInput(value:Signal):void { _heardKeyInput = value; }
		
		public function get view():ContainerView { return _view; }
		public function set view(value:ContainerView):void { _view = value; }
		
		public function get enabledInput():Signal { return _enabledInput; }
		public function set enabledInput(value:Signal):void { _enabledInput = value; }
		
		public function get disabledInput():Signal { return _disabledInput; }
		public function set disabledInput(value:Signal):void { _disabledInput = value; }
		
		public function get rect():SwiftRectangle { return _rect; }
		public function set rect(value:SwiftRectangle):void { _rect = value; }
		
		public function get entityManager():EntityManager { return _entityManager; }
		public function set entityManager(value:EntityManager):void { _entityManager = value; }
		
		public function get camera():Camera { return _camera; }
		public function set camera(value:Camera):void { _camera = value; }		
		
	}

}