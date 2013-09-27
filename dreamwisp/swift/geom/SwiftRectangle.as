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
		
		public function get left():Number {
			return x;
		}
		
		public function get top():Number {
			return y;
		}
		
		public function contains(x:Number, y:Number):Boolean {
			if (x > left && x < right && y > top && y < bottom) return true;
			return false;
		}
		
		public function containsPoint(point:SwiftPoint):Boolean {
			if (point.x >= left && point.x <= right && point.y >= top && point.y <= bottom) return true;
			return false;
		}
		
		public function intersects(toIntersect:SwiftRectangle):Boolean {
			
			if (bottom < toIntersect.top || top > toIntersect.bottom) return false;
			if (left > toIntersect.right || right < toIntersect.left) return false;
			
			return true;
		}
		
		public function get bottomRight():SwiftPoint {
			return null;
		}
		
		public function set bottomRight(value:SwiftPoint):void {
			
		}
		
	}

}