package dreamwisp.entity.components.platformer
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class PlatformerAirState implements IPlatformMovementState
	{
		private var platformPhysics:PlatformPhysics;
		private var host:Entity;
		
		private var maxJumps:uint = 0;
		private var jumps:uint;
		
		public function PlatformerAirState(platformController:PlatformPhysics, host:Entity)
		{
			this.platformPhysics = platformController;
			this.host = host;
			jumps = maxJumps;
		}
		
		/* INTERFACE dreamwisp.state.platform.IPlatformMovementState */
		
		public function update():void
		{
			/*if (platformController.onSlope == false) {
			   MonsterDebugger.trace(this, "falling from gravity");
			 }*/
			platformPhysics.fall(); //host.physics.velocityY += platformPhysics.gravity;
			
			if (host.physics.velocityY > platformPhysics.maxSpeedY)
			{
				MonsterDebugger.trace(this, "terminal fall velocity");
				host.physics.velocityY = platformPhysics.maxSpeedY;
			}
			
			if (!platformPhysics.isWalking)
			{
				host.physics.velocityX *= (platformPhysics.friction);
				if (Math.abs(host.physics.velocityX) < platformPhysics.maxWalkSpeed * 0.1)
					host.physics.velocityX = 0;
			}
			//if (platformPhysics.centerTile().type != "ladder") {
			//platformPhysics.canGrabLadder = true;
			//}
		}
		
		public function moveLeft():void
		{
			// walk left
			platformPhysics.isWalking = true;
			if (host.physics.velocityX > -platformPhysics.maxWalkSpeed)
			{
				host.physics.velocityX -= platformPhysics.walkAcceleration;
			}
		}
		
		public function moveRight():void
		{
			// walk right
			platformPhysics.isWalking = true;
			if (host.physics.velocityX < platformPhysics.maxWalkSpeed)
			{
				host.physics.velocityX += platformPhysics.walkAcceleration;
			}
		}
		
		public function moveUp():void
		{
			//if (platformPhysics.above.type == "ladder" && platformPhysics.center.type == "ladder") {
			//platformPhysics.grabLadder();
			//MonsterDebugger.trace(this, "grab ladder");
			//}
		}
		
		public function moveDown():void
		{
		
		}
		
		public function jump():void
		{
			// do nothing, unless double jump
			if (jumps > 0)
			{
				host.physics.velocityY = -9;
				jumps--;
			}
		}
		
		public function enter():void
		{
		
		}
		
		public function collideLeft():void
		{
			//platformController.x = (platformController.left + 1) * platformController.tile_size /*+ xSize*/ +platformController.xDif;
			//platformController.xspeed = 0;
			//react();
		}
		
		public function collideRight():void
		{
		
			//react();
		}
		
		public function collideTop():void
		{
		
		}
		
		public function collideBottom():void
		{
			//MonsterDebugger.trace(this, "hit the bottom from air");
			platformPhysics.changeState("groundState");
			jumps = maxJumps;
		}
	
	}

}