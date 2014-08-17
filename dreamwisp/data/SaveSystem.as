package dreamwisp.data
{
	import com.demonsters.debugger.MonsterDebugger;
	import flash.net.SharedObject;
	
	/**
	 * SaveSystem manages the unique SharedObject(s) of a project.
	 * Using multiple save slots is an optional feature supported.
	 * @author Brandon
	 */
	
	public class SaveSystem
	{
		private var sharedObj:SharedObject;
		private var saveFileName:String;
		
		public function SaveSystem(uniqueLabel:String)
		{
			saveFileName = uniqueLabel;
			sharedObj = SharedObject.getLocal(saveFileName);
			if (sharedObj.data["s0"] == null)
				sharedObj.data["s0"] = new Object();
		}
		
		public function saveData(dataName:String, data:*, slotNum:uint = 0):void 
		{
			sharedObj = SharedObject.getLocal(saveFileName);
			if (sharedObj.data["s" + slotNum] == null)
				sharedObj.data["s" + slotNum] = new Object();
			sharedObj.data["s" + slotNum][dataName] = data;
			sharedObj.close();
		}
		
		public function saveOptions(dataName:String, data:*):void 
		{
			sharedObj = SharedObject.getLocal(saveFileName);
			if (sharedObj.data.options == null)
				sharedObj.data.options = new Object();
			sharedObj.data.options[dataName] = data;
			sharedObj.close();
		}
		
		public function retrieveData(dataName:String, slotNum:uint = 0):*
		{
			sharedObj = SharedObject.getLocal(saveFileName);
			return sharedObj.data["s" + slotNum][dataName] || null;
		}
		
		public function retrieveOptions():Object
		{
			sharedObj = SharedObject.getLocal(saveFileName);
			return sharedObj.data.options;
		}
		
		public function erase(slotNum:uint = 0):void
		{
			sharedObj = SharedObject.getLocal(saveFileName + slotNum);
			sharedObj.clear();
			sharedObj.close();
		}
	}
}