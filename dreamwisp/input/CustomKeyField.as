package dreamwisp.input 
{
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**
	 * CustomKeyField is the interface for rebinding key controls
	 * @author Brandon
	 */
	
	public class CustomKeyField
	{
		private var _mc:MovieClip;
		private var actionName:String;
		
		private var keyString:String;
		private var keyDict:Dictionary;
		private var keyBinds:Object;
		
		public function CustomKeyField(mc:MovieClip, actionName:String, keyString:String, keyDict:Dictionary, keyBinds:Object) 
		{
			_mc = mc;
			if (mc.getChildByName("keyName") == null)
				throw new Error("The CustomKeyField MovieClip has no keyName field");
			if (mc.getChildByName("actionName") == null)
				throw new Error("The CustomKeyField MovieClip has no actionName field");
			
			setActionName(actionName);
			this.keyString = keyString;
			this.keyDict = keyDict;
			this.keyBinds = keyBinds;
			
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
			keyBinds[keyString] = keyCode;
			sync();
		}
		
		/**
		 * Sync the keyCode string in the TextField with the keyBind.
		 */
		public function sync(keyBinds:Object = null):void 
		{
			if (keyBinds == null) keyBinds = this.keyBinds;
			setKeyName( keyDict[ keyBinds[keyString] ] );
		}
		
		public function get mc():MovieClip { return _mc; }
		
		
	}

}