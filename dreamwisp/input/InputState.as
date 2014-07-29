package dreamwisp.input {
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * InputState tracks input events from the stage, storing
	 * the relevant information.
	 * It gets passed into the game systems every update cycle.
	 * @author Brandon
	 */
	
	public class InputState {
		
		public static const TOTAL_KEYCODES:uint = 222;
		private static const STATE_INACTIVE:uint = 0;
		private static const STATE_PRESSED:uint = 1;
		private static const STATE_RELEASED:uint = 2;
		
		private var _keyPressStates:Vector.<Boolean> = new Vector.<Boolean>(TOTAL_KEYCODES + 1, true);
		/// List of keys with a uint representing its state this cycle. 0 - inactive; 1 - pressed; 2 - released.
		private var keyStates:Vector.<uint> = new Vector.<uint>(TOTAL_KEYCODES + 1, true)
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
		
		/**
		 * Reverts all input states to be as if player is not interacting at all.
		 */
		public function reset():void 
		{
			keysReleased.length = 0;
			wasClicked = false;
			for (var i:int = 0; i < TOTAL_KEYCODES; i++) 
				keyStates[i] = STATE_INACTIVE;
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
			return wasClicked;
		}
		
		/// Check if the supplied key was pressed this tick
		public function wasKeyPressed(keyCode:uint):Boolean 
		{
			return keyStates[keyCode] == STATE_PRESSED;
		}
		
		/// Check if the supplied key was releasaed this tick
		public function wasKeyReleased(keyCode:uint):Boolean 
		{
			return keyStates[keyCode] == STATE_RELEASED;
		}
		
		/**
		 * Returns a list of keys that were released this cycle.
		 */
		public function getKeysReleased():Vector.<uint> {
			var tempKeyList:Vector.<uint> = new Vector.<uint>;
			for each (var keyCode:uint in keysReleased) {
				tempKeyList.push(keyCode);
			}
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
			/*// Ensures that only one input change is allowed per update
			if (canReadInput || lastKeySet != e.keyCode)
				setKeyState(e.keyCode, (e.type == KeyboardEvent.KEY_DOWN) );
			// releasing a key is always registered; without this, there are
			// rare cases where the release event happens just after a press event
			// in the same cycle, making canReadInput false. Now, the result is that
			// at extremely low framerates, the press event does not register, something
			// which is preferable to the original scenario.
			if (e.type == KeyboardEvent.KEY_UP) setKeyState(e.keyCode, false);
			canReadInput = false;*/
			
			// post refactoring - use keyStates
			if (e.type == KeyboardEvent.KEY_DOWN)
				keyStates[e.keyCode] = STATE_PRESSED;
			else
				keyStates[e.keyCode] = STATE_RELEASED;
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
			else if (e.type == MouseEvent.MOUSE_UP) {
				isMousePressed = false;
				wasClicked = true;
			}
		}

	}

}