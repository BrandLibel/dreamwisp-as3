package dreamwisp.input {
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * InputState tracks input events from the stage, storing
	 * the relevant information.
	 * It gets passed into the game systems every update cycle.
	 * @author Brandon
	 */
	
	public class InputState {
		
		public static const TOTAL_KEYCODES:uint = 222;
		private var _keyPressStates:Vector.<Boolean> = new Vector.<Boolean>(TOTAL_KEYCODES + 1, true);
		/// List of keys that are being held down.
		private var _keysPressed:Vector.<uint> = new Vector.<uint>;
		/// List of keys that have just been released this cycle
		private var keysReleased:Vector.<uint> = new Vector.<uint>;
		
		private const MAX_KEYS_PRESSED:uint = 10;
		private var lastKeySet:uint;
		
		private var _isMousePressed:Boolean;
		private var _mouseX:int;
		private var _mouseY:int;
		
		
		private var canReadInput:Boolean = true;
		private var wasClicked:Boolean;
		
		
		public function InputState(stage:Stage) {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, registerMouse);
			stage.addEventListener(MouseEvent.MOUSE_UP, registerMouse);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, registerMouse);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, registerKeyboard);
			stage.addEventListener(KeyboardEvent.KEY_UP, registerKeyboard);
		}
		
		public function update():InputState {
			canReadInput = true;
			return this;
		}
		
		public function isKeyDown(keyCode:uint):Boolean {
			// return false if impossible key code was entered
			if (keyCode > TOTAL_KEYCODES) return false;
			return (keyPressStates[keyCode]);
		}
		
		/**
		 * Returns true if the mouse was clicked this cycle, false otherwise.
		 */
		public function wasMouseClicked():Boolean {
			// the mouse click is only counted once
			var wasClickedTemp:Boolean = wasClicked;
			if (wasClickedTemp)
				wasClicked = false;
			return wasClickedTemp;
		}
		
		/**
		 * Returns a list of keys that were released this cycle.
		 */
		public function getKeysReleased():Vector.<uint> {
			var tempKeyList:Vector.<uint> = new Vector.<uint>;
			for each (var keyCode:uint in keysReleased) {
				tempKeyList.push(keyCode);
			}
			keysReleased.length = 0;
			return tempKeyList;
		}
		
		public function get isMousePressed():Boolean { return _isMousePressed; }
		
		public function set isMousePressed(value:Boolean):void { _isMousePressed = value; }
		
		public function get mouseX():int { return _mouseX; }
		
		public function set mouseX(value:int):void { _mouseX = value; }
		
		public function get mouseY():int { return _mouseY; }
		
		public function set mouseY(value:int):void { _mouseY = value; }
		
		public function get keyPressStates():Vector.<Boolean> {
			return _keyPressStates;
		}
		
		public function set keyPressStates(value:Vector.<Boolean>):void {
			_keyPressStates = value;
		}
		
		private function setKeyState(keyCode:uint, state:Boolean):void {
			lastKeySet = keyCode;
			keyPressStates[keyCode] = state;
			if (state == true)
				_keysPressed.push(keyCode);
			else {
				_keysPressed.splice( _keysPressed.indexOf(keyCode), 1 );
				keysReleased.push( keyCode );
			}
		}
		
		private function registerKeyboard(e:KeyboardEvent):void {
			// Ensures that only one input change is allowed per update
			if (canReadInput || lastKeySet != e.keyCode)
				setKeyState(e.keyCode, (e.type == KeyboardEvent.KEY_DOWN) );
			// releasing a key is always registered; without this, there are
			// rare cases where the release event happens just after a press event
			// in the same cycle, making canReadInput false. Now, the result is that
			// at extremely low framerates, the press event does not register, something
			// which is preferable to the original scenario.
			if (e.type == KeyboardEvent.KEY_UP) setKeyState(e.keyCode, false);
			canReadInput = false;
		}
		
		private function registerMouse(e:MouseEvent):void {
			// casting x and y to ints because only whole-pixel values are needed/expected
			mouseX = int(e.stageX);
			mouseY = int(e.stageY);
			// indicates mouse is being held...
			if (e.type == MouseEvent.MOUSE_DOWN) {
				isMousePressed = true;
			}
			// ...which remains true until mouse is released
			if (e.type == MouseEvent.MOUSE_UP) {
				isMousePressed = false;
				wasClicked = true;
			}
		}

	}

}