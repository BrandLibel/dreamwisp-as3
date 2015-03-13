package dreamwisp.input
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	
	/**
	 * InputState is a poll based input system for Adobe Flash and AIR.
	 * Only one instance of InputState can handle all input for a project.
	 * It supports keyboard, mouse, and touch input.
	 * @author Brandon
	 */
	
	public class InputState
	{
		private static const TOTAL_KEYCODES:uint = 222;
		
		private static const STATE_UNLOCKED:uint = 0;
		private static const STATE_LOCKED:uint = 1;
		private static const STATE_PRESSED:uint = 2;
		private static const STATE_RELEASED:uint = 3;
		
		/// Key states this cycle. 0 - pressable; 1 - unpressable;  2 - pressed; 3 - released.
		private var keyStates:Vector.<uint> = new Vector.<uint>(TOTAL_KEYCODES + 1, true);
		
		public var mouseX:int;
		public var mouseY:int;
		
		/**
		 * Must set this to a function with 1 uint param; 
		 * it is called when a mobile button (e.g. Keyboard.BACK) is pressed
		 */ 
		public var mobileButtonCallback:Function;
		
		private var mousePressed:Boolean;
		private var prevMouseX:int;
		private var prevMouseY:int;
		private var wasClicked:Boolean;
		
		public function InputState(stage:Stage)
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, registerMouse);
			stage.addEventListener(MouseEvent.MOUSE_UP, registerMouse);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, registerMouse);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, registerKeyboard);
			stage.addEventListener(KeyboardEvent.KEY_UP, registerKeyboard);
		}
		
		/**
		 * Reverts all input states to be as if player is not interacting at all.
		 */
		public function reset():void 
		{
			for (var i:int = 0; i < TOTAL_KEYCODES; i++)
			{
				if (keyStates[i] == STATE_PRESSED) keyStates[i] = STATE_LOCKED;
				else if (keyStates[i] == STATE_RELEASED) keyStates[i] = STATE_UNLOCKED;
			}
			wasClicked = false;
			prevMouseX = mouseX;
			prevMouseY = mouseY;
		}
		
		public function isKeyDown(keyCode:uint):Boolean
		{
			// return false if an invalid key code was entered
			if (keyCode > TOTAL_KEYCODES) return false;
			return keyStates[keyCode] != STATE_UNLOCKED;
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
		 * Returns a keyCode released in this cycle; in multi-release situations no precedence assured.
		 * Returns a -1 if there were no keys released.
		 */
		public function lastKeyReleased():int
		{
			for (var i:int = 0; i < TOTAL_KEYCODES; i++)
			{
				const keyState:uint = keyStates[i];
				if (keyState == STATE_RELEASED)
					return i;
			}
			return -1;
		}
		
		private function registerKeyboard(e:KeyboardEvent):void
		{
			// non-keyboard (mobile, controller, etc.) button presses
			if (e.keyCode > keyStates.length)
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				if (e.type == KeyboardEvent.KEY_UP)
					mobileButtonCallback.call(null, e.keyCode);
				return;
			}
			
			if (e.type == KeyboardEvent.KEY_DOWN && keyStates[e.keyCode] == STATE_UNLOCKED)
				keyStates[e.keyCode] = STATE_PRESSED;
			else if (e.type == KeyboardEvent.KEY_UP)
				keyStates[e.keyCode] = STATE_RELEASED;
		}
		
		public function isMousePressed():Boolean
		{
			return mousePressed;
		}
		
		/**
		 * Returns true if the mouse was clicked this cycle, false otherwise.
		 */
		public function wasMouseClicked():Boolean
		{
			return wasClicked;
		}
		
		public function isMouseMoving():Boolean
		{
			return (mouseX != prevMouseX || mouseY != prevMouseY);
		}
		
		private function registerMouse(e:MouseEvent):void
		{
			mouseX = e.stageX;
			mouseY = e.stageY;
			
			if (e.type == MouseEvent.MOUSE_DOWN)
				mousePressed = true;
			else if (e.type == MouseEvent.MOUSE_UP)
			{
				mousePressed = false;
				wasClicked = true;
			}
		}
		
		public function isTouch():Boolean
		{
			return Capabilities.touchscreenType == TouchscreenType.FINGER;
		}

	}

}