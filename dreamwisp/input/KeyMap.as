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
		private var keyCombos:Vector.<KeyCombo> = new Vector.<KeyCombo>;
		
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
				var keyCode:uint;
				if (keyCodeData is Array) { // multiple keyCodes
					for each (keyCode in keyCodeData) {
						if (find(keyCode)) find(keyCode).stripKey(keyCode);
					}
				} else { // single keyCode
					keyCode = uint(keyCodeData);
					if (find(keyCode)) find(keyCode).stripKey(keyCode);
				}
			}
			
			// committing the keybind
			bindings.push( new KeyBind(keyCodeData, pressActions, releaseActions) );
		}
		
		public function stripKey(keyCode:uint):void {
			if (!find(keyCode)) return;
			find(keyCode).stripKey(keyCode);
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
			if (!find(keyCode)) return false;
			return find(keyCode).isDown;
		}
		
		/**
		 * Returns a KeyBind, a group through a single 'member' keyCode.
		 * @param	keyCode
		 * @return 
		 */
		private function find(keyCode:uint):KeyBind {
			// check for a match
			for each (var keyBind:KeyBind in bindings) {
				if (keyBind.hasKey(keyCode)) return keyBind;
			}
			return null;
		}
		
		/**
		 * Creating a sequential list of key presses required for a certain combo.
		 * @param	keys
		 * @param	action The function to execute when combo succeeds.
		 * @param	delay
		 */
		public function addCombo(keys:Array, action:Function = null, delay:uint = 60):void {
			
			// to allow multiple key mappings, each keyCombo must get a KeyBind object
			// rather than a regular keyCode uint.
			for (var i:uint = 0; i < keys.length; i++) {
				// converting keys from keyCode uints to KeyBind objects
				keys[i] = find(keys[i]);
			}
			
			// check if exact combo already exists
			if (keyCombos.length != 0) {
				for each (var keyCombo:KeyCombo in keyCombos) {
					if (Belt.isArrayEqual( keyCombo.keys, keys)) {
						return;
					}
				}
			}
			
			keyCombos.push( new KeyCombo(keys, action, delay) );
		}
		
		/**
		 * Whenever a key is pressed it needs to be checked for an existing combo.
		 * @param	keyCode
		 */
		private function checkCombo(keyCode:uint, keyType:Boolean = KEY_PRESSED):void {
			if (keyCombos.length == 0) return;
			for each (var keyCombo:KeyCombo in keyCombos) {
				if (keyType == KEY_PRESSED) {
					keyCombo.registerKeyPress(keyCode);
				} else {
					keyCombo.registerKeyRelease(keyCode);
				}
			}
		}
		
		public function update():void {
			// use this for keeping time for Keycombos
			for each (var keyCombo:KeyCombo in keyCombos) {
				keyCombo.update();
			}
		}
		 
		public function receiveKeyInput(type:String, keyCode:uint):void {
			if (type == KeyboardEvent.KEY_DOWN) {
				
				if (find(keyCode)) {
					// checking for key combo match, no holding down key
					if (!find(keyCode).isDown) checkCombo(keyCode, KEY_PRESSED);
					find(keyCode).press();
				}
			}
			if (type == KeyboardEvent.KEY_UP) {
				if (find(keyCode)) {
					find(keyCode).release();
					checkCombo(keyCode, KEY_RELEASED);
				}
			}
		}
		
	}

}