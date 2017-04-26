package dreamwisp.entity.components
{
	//import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	import tools.Belt;
	
	public class Physics
	{
		private static const DEFAULT_MAX_SPEED:Number = 10;
		
		protected var host:Entity;
		
		public var velocityX:Number = 0;
		public var velocityY:Number = 0;
		public var accelerationX:Number = 0;
		public var accelerationY:Number = 0;
		public var externalAccelerationX:Number = 0;
		public var externalAccelerationY:Number = 0;
		public var maxSpeedX:Number;
		public var maxSpeedY:Number;
		
		public function Physics(entity:Entity, maxSpeedX:Number = DEFAULT_MAX_SPEED, maxSpeedY:Number = DEFAULT_MAX_SPEED)
		{
			host = entity;
			this.maxSpeedX = maxSpeedX;
			this.maxSpeedY = maxSpeedY;
		}
		
		public function moveLeft():void 
		{
		}
		
		public function moveRight():void 
		{
		}
		
		public function moveDown():void 
		{
		}
		
		public function moveUp():void 
		{
		}
		
		public function update():void
		{
			travelY();
			travelX();
			// reset acceleration (external needs to keep applying force)
			externalAccelerationX = 0;
			externalAccelerationY = 0;
		}
		
		/**
		 * Applies net velocity to x-position.
		 * This should be used instead of directly setting body.x
		 */
		protected function travelX():void
		{
			velocityX += accelerationX;
			// avoid exceeding max speed
			if (Math.abs(velocityX) > maxSpeedX)
			{
				var sign:int = (velocityX >= 0) ? 1 : -1;
				velocityX = maxSpeedX * sign;
			}
			velocityX += externalAccelerationX;
			host.body.x += velocityX;
		}
		
		/**
		 * Applies net velocity to y-position.
		 * This should be used instead of directly setting body.y
		 */
		protected function travelY():void
		{
			velocityY += accelerationY;
			// avoid exceeding max speed
			if (Math.abs(velocityY) > maxSpeedY)
			{
				var sign:int = (velocityY >= 0) ? 1 : -1;
				velocityY = maxSpeedY * sign;
			}
			velocityY += externalAccelerationY;			
			host.body.y += velocityY;
		}
		
		public function thrust(power:Number):void
		{
			velocityX += Math.sin(-host.body.angle) * power;
			velocityY += Math.cos(-host.body.angle) * power;
		}
		
		/**
		 * Applies an acceleration in the direction of a target point.
		 * @param targetX The x-coordinate of the point to approach
		 * @param targetY The y-coordinate of the point to approach
		 * @param power The amount of power to apply.
		 */
		public function thrustToPoint(targetX:int, targetY:int, power:Number):void{
			trace("approaching " + targetX + ", " + targetY);

			var deltaX:Number = targetX - host.body.x;
			var directionSign:int = Belt.getSignOf(deltaX);
			var deltaY:Number = targetY - host.body.y;

			// avoid zero divide by zero error
			if (deltaX == 0 && deltaY == 0)
				return;

			var angleInRadians:Number = Math.atan(deltaY / deltaX);
			trace("angle in radians: " + angleInRadians);
			trace("angle in degrees: " + angleInRadians * (360/Math.PI));
			//trace("TRACE: angle cos " + Math.cos(angleInRadians));
			//trace("TRACE: angle sin " + Math.sin(angleInRadians));
			velocityX += Math.cos(angleInRadians) * power * directionSign;
			velocityY += Math.sin(angleInRadians) * power * directionSign;
			trace("speeds " + velocityX + ", " + velocityY);
		}
		
		public function isMoving():Boolean
		{
			return (velocityX != 0 || velocityY != 0);
		}
	
	}

}