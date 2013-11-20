package dreamwisp.input {
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.events.KeyboardEvent;
	import org.osflash.signals.Signal;
	import tools.Belt;
	
	/**
	 * KeyMap is a component which allows a class
	 * to create and manage multiple keybindings. 
	 * @author Brandon
	 */
	public class KeyMap {
		
		private var bindings:Vector.<KeyBind> = new Vector.<KeyBind>;
		private var keySequences:Vector.<KeySequence> = new Vector.<KeySequence>;
		private var keyCombos:Vector.<KeyCombo> = new Vector.<KeyCombo>;
		/// List of keyBinds that currently being held down.
		private var keysPressed:Vector.<KeyBind> = new Vector.<KeyBind>;
		
		public static const KEY_PRESSED:Boolean = true;
		public static const KEY_RELEASED:Boolean = false;
		
		public function KeyMap() {
			
		}
		
		/**
		 * Binds the specified key(s) to the selected function(s). Remaps if necessary.
		 * @param	pressActions 
		 * @param	releaseActions
		 * @param	keyCodeData 
		 */
		public function bind(keyCodeData:Object, pressActions:Object = null, releaseActions:Object = null):void {
			// unbind the keyCode(s) if previously binded
			if (bindings.length > 0) {
				var keyBind:KeyBind = find(keyCode);
				var keyCode:uint;
				if (keyCodeData is Array) { // multiple keyCodes
					for each (keyCode in keyCodeData) {
						if (keyBind) keyBind.stripKey(keyCode);
					}
				} else { // single keyCode
					keyCode = uint(keyCodeData);
					if (keyBind) keyBind.stripKey(keyCode);
				}
			}
			
			// committing the keybind
			bindings.push( new KeyBind(keyCodeData, pressActions, releaseActions) );
		}
		
		public function stripKey(keyCode:uint):void {
			var keyBind:KeyBind = find(keyCode);
			if (!keyBind) return;
			keyBind.stripKey(keyCode);
		}
		
		/**
		 * Sets all KeyBinds to register as up if no argument passed.
		 * @param	keyCode Registers the KeyBind group with this member as up.
		 */
		public function release(keyCode:uint = 0):void {
			if (keyCode == 0) {
				for each (var keyBind:KeyBind in bindings) {
					keyBind.release();
				}
			} else {
				find(keyCode).release();
			}
		}
		
		/**
		 * Removes all KeyBinds if no argument passed.
		 * @param	keyCode Removes the specific KeyBind group with this member.
		 */
		public function wipe(keyCode:uint = 0):void {
			if (keyCode == 0) {
				bindings = new Vector.<KeyBind>;
			} else {
				bindings.splice( bindings.indexOf( find(keyCode) ), 1 );
			}
		}
		
		/**
		 * Removes all listeners from all KeyBinds if no argument passed.
		 * @param	keyCode Removes all listeners from the specific KeyBind group with this member.
		 */
		public function clear(keyCode:uint = 0):void {
			if (keyCode == 0) {
				for each (var keyBind:KeyBind in bindings) {
					keyBind.clear();
				}
			} else {
				find(keyCode).clear();
			}
		}
		
		public function isDown(keyCode:uint):Boolean {
			var keyBind:KeyBind = find(keyCode);
			if (!keyBind) return false;
			return keyBind.isDown;
		}
				
		/**
		 * Create a group of keyBinds that execute an action when held together.
		 * @param	keys
		 * @param	action
		 * @param	triggerKey Optional trigger is what must be pressed at the end of the combo.
		 */
		public function defineCombo(keys:Array, action:Function, triggerKey:uint = 0):void {
			//TODO: When defining combos or sequences, a keyCode that doesn't match with any
			//		pre-existing keyBind should construct a new one
			keys = promoteToKeyBinds(keys);
			
			// check and return if identical combo already exists
			if (keySequences.length > 0) {
				for each (var combo:KeyCombo in keyCombos) {
					if (Belt.isArrayEqual( combo.keys, keys))
						return;
				}
			}
			
			keyCombos.push ( new KeyCombo(keys, action/*, find(triggerKey)*/) );
		}
		
		/**
		 * Creating a sequential list of keyBinds required for a certain combo.
		 * @param	keys
		 * @param	action The function to execute when combo succeeds.
		 * @param	delay
		 */
		public function defineSequence(keys:Array, action:Function = null, delay:uint = 60):void {
			// to allow multiple key mappings, each keySequence must get a KeyBind object
			// rather than a regular keyCode uint.
			keys = promoteToKeyBinds(keys);
			
			// check and return if exact sequence already exists
			if (keySequences.length > 0) {
				for each (var sequence:KeySequence in keySequences) {
					if (Belt.isArrayEqual( sequence.keys, keys))
						return;
				}
			}
			
			keySequences.push( new KeySequence(keys, action, delay) );
		}
		
		public function update():void {
			// use this for keeping time for Keycombos
			for each (var sequence:KeySequence in keySequences) {
				sequence.update();
			}
		}
		 
		public function receiveKeyInput(type:String, keyCode:uint):void {
			var keyBind:KeyBind = find(keyCode);
			if (!keyBind) return;
			if (type == KeyboardEvent.KEY_DOWN) {
				// resgistering as key being pressed
				if (keysPressed.indexOf(keyBind) == -1) {
					keysPressed.push(keyBind);
					checkCombo();
					MonsterDebugger.trace(this, keysPressed);
				}
				// checking for keySequence and keyCombo match, no holding down key
				if (!keyBind.isDown) {
					checkSequence(keyCode, KEY_PRESSED);
				}
				// letting the keyBind know it is being pressed
				keyBind.press();
			}
			if (type == KeyboardEvent.KEY_UP) {
				keyBind.release();
				checkSequence(keyCode, KEY_RELEASED);
				keysPressed.splice(keysPressed.indexOf(keyBind), 1);
			}
		}
		
		/**
		 * Returns a KeyBind, a group through a single 'member' keyCode.
		 * @param	keyCode
		 * @return 
		 */
		private function find(keyCode:uint):KeyBind {
			if (keyCode == 0) return null;
			// check for a match
			for each (var keyBind:KeyBind in bindings) {
				if (keyBind.hasKey(keyCode))
					return keyBind;
			}
			return null;
		}
		
		/**
		 * Whenever a key is pressed it needs to be checked for an existing sequence.
		 * @param	keyCode
		 */
		private function checkSequence(keyCode:uint, keyType:Boolean = KEY_PRESSED):void {
			if (keySequences.length == 0) return;
			for each (var sequence:KeySequence in keySequences) {
				if (keyType == KEY_PRESSED)
					sequence.registerKeyPress(keyCode);
				else
					sequence.registerKeyRelease(keyCode);
			}
		}
		
		/**
		 * Check whether the currently pressed keyBinds match any keyCombo.
		 */
		private function checkCombo():void {
			if (keyCombos.length == 0) return;
			for each (var keyCombo:KeyCombo in keyCombos) {
				if (keyCombo.matches( makeKeyBindArray(keysPressed) ))
					keyCombo.trigger();
			}
		}
		
		/**
		 * Replaces keyCodes in an array with the associated keyBinds. 
		 * @param	keys The list of keyCodes.
		 * @return
		 */
		private function promoteToKeyBinds(keyCodes:Array):Array {
			var keyBinds:Array = new Array();
			for (var i:uint = 0; i < keyCodes.length; i++) {
				keyBinds[i] = find(keyCodes[i]);
			}
			return keyBinds;
		}
		
		private function makeKeyBindArray(keyBindVector:Vector.<KeyBind>):Array {
			var keyBindArray:Array = new Array();
			for (var i:int = 0; i < keyBindVector.length; i++) {
				keyBindArray[i] = keyBindVector[i];
			}
			return keyBindArray;
		}
		
	}

}