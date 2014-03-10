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
		
		/**
		 * Applies net velocity to x-position.
		 * This should be used instead of directly setting body.x
		 */
		protected function travelX():void
		{
			// avoid exceeding max speed
			if (Math.abs(velocityX) > maxSpeedX)
			{
				var sign:int = (velocityX >= 0) ? 1 : -1;
				velocityX = maxSpeedX * sign;
			}
			
			host.body.x += velocityX;
		}
		
		/**
		 * Applies net velocity to y-position.
		 * This should be used instead of directly setting body.y
		 */
		protected function travelY():void
		{
			// avoid exceeding max speed
			if (Math.abs(velocityY) > maxSpeedY)
			{
				var sign:int = (velocityY >= 0) ? 1 : -1;
				velocityY = maxSpeedY * sign;
			}
			
			host.body.y += velocityY;
		}
		
		public function thrust(power:Number):void
		{
			velocityX += Math.sin(-host.body.angle) * power;
			velocityY += Math.cos(-host.body.angle) * power;
		}
	
	}

}