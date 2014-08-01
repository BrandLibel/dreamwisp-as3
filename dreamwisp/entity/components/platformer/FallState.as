package dreamwisp.entity.components.platformer 
{
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class FallState extends PlatformState
	{		
		public function FallState(platformPhysics:PlatformPhysics, host:Entity) 
		{
			super(platformPhysics, host);
		}
		
		/* INTERFACE dreamwisp.entity.components.platformer.IPlatformMovementState */
		
		override public function update():void 
		{
			platformPhysics.fall();
			
			if (platformPhysics.velocityY > platformPhysics.maxSpeedY)
				platformPhysics.velocityY = platformPhysics.maxSpeedY;
				
			if (platformPhysics.velocityY < 0)
				platformPhysics.changeState("riseState");
		}
		
		override public function moveLeft():void 
		{
			platformPhysics.isWalking = true;
			platformPhysics.accelerationX = -platformPhysics.walkAcceleration;
		}
		
		override public function moveRight():void 
		{
			platformPhysics.isWalking = true;
			platformPhysics.accelerationX = platformPhysics.walkAcceleration;
		}
		
		override public function collideBottom():void 
		{
			platformPhysics.changeState("groundState");
		}
		
	}

}