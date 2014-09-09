package dreamwisp.input 
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.input.KeyMap;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**
	 * CustomKeyField is the interface for rebinding KeyMap keys.
	 * @author Brandon
	 */
	
	public class CustomKeyField
	{
		private var _mc:MovieClip;
		private var actionName:String;
		
		private var keyMap:KeyMap;
		private var keyString:String;
		private var keyDict:Dictionary;
		
		public function CustomKeyField(mc:MovieClip, actionName:String, keyMap:KeyMap, keyString:String, keyDict:Dictionary) 
		{
			_mc = mc;
			if (mc.getChildByName("keyName") == null)
				throw new Error("The CustomKeyField MovieClip has no keyName field");
			if (mc.getChildByName("actionName") == null)
				throw new Error("The CustomKeyField MovieClip has no actionName field");
			
			setActionName(actionName);
			this.keyMap = keyMap;
			this.keyString = keyString;
			this.keyDict = keyDict;
			
			sync();
		}
		
		public function setKeyName(text:String):void 
		{
			TextField(mc.getChildByName("keyName")).text = text;
			
		}
		
		private function setActionName(text:String):void 
		{
			actionName = text;
			TextField(mc.getChildByName("actionName")).text = text;
		}
		
		public function rebind(keyCode:uint):void 
		{
			keyMap.rebind(keyString, keyCode);
			sync();
		}
		
		/**
		 * Sync the keyCode string in the TextField with the keyBind.
		 */
		public function sync():void 
		{
			setKeyName( keyDict[ keyMap.codeOf(keyString) ] );
		}
		
		public function get mc():MovieClip { return _mc; }
		
		
	}

}