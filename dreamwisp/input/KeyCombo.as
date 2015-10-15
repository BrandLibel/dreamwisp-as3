package dreamwisp.input {
	
	//import com.demonsters.debugger.MonsterDebugger;
	import tools.Belt;
	
	/**
	 * A KeyCombo is a group of keys that must be pressed together
	 * in order to execute an action.
	 * @author Brandon
	 */
	
	internal class KeyCombo {
		private var action:Function;
		
		/// Array of KeyBinds.
		public var keys:Array;
		
		public function KeyCombo(keys:Array, action:Function) {
			this.keys = keys;
			this.action = action;
		}
		
		internal function matches(keysPressed:Array):Boolean {
			return (Belt.isArrayEqual(keys, keysPressed));
		}
		
		/**
		 * 
		 * @param	finalKey The last key used in the key combo 
		 */
		internal function trigger():void {
			action.call();
		}
		
	}

}