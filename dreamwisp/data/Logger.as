package dreamwisp.data {
	
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Brandon
	 */
	public class Logger {
		
		private var fields:Dictionary;
		
		public function Logger() {
			var field:Field = new Field();
		}
		
		public function log(fieldName:String, value:int):void {
			if (!fields[fieldName]) fields[fieldName] = new Field(fieldName, value);
			else fields[fieldName].value += value; 
		}
		
	}

}