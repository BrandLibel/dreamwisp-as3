package dreamwisp.data {
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class SaveSystem {
		
		private var activeSlot:ISaveSlot;
		private var activeSlotNum:uint = 0;
		private var slots:Vector.<ISaveSlot> = new Vector.<ISaveSlot>;
		
		private var sharedObj:SharedObject;
		private var sharedObj2:SharedObject;
		
		private var saveFileName:String;
		
		public function SaveSystem(uniqueGameID:String = "", numOfSlots:uint = 1) {
			for (var i:uint = 0; i < numOfSlots; i++) {
				slots.push( new SaveSlot() );
				MonsterDebugger.trace(this, "creating save slot: " + i);
			}
			var fileName:String = uniqueGameID + "_s" + numOfSlots;
			saveFileName = uniqueGameID + "_s";
			sharedObj = SharedObject.getLocal("test");
			sharedObj2 = SharedObject.getLocal("newfile");
			sharedObj2.data.random = Math.random();
			sharedObj2.close();
			//MonsterDebugger.trace(this, "Intitialized save system. " + uniqueGameID);
			
			checkSaves();
			
			// unauthorized testing of bitwise shifts
			var subject:int = 6;
			MonsterDebugger.trace(this, 6 << 3, "","",0xF90000);
		}
		
		private function checkSaves():void {
			/*for (var i:uint = 0; i < slots.length; i++) {
				sharedObj = SharedObject.getLocal(saveFileName + i); 
			}*/
			sharedObj = SharedObject.getLocal(saveFileName + activeSlotNum);
			if (sharedObj.data.saveData) {
				MonsterDebugger.trace(this, "SAVE FILE EXISTS");
				Data.saveFile = true;
			} else {
				MonsterDebugger.trace(this, "SAVE FILE DOES NOT EXIST");
				Data.saveFile = false;
			}
		}
		
		public function save(saveData:*):void {
			sharedObj = SharedObject.getLocal(saveFileName + activeSlotNum);
			sharedObj.data.saveData = saveData;
			sharedObj.close();
		}
		
		public function retrieve(slotNum:uint = 0):Object {
			activeSlotNum = slotNum;
			//return slots[slotNum];
			sharedObj = SharedObject.getLocal(saveFileName + activeSlotNum);
			MonsterDebugger.trace(this, sharedObj.data);
			return sharedObj.data.saveData;
		}
		
		public function write(saveData:*):void {
			activeSlot.write(saveData);
		}
		
		public function erase(slotNum:uint = 0):void {
			activeSlotNum = slotNum;
			sharedObj = SharedObject.getLocal(saveFileName + activeSlotNum);
			sharedObj.clear();
			sharedObj.close();
			//sharedObj.data.saveData = new Object();
			//activeSlot.erase();
		}
		
	}

}