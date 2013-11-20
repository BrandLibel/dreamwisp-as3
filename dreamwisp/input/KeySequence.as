package dreamwisp.input {
	
	import com.demonsters.debugger.MonsterDebugger;
	
	/**
	 * KeySequence handles a list of KeyBinds that execute an action
	 * when they are pressed in order.
	 * @author Brandon
	 */
	
	internal class KeySequence {
		
		/// Array of KeyBinds. Each KeyBind can contain multiple possible keys.
		public var keys:Array;
		/// The function to call when the KeyCombo is executed.
		private var action:Function;
		/// The index in the key array that the combo is currently on.
		private var progress:uint = 0;
		/// The max time, in frames, allowed between key presses.
		private var timeLimit:uint;
		/// The number of frames passed since the last match.
		private var timePassed:uint;
		
		private var isCounting:Boolean;
		
		public function KeySequence(keys:Array, action:Function, delay:uint) {
			this.keys = keys;
			this.action = action;
			timeLimit = delay;			
		}
		
		public function registerKeyPress(keyCode:uint):void {
			// combo reacts instantly upon key press - use only on final key of the combo
			var matchedKey:Boolean = false;
			if (keys[progress].keyCodes is Array) {
				// more than one key possible in the KeyBind
				var keyBind:KeyBind = keys[progress];
				if (keyBind.hasKey(keyCode)) {
					// matched one of the keyCodes in the KeyBind
					matchedKey = true;
				} else {
					// wrong key was pressed, reset
					reset();
				}
			} else {
				// the KeyBind only contains one keyCode
				if (keys[progress].hasKey(keyCode)) matchedKey = true;
			}			
			//MonsterDebugger.trace(this, "matched a key press: " + matchedKey);
			if (matchedKey) {
				if (timePassed < timeLimit) {
					//registerMatch();
					completeCombo();
				}
			}
		}
		
		public function registerKeyRelease(keyCode:uint):void {
			// combo reacts upon key release - regular combo proceeding
			var matchedKey:Boolean = false;
			if (keys[progress].keyCodes is Array) {
				// more than one key possible in the KeyBind
				var keyBind:KeyBind = keys[progress];
				if (keyBind.hasKey(keyCode)) {
					// matched one of the keyCodes in the KeyBind
					matchedKey = true;
				} else {
					// wrong key was pressed, reset
					reset();
				}
			} else {
				// the KeyBind only contains one keyCode
				if (keys[progress].hasKey(keyCode)) {
					matchedKey = true;
				}
			}			
			//MonsterDebugger.trace(this, "matched a key press: " + matchedKey);
			if (matchedKey) {
				if (timePassed < timeLimit) {
					proceed();
				}
			}
		}
		
		public function update():void {
			// handling timing
			if (isCounting) {
				timePassed++;
				if (timePassed == timeLimit) {
					reset();
				}
			}
		}
		
		/// One key match, proceed to the next in the combo.
		private function proceed():void {
			isCounting = true;
			progress++;
		}
		
		private function completeCombo():void {
			if (!keys[progress+1]) {
				action.call();
				reset();
				MonsterDebugger.trace(this, "KEY SEQUENCE COMPLETED!");
			}
		}
		
		private function registerMatch():void {
			//MonsterDebugger.trace(this, "key press matches key combo");
			isCounting = true;
			progress++;
			// no more keys left in the array
			if (!keys[progress]) {
				// last match in the combo
				action.call();
				reset();
				MonsterDebugger.trace(this, "KEY SEQUENCE COMPLETED!");
			}
		}
		
		private function reset():void {
			//MonsterDebugger.trace(this, "key combo resetting: " + timeLimit);
			progress = 0;
			timePassed = 0;
			isCounting = false;
		}
		
	}

}