package dreamwisp.data {
	/**
	 * ...
	 * @author Brandon
	 */
	public class Field implements IField {
		
		private var name:String;
		private var value:int;
		
		
		public function Field(name:String, value:int) {
			this.value = value;
			this.name = name;
			
		}
		
		/* INTERFACE dreamwisp.data.IField */
		
		/**
		 * @inheritDoc
		 */
		public function rename():void {
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function wipe():void {
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function reset():void {
			
		}
		
	}

}