package dreamwisp.entity.components
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	
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
		
		public function isMoving():Boolean
		{
			return (velocityX != 0 || velocityY != 0);
		}
	
	}

}