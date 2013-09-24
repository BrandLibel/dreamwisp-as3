package dreamwisp.entity.components {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.core.C;
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * This class is for entitys that are able to move around and affected by physics.
	 * This includes reaction to physical phenomenon such as gravity. 
	 * Beds and doorways, for example, would not have a PhysicsBody.
	 */
	
	public class Physics {
		
		protected var host:Entity;
		
		private var gravity:Number = Data.GRAVITY;
		
		public var state:String = "falling";
		
		public var acceleration:Number;
		public var accelerationX:Number = 0;
		public var accelerationY:uint = 0;
		public var friction:Number = 0;
		public var bonusSpeed:Number = 0;
		public var maxSpeed:Number = 2;
		
		public var directionMultiplier:int = 1;
		
		private var isMovingX:Boolean = false;
		private var isMovingY:Boolean = false;
		
		private var _xVelocity:Number = 0;
		private var _yVelocity:Number = 0;
		
		/** 
		 * Grabbing all constants from C.as for use as local vars in this class. 
		 * They are kept as vars to allow for possibility of changing them later on,
		 * such as with zero gravity.
		 */
		/*private var gravity:Number = C.GRAVITY;
		private var ground_acceleration:Number = C.GROUND_ACCELERATION;
		private var ground_friction:Number = C.GROUND_FRICTION;
		private var air_acceleration:Number = C.AIR_ACCELERATION;
		private var air_friction:Number = C.AIR_FRICTION;
		private var ice_acceleration:Number = C.ICE_ACCELERATION;
		private var ice_friction:Number = C.ICE_FRICTION;
		private var treadmill_speed:Number = C.TREADMILL_SPEED;*/
		
		public function Physics(entity:Entity) {
			host = entity;
		}
		
		public function update():void {
			/// This makes the entity slow down and stop 
			/*if (host.state != "walking") {
				xVelocity *= friction;
				if (Math.abs(xVelocity) < 0.5) xVelocity = 0;
			}
			
			///
			//if (host.state != "onGround") {
				//if (xSpeed < maxSpeed * directionMultiplier) {
					xVelocity += accelerationX;
				//}
				if (xVelocity > maxSpeed) {
					xVelocity = maxSpeed;
				}
				if (xVelocity < -maxSpeed) {
					xVelocity = -maxSpeed;
				}
			//}
						
			if (host.state == "falling") {
				//MonsterDebugger.trace(this, "falling by gravity", "", "", 0xECBD00);
				yVelocity += gravity;
			}*/
		
			//host.body.x += xVelocity;
			//host.body.y += yVelocity;
		}
		
		public function travelY():void {
			host.body.y += yVelocity;
		}
		
		public function travelX():void {
			host.body.x += xVelocity;
		}
		
		public function thrust(power:Number):void {
			xVelocity += Math.sin(-host.body.angle) * power;
            yVelocity += Math.cos(-host.body.angle) * power;
		}
		
		/** 
		 * This move function is used set the host's virtual body in motion.
		 * When called, it simply modifies the speed values of the entity.
		 * The speeds are used to affect the actual position values of the body
		 * in the update() function.
		 * 
		 */
		public final function move(dir:uint, isAccelerate:Boolean = true, newAcceleration:Number = 0, value:uint = 0):void {
			if (isAccelerate == true)
			if (newAcceleration != 0) {
				//var prevAcceleration = acceleration;
				acceleration = newAcceleration;
			}
			switch (dir) {
				case C.LEFT:
					isMovingX = true;
					if (xVelocity > -maxSpeed) {
						//host.body.facingDirection = dir;
						//host.body.x -= (value == 0) ? xSpeed : value;
						xVelocity -= acceleration;
					}
					break;
				case C.RIGHT:
					isMovingX = true;
					if (xVelocity < maxSpeed) {
						//host.body.facingDirection = dir;
						//host.body.x += (value == 0) ? xSpeed : value;
						xVelocity += acceleration;
					}
					break;
				case C.UP:
					isMovingY = true;
					//host.body.y -= (value == 0) ? ySpeed : value;
					break;
				case C.DOWN:
					isMovingY = true;
					//host.body.y += (value == 0) ? ySpeed : value;
					break;
			}
			//acceleration = prevAcceleration;
		}
		
		/**
		 * This function is used to tell the entity to begin to stop. 
		 * It will not make the entity stop immediately, but it tells it to 
		 * cease its own self-propulsion so that it becomes 
		 * naturally affeted by physics until it rests.
		 */
		public final function stop():void {
			isMovingX = false;
			isMovingY = false;
		}
		
		public function get xVelocity():Number { return _xVelocity; }
		
		public function set xVelocity(value:Number):void { _xVelocity = value; }
		
		public function get yVelocity():Number { return _yVelocity; }
		
		public function set yVelocity(value:Number):void { _yVelocity = value; }
		
	}

}