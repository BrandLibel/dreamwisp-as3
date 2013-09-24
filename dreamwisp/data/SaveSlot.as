package dreamwisp.data {
	/**
	 * ...
	 * @author Brandon
	 */
	public class SaveSlot implements ISaveSlot {
		
		private var name:String;
		private var dateCreated:String;
		private var dateLastUsed:String;
		private var description:String;
		
		public function SaveSlot() {
			
		}
		
		/* INTERFACE dreamwisp.data.ISaveSlot */
		
		public function write(saveData:*):void {
			
		}
		
		public function erase():void {
			
		}
		
	}

}