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
			platformPhysics.accelerationX = -platformPhysics.walkAcceleration;
			if (platformPhysics.velocityX > -platformPhysics.maxWalkSpeed)
			{
				//platformPhysics.velocityX -= platformPhysics.walkAcceleration;
			}
			else
			{
				platformPhysics.velocityX = -platformPhysics.maxWalkSpeed;
			}
		}
		
		public function moveRight():void
		{
			// walk right
			platformPhysics.isWalking = true;
			platformPhysics.accelerationX = platformPhysics.walkAcceleration;
			if (platformPhysics.velocityX < platformPhysics.maxWalkSpeed)
			{
				//platformPhysics.velocityX += platformPhysics.walkAcceleration;
			}
			else
			{
				platformPhysics.velocityX = platformPhysics.maxWalkSpeed;
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
			lastTile = Tile.NIL;
		}
		
		public function enter():void
		{
			// reset jumps
			platformPhysics.jumpsMade = 0;
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