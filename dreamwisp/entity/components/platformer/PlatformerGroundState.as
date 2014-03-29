package dreamwisp.entity.components.platformer
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.world.tile.Tile;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class PlatformerGroundState implements IPlatformMovementState
	{
		private var platformPhysics:PlatformPhysics;
		private var host:Entity;
		private var lastTile:Tile;
		
		public function PlatformerGroundState(platformController:PlatformPhysics, host:Entity)
		{
			this.platformPhysics = platformController;
			this.host = host;
		}
		
		/* INTERFACE dreamwisp.state.platform.IPlatformMovementState */
		
		public function update():void
		{
			// apply friction when stopped moving
			if (!platformPhysics.isWalking)
			{
				host.physics.velocityX *= (platformPhysics.friction);
				if (Math.abs(host.physics.velocityX) < platformPhysics.maxWalkSpeed * 0.1)
					host.physics.velocityX = 0;
			}
			
			var tileUnderFoot:Tile = platformPhysics.primaryFoot();
			if (tileUnderFoot.isSolidUp())
			{
				if (tileUnderFoot != lastTile)
					platformPhysics.steppedNewTile.dispatch(tileUnderFoot);
				lastTile = tileUnderFoot;
			}
			else
			{
				platformPhysics.changeState("airState");
				lastTile = Tile.NIL;
			}
			
		}
		
		public function moveLeft():void
		{
			// walk left
			platformPhysics.isWalking = true;
			if (host.physics.velocityX > -platformPhysics.maxWalkSpeed)
			{
				host.physics.velocityX -= platformPhysics.walkAcceleration;
			}
			else
			{
				host.physics.velocityX = -platformPhysics.maxWalkSpeed;
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
			else
			{
				host.physics.velocityX = platformPhysics.maxWalkSpeed;
			}
		
		}
		
		public function moveUp():void
		{
			// check for ladder
			//if (platformPhysics.above.type == "ladder" && platformPhysics.centerTile().type == "ladder") {
			//platformPhysics.grabLadder();
			//MonsterDebugger.trace(this, "grab ladder");
			//}
		}
		
		public function moveDown():void
		{
			// check for ladder
			//if (platformPhysics.below.type == "ladder" && platformPhysics.centerTile().type == "ladder") {
			//platformPhysics.grabLadder();
			//MonsterDebugger.trace(this, "grab ladder");
			//}
		}
		
		public function jump():void
		{
			host.physics.velocityY = platformPhysics.jumpPower;
			platformPhysics.changeState("airState");
			lastTile = Tile.NIL;
		}
		
		public function enter():void
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