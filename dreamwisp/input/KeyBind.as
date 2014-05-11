package dreamwisp.input {
	
	import com.demonsters.debugger.MonsterDebugger;
	import org.osflash.signals.Signal;
	
	/**
	 * KeyBind is a group of related keyCodes 
	 * that execute the same actions.
	 * @author Brandon
	 */
	
	internal class KeyBind {
		
		private var keyPressed:Signal;
		private var keyReleased:Signal;
		
		private var keyCodes:Object;
		private var _label:String;
		internal var isDown:Boolean = false;
		
		public function KeyBind( keyCodes:Object, pressActions:Object, releaseActions:Object, label:String = null ) {
			this.keyCodes = keyCodes;
			_label = label;
			
			keyPressed = new Signal();
			keyReleased = new Signal();
			
			var listener:Function;
			if (pressActions != null) {
				// specified a single function
				if (pressActions is Function) keyPressed.add(pressActions as Function);
				// specified multiple functions
				for each (listener in pressActions) {
					keyPressed.add(listener);
				}
			}
			if (releaseActions != null) {
				// specified a single function
				if (releaseActions is Function) keyReleased.add(releaseActions as Function);
				// specified multiple functions
				for each (listener in releaseActions) {
					keyReleased.add(listener);
				}
			}
		}
		
		/**
		 * Removes all listeners from all Signals belonging to this KeyBind.
		 */
		internal function clear():void {
			keyPressed.removeAll();
			keyReleased.removeAll();
		}
		
		/**
		 * Unbinds a single key, disabling it and allowing it to be remapped 
		 * @param	keyCode 
		 */
		internal function stripKey(keyCode:uint):void {
			if (hasKey(keyCode)) {
				if (keyCodes is Array) {
					var kcArray:Array = keyCodes as Array;
					kcArray.splice( kcArray.indexOf(keyCode), 1);
					if (kcArray.length == 0)
					MonsterDebugger.trace(this, "stripping keys: " + keyCode + "|||" + keyCodes);
				} else { 
					// Destroy this keyBind, no keys point to it anymore
				} 
			}
		}
		
		internal function hasKey(keyCode:uint):Boolean {
			// returns true if the keyCode exists in the array
			if (keyCodes is Array) {
				if ((keyCodes as Array).indexOf(keyCode) >= 0) return true;
			} else {
				if (keyCode == keyCodes) return true;
			}
			return false;
		}
		
		internal function press():void {
			//MonsterDebugger.trace(this, "pressing");
			if (!isDown) {
				isDown = true;
				if (keyPressed.numListeners != 0)
					keyPressed.dispatch();
			}
		}
		
		internal function release():void {
			//MonsterDebugger.trace(this, "releasing");
			if (isDown) {
				isDown = false;
				if (keyReleased.numListeners != 0)
					keyReleased.dispatch(); 
			}
		}
		
		internal function equals(other:KeyBind):Boolean {
			// returns true if keyBinds share a single member
			var keyToTest:uint = (keyCodes is Array) ? keyCodes[0] : uint(keyCodes);
			return (other.hasKey(keyToTest));
		}
		
		/**
		 * Returns a list of the keyCodes associated with this KeyBind.
		 * @return
		 */
		internal function getKeyCodes():Vector.<uint> {
			var keyCodeList:Vector.<uint> = new Vector.<uint>;
			if (keyCodes is Array) {
				for each (var keyCode:uint in keyCodes)
					keyCodeList.push(keyCode);
			} else {
				keyCodeList[0] = uint(keyCodes);
			}
			return keyCodeList;
		}
		
		public function get label():String { return _label; }
	}
}