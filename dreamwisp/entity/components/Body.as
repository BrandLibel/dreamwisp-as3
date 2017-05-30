package dreamwisp.entity.components {
	
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.swift.geom.SwiftPoint;
	import dreamwisp.swift.geom.SwiftRectangle;
	import flash.geom.Point;
	
	/**
	 * Body handles the size and position of the entity in the 
	 * virtual world. It also handles collisions with other entitys
	 * or non-tile objects. Also used by the Visual in order to update render.
	 */
	
	public class Body {
		
		private var host:Entity;
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var width:uint;
		public var height:uint;
		public var angle:Number = 0;
		
		private var swiftRectangle:SwiftRectangle;
		
		public function Body(entity:Entity, width:uint, height:uint) {
			host = entity;
			this.width = width;
			this.height = height;
			swiftRectangle = new SwiftRectangle(0, 0, width, height);
		}
		
		public final function teleport(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function getAsRectangle():SwiftRectangle 
		{
			swiftRectangle.x = x;
			swiftRectangle.y = y;
			return swiftRectangle;
		}
		
		public function distanceToBody(other:Body):Number 
		{
			return distanceTo(other.centerX, other.centerY);
			/*return Math.sqrt(
				Math.pow(other.centerX - centerX, 2) +
				Math.pow(other.centerY - centerY, 2) );*/
		}
		
		public function distanceTo(x:Number, y:Number):Number 
		{
			return Math.sqrt(
				Math.pow(x - centerX, 2) +
				Math.pow(y - centerY, 2) ); 
		}
		
		/**
		 * Determines when this body collides with another.
		 * @param	body
		 */
		public function touches(body:Body):Boolean {
			return getAsRectangle().intersects( body.getAsRectangle() );
		}
		
		public function touchesPoint(x:Number, y:Number):Boolean {
			if (x > this.x && y > this.y) {
				if (x < this.x + width && y < this.y + height) {
					return true;
				}
			}
			return false;
		}
		
		public function touchesRect(x:Number, y:Number, width:Number, height:Number):Boolean 
		{
			var rect:SwiftRectangle = new SwiftRectangle(x, y, width, height);
			return getAsRectangle().intersects(rect);
		}
		
		public function get centerX():Number {
			return x + (width / 2);
		}
		
		public function get centerY():Number {
			return y + (height / 2);
		}
		
		/**
		 * In environments where the entity is in a Location that
		 * does not begin at the stage origin, globalX refers to the entity's
		 * x position in relation to the stage origin.
		 */
		public function get globalX():Number {
			return x /*+ host.myLocation.rect.left*/;
		}
		
		/**
		 * In environments where the entity is in a Location that
		 * does not begin at the stage origin, globalY refers to the entity's
		 * y position in relation to the stage origin.
		 */
		public function get globalY():Number {
			return y /*+ host.myLocation.rect.top*/;
		}
		
		/**
		 * Returns the center point of the entity
		 * in relation to the stage origin.
		 */
		public function get globalCenter():SwiftPoint {
			//return new Point( (globalX + width / 2) , (globalY + height / 2) );
			return new SwiftPoint( (globalX + width / 2) , (globalY + height / 2) );
		}
		
		//public function get width():uint { return _width; }
		//
		//public function set width(value:uint):void { _width = value; }
		//
		//public function get height():uint { return _height; }
		//
		//public function set height(value:uint):void { _height = value; }
		//
		//public function get angle():Number { return _angle; }
		//
		//public function set angle(value:Number):void { _angle = value; }
		
	}

}