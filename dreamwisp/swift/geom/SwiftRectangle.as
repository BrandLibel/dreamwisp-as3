package dreamwisp.swift.geom
{
	import flash.geom.Rectangle;
	/**
	 * The SwiftRectangle is a simpler and more performant flash.geom.Rectangle.
	 * @author Brandon
	 */
	
	public class SwiftRectangle
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		private var swiftPoint:SwiftPoint;
		private var rectangle:Rectangle;
		
		public function SwiftRectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			swiftPoint = new SwiftPoint(0);
		}
		
		public function bottom():Number { return (y + height); }
		
		public function right():Number { return (x + width); }
		
		public function left():Number { return x; }
		
		public function top():Number { return y; }
		
		public function contains(x:Number, y:Number):Boolean
		{
			return  x > left() &&
					x < right() &&
					y > top() &&
					y < bottom();
		}
		
		public function containsPoint(point:SwiftPoint):Boolean
		{
			return  point.x >= left() &&
					point.x <= right() && 
					point.y >= top() &&
					point.y <= bottom();
		}
		
		public function intersects(toIntersect:SwiftRectangle):Boolean
		{
			
			if (bottom() < toIntersect.top() || top() > toIntersect.bottom())
				return false;
			if (left() > toIntersect.right() || right() < toIntersect.left())
				return false;
			
			return true;
		}
		
		public function bottomRight():SwiftPoint
		{
			swiftPoint.x = right();
			swiftPoint.y = bottom();
			return swiftPoint;
		}
		
		public function rect():Rectangle
		{
			if (rectangle == null) rectangle = new Rectangle(x, y, width, height);
			else
			{
				rectangle.x = x;
				rectangle.y = y;
			}
			return rectangle;
		}
	
	}

}