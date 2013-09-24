package dreamwisp.swift.geom {
	
	/**
	 * The SwiftRectangle is a redesign of flash.geom.Rectangle.
	 * @author Brandon
	 */
	
	public class SwiftRectangle {
		
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public function SwiftRectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function get bottom():Number {
			return (y + height);
		}
		
		public function get right():Number {
			return (x + width);
		}
		
		public function get bottomRight():SwiftPoint {
			
		}
		public function set bottomRight(value:SwiftPoint):void {
			
		}
		
	}

}