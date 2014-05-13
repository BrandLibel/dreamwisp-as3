package dreamwisp.input
{
	import com.demonsters.debugger.MonsterDebugger;
	import org.osflash.signals.Signal;
	
	/**
	 * KeyBind is a group of related keyCodes
	 * that execute the same actions.
	 * @author Brandon
	 */
	
	internal class KeyBind
	{
		private var keyPressed:Signal;
		private var keyReleased:Signal;
		
		private var keyCodes:Vector.<uint>;
		
		private var _label:String;
		internal var isDown:Boolean = false;
		
		public function KeyBind(keys:Object, pressActions:Object, releaseActions:Object, label:String = null)
		{
			keyCodes = new Vector.<uint>();
			if (keys is Array)
				keyCodes = Vector.<uint>( keys as Array )
			else if (keys is uint)
				keyCodes.push(uint(keys));
			
			_label = label;
			
			keyPressed = new Signal();
			keyReleased = new Signal();
			
			var listener:Function;
			if (pressActions != null)
			{
				// specified a single function
				if (pressActions is Function)
					keyPressed.add(pressActions as Function);
				// specified multiple functions
				for each (listener in pressActions)
				{
					keyPressed.add(listener);
				}
			}
			if (releaseActions != null)
			{
				// specified a single function
				if (releaseActions is Function)
					keyReleased.add(releaseActions as Function);
				// specified multiple functions
				for each (listener in releaseActions)
				{
					keyReleased.add(listener);
				}
			}
		}
		
		/**
		 * Removes all listeners from all Signals belonging to this KeyBind.
		 */
		internal function clear():void
		{
			keyPressed.removeAll();
			keyReleased.removeAll();
		}
		
		/**
		 * Unbinds a single key, disabling it and allowing it to be remapped
		 * @param	keyCode
		 */
		internal function stripKey(keyCode:uint):void
		{
			for (var i:int = 0; i < keyCodes.length; i++)
			{
				if (keyCodes[i] == keyCode)
					keyCodes.splice(i, 1);
			}
		}
		
		internal function hasKey(keyCode:uint):Boolean
		{
			for (var i:int = 0; i < keyCodes.length; i++)
				if (keyCodes[i] == keyCode)
					return true;
			return false;
		}
		
		internal function press():void
		{
			if (!isDown)
			{
				isDown = true;
				if (keyPressed.numListeners != 0)
					keyPressed.dispatch();
			}
		}
		
		internal function release():void
		{
			if (isDown)
			{
				isDown = false;
				if (keyReleased.numListeners != 0)
					keyReleased.dispatch();
			}
		}
		
		internal function equals(other:KeyBind):Boolean
		{
			for each (var code:uint in keyCodes)
			{
				if (other.hasKey(code))
					return true;
			}
			return false;
		}
		
		/**
		 * Returns a list of the keyCodes associated with this KeyBind.
		 * @return
		 */
		internal function getKeyCodes():Vector.<uint> { return keyCodes; }
		
		public function get label():String { return _label; }
	}
}