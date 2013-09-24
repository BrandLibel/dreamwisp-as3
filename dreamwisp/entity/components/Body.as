package dreamwisp.entity.components {
	
	import dreamwisp.entity.hosts.Entity;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Body handles the size and position of the entity in the 
	 * virtual world. It also handles collisions with other entitys
	 * or non-tile objects. Also used by the Visual in order to update render.
	 */
	
	public class Body {
		
		private var host:Entity;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _width:uint;
		private var _height:uint;
		private var _angle:Number;
		
		private var _facingDirection:int;
		
		public function Body(entity:Entity, width:uint, height:uint) {
			host = entity;
			this.width = width;
			this.height = height;
		}
		
		public function get facingDirection():int {
			return _facingDirection;
		}
		
		public function set facingDirection(value:int):void {
			// can only be -1 for left or 1 right
			_facingDirection = value;
		}
		
		public final function teleport(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		public function getAsRectangle():Rectangle {
			return new Rectangle(x, y, width, height);
		}
		
		public function get x():Number { return _x; }
		
		public function set x(value:Number):void { _x = value; }
		
		public function get y():Number { return _y; }
		
		public function set y(value:Number):void { _y = value; }
		
		/**
		 * Determines when this body collides with another.
		 * @param	body
		 */
		public function touches(body:Body):Boolean {
			if (this.getAsRectangle().intersects( body.getAsRectangle() )) {
				return true;
			}
			return false;
		}
		
		public function touchesPoint(x:Number, y:Number):Boolean {
			if (x > this.x && y > this.y) {
				if (x < this.x + width && y < this.y + height) {
					return true;
				}
			}
			return false;
		}
		
		public function get centerX():Number {
			return _x + (_width / 2);
		}
		
		public function get centerY():Number {
			return _y + (_height / 2);
		}
		
		/**
		 * In environments where the entity is in a Location that
		 * does not begin at the stage origin, globalX refers to the entity's
		 * x position in relation to the stage origin.
		 */
		public function get globalX():Number {
			return _x + host.myLocation.rect.left;
		}
		
		/**
		 * In environments where the entity is in a Location that
		 * does not begin at the stage origin, globalY refers to the entity's
		 * y position in relation to the stage origin.
		 */
		public function get globalY():Number {
			return _y + host.myLocation.rect.top;
		}
		
		/**
		 * Returns the center point of the entity
		 * in relation to the stage origin.
		 */
		public function get globalCenter():Point {
			return new Point( (globalX + width / 2) , (globalY + height / 2) ); 
		}
		
		public function get width():uint { return _width; }
		
		public function set width(value:uint):void { _width = value; }
		
		public function get height():uint { return _height; }
		
		public function set height(value:uint):void { _height = value; }
		
		public function get angle():Number { return _angle; }
		
		public function set angle(value:Number):void { _angle = value; }
		
	}

}