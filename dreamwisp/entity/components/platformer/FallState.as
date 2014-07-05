package dreamwisp.entity.components.platformer 
{
	import dreamwisp.entity.hosts.Entity;
	/**
	 * ...
	 * @author Brandon
	 */
	public class FallState implements IPlatformMovementState 
	{
		private var platformPhysics:PlatformPhysics;
		private var host:Entity;
		
		public function FallState(platformPhysics:PlatformPhysics, host:Entity) 
		{
			this.platformPhysics = platformPhysics;
			this.host = host;
		}
		
		/* INTERFACE dreamwisp.entity.components.platformer.IPlatformMovementState */
		
		public function update():void 
		{
			platformPhysics.fall();
			
			if (platformPhysics.velocityY > platformPhysics.maxSpeedY)
				platformPhysics.velocityY = platformPhysics.maxSpeedY;
				
			if (platformPhysics.velocityY < 0)
				platformPhysics.changeState("riseState");
		}
		
		public function enter():void 
		{
			
		}
		
		public function moveLeft():void 
		{
			platformPhysics.isWalking = true;
			platformPhysics.accelerationX = -platformPhysics.walkAcceleration;
		}
		
		public function moveRight():void 
		{
			platformPhysics.isWalking = true;
			platformPhysics.accelerationX = platformPhysics.walkAcceleration;
		}
		
		public function moveUp():void 
		{
			
		}
		
		public function moveDown():void 
		{
			
		}
		
		public function jump():void 
		{
			
		}
		
		public function collideLeft():void 
		{
			
		}
		
		public function collideRight():void 
		{
			
		}
		
		public function collideTop():void 
		{
			
		}
		
		public function collideBottom():void 
		{
			platformPhysics.changeState("groundState");
		}
		
	}

}