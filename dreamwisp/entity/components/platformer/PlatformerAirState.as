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
		
		private var timeInAir:uint = 0;
		private var holdingJump:Boolean = false;
		
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
			timeInAir++;
			platformPhysics.fall();
			/*if (holdingJump && timeInAir < 3)
				platformPhysics.velocityY = platformPhysics.velocityY;
			else if (holdingJump && timeInAir < platformPhysics.maxJumpTime)
				platformPhysics.velocityY = platformPhysics.jumpPower;//platformPhysics.velocityY += platformPhysics.jumpPower / platformPhysics.maxJumpTime;
			else
			{
				if (platformPhysics.velocityY < 11)
				{					
					platformPhysics.velocityY += 4;
					if (platformPhysics.velocityY > 11)
						platformPhysics.velocityY = 11;
				}
			}*/
			holdingJump = false;
			
			if (platformPhysics.velocityY > platformPhysics.maxSpeedY)
			{
				MonsterDebugger.trace(this, "terminal fall velocity");
				platformPhysics.velocityY = platformPhysics.maxSpeedY;
			}
			//if (platformPhysics.centerTile().type != "ladder") {
			//platformPhysics.canGrabLadder = true;
			//}
		}
		
		public function moveLeft():void
		{
			// walk left
			platformPhysics.isWalking = true;
			platformPhysics.accelerationX = -platformPhysics.walkAcceleration;
		}
		
		public function moveRight():void
		{
			// walk right
			platformPhysics.isWalking = true;
			platformPhysics.accelerationX = platformPhysics.walkAcceleration;;
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
			holdingJump = true;
			// do nothing, unless double jump
			if (jumps > 0)
			{
				platformPhysics.velocityY = -9;
				jumps--;
			}
		}
		
		public function enter():void
		{
			timeInAir = 0;
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