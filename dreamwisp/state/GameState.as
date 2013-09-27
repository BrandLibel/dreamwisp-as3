package dreamwisp.state {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.core.Game;
	import dreamwisp.entity.components.Body;
	import dreamwisp.swift.geom.SwiftRectangle;
	import dreamwisp.visual.camera.Camera;
	import dreamwisp.visual.camera.ICamUser;
	import dreamwisp.visual.ContainerView;
	import dreamwisp.world.base.EntityManager;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public class GameState implements IGameState {
		
		// TODO: Make GameState a more integral part. GameState has it's own ContainerView.
		//		Location extends GameState...and things such as World or Area can manage states
		//		just like Game can.
		
		protected var game:Game;
				
		protected var paused:Boolean = false;
		protected var takesInput:Boolean = true;
		
		private var newState:IGameState;
		private var newTransition:Object;
		/// Function leading to state change
		private var action:Function;
		
		private var _view:ContainerView;
		private var _transition:TransitionManager;
		private var _heardMouseInput:Signal;
		private var _heardKeyInput:Signal;
		
		private var _enabledInput:Signal;
		private var _disabledInput:Signal;
		
		private var _rect:SwiftRectangle;
		private var _entityManager:EntityManager;
		private var _camera:Camera;
		
		public function GameState() {
			heardMouseInput = new Signal(String, int, int);
			heardKeyInput = new Signal(String, uint);
		}
		
		/**
		 * Exits this state, changes the state and bridges with transitions defined in object bridgeData  
		 * @param	bridgeData Must have fields: transition, myExitTransition
		 * 			optional fields: newState, action
		 */
		protected function startStateChange(bridgeData:Object):void {
			this.takesInput = false;
			this.newTransition = bridgeData.transition;
			if (bridgeData.newState) this.newState = bridgeData.newState;
			if (bridgeData.action) this.action = bridgeData.action;
			transition.finished.addOnce(commitStateChange);
			if (bridgeData.myExitTransition) transition.start(bridgeData.myExitTransition);
		}
		
		protected function commitStateChange():void {
			
			if (newState) {
				game.changeState( newState, newTransition );
			}
			if (action != null) action();
		}
		
		/**
		 * Exits this state and prepares to enter a new one.
		 * @param	bridgeData 
		 * 			Optional fields: transition, myExitTransition
		 */
		public function changeState(bridgeData:Object):void {
			// forget about old data
			newState = null;
			newTransition = null;
			action = null;
			
			takesInput = false;
			if (bridgeData.newState) newState = bridgeData.newState;
			if (bridgeData.transition) newTransition = bridgeData.transition;
			if (bridgeData.action) action = bridgeData.action;
			
			// when using transitions, wait until transition completes until changing state
			if (bridgeData.myExitTransition) {
				transition.finished.addOnce(commitStateChange);
				transition.start(bridgeData.myExitTransition);
			} else {
				commitStateChange();
			}
		}
		
		/* INTERFACE dreamwisp.state.IGameState */
				
		public function enter():void {
			
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
		
		public function update():void {
			//if (paused) return;
			if (transition) transition.update();
			if (entityManager) entityManager.update();
			if (camera) camera.update();
		}
		
		public function render():void {
			//if (paused) return;
			if (transition) transition.render();
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
		
		public function setGame(game:Game):void {
			this.game = game;
		}
		
		//TODO: better off handling input through Signals which every
		
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
		
		public function get transition():TransitionManager { return _transition; }
		
		public function set transition(value:TransitionManager):void { _transition = value; }
		
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