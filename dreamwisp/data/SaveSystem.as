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
			saveFileName = uniqueLabel + "_s";
		}
		
		public function save(saveData:*, slotNum:uint = 0):void
		{
			sharedObj = SharedObject.getLocal(saveFileName + slotNum);
			sharedObj.data.saveData = saveData;
			sharedObj.close();
		}
		
		public function retrieve(slotNum:uint = 0):Object
		{
			sharedObj = SharedObject.getLocal(saveFileName + slotNum);
			return sharedObj.data.saveData;
		}
		
		public function erase(slotNum:uint = 0):void
		{
			sharedObj = SharedObject.getLocal(saveFileName + slotNum);
			sharedObj.clear();
			sharedObj.close();
		}
	}
}