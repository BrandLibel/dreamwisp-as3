package dreamwisp.entity.components.platformer 
{
	import dreamwisp.entity.hosts.Entity;
	/**
	 * ...
	 * @author Brandon
	 */
	public class RiseState implements IPlatformMovementState 
	{
		private var platformPhysics:PlatformPhysics;
		private var host:Entity;
		
		public function RiseState(platformPhysics:PlatformPhysics, host:Entity) 
		{
			this.platformPhysics = platformPhysics;
			this.host = host;
		}
		
		/* INTERFACE dreamwisp.entity.components.platformer.IPlatformMovementState */
		
		public function update():void 
		{
			platformPhysics.fall();
			
			if (platformPhysics.velocityY > 0)
				platformPhysics.changeState("fallState");
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
			
		}
		
	}

}