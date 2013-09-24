package tools {
	import flash.net.FileReference;
	
	public final class Log {
		
		private var fileReference:FileReference = new FileReference();
		private static var s:String;
		
		public final function Log() {
			
		}
		
		public static function log(... args):void {
			for each (a in args) {
				s += a;
				
			}
		}
		
	}

}