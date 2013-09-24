package dreamwisp.core {
	
	import com.demonsters.debugger.MonsterDebugger;

	/**
	 * This class is like the Event Listener for properties. 
	 */
	
	public final class Watcher {
		
		private var host:Object;
		/// The properties and the values (default is !null) they are are to be checked for.
		private var watchList:Array = [];
		
		public function Watcher(host:Object) {
			this.host = host;
		}
		
		/*public final function initialize(host:*):void {
			this.host = host;
		}*/
		
		public final function watchFor(... args):void {
			for (var i:uint = 0; i < args.length; i++) {
				watchList.push(args[i]);
				
			}
		}
		
		/**
		 * Looks for the properties in the <code>watchList</code> and searches for them in 
		 * multiple places, starting with the host of the <code>Watcher</code> and ending 
		 * with the <code>Data</code> class.
		 * @return Returns true if all properties in the <code>watchList</code> are at correct values.
		 */
		public final function check():Boolean {
			// TODO fix problem, Data.getText returns null probably because it did not load fast enough
			//MonsterDebugger.trace(this, Data.getText("VAR_NAME_SAVE_FILE"));
			for each (var i:Object in watchList) {
				var property:String = Data.text[i.name];
				var value:* = i.value;
				if (i.value == undefined) {
					if (host.hasOwnProperty(property)) return true;
					if (Data[property]) return true;
				}
				if (host.hasOwnProperty(property) && host[property] == value) {
					continue;
				} else if (Data[property] && Data[property] == value) {
					continue;
				} else {
					return false;
				}
			}
			return true;
		}
		
		public final function execute(funct:Function):void {
			funct.call();
			retire();
		}
		
		public final function retire():void {
			watchList = [];
		}
		
	}

}