package dreamwisp.entity.components.platformer 
{
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class RiseState extends PlatformState
	{
		public function RiseState(platformPhysics:PlatformPhysics, host:Entity) 
		{
			super(platformPhysics, host);
		}
		
		/* INTERFACE dreamwisp.entity.components.platformer.IPlatformMovementState */
		
		override public function update():void 
		{
			platformPhysics.fall();
			
			if (platformPhysics.velocityY > 0)
				platformPhysics.changeState("fallState");
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
		
	}

}