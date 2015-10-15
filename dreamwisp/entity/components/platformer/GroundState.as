package dreamwisp.entity.components.platformer
{
	//import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.world.tile.Tile;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class GroundState extends PlatformState
	{
		private var lastTile:Tile;
		
		public function GroundState(platformPhysics:PlatformPhysics, host:Entity)
		{
			super(platformPhysics, host);
		}
				
		override public function update():void
		{
			var tileUnderFoot:Tile = platformPhysics.primaryFoot();
			if (tileUnderFoot.isSolidUp() && !platformPhysics.ignoresCollision(tileUnderFoot))
			{
				if (tileUnderFoot != lastTile)
					platformPhysics.steppedNewTile.dispatch(tileUnderFoot);
				lastTile = tileUnderFoot;
			}
			else if (!platformPhysics.isOnSlope)
			{
				platformPhysics.changeState("fallState");
				lastTile = Tile.NIL;
			}
		}
		
		override public function moveLeft():void
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
		
		override public function moveRight():void
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
		
		override public function moveUp():void
		{
			// check for ladder
			//if (platformPhysics.above.type == "ladder" && platformPhysics.centerTile().type == "ladder") {
			//platformPhysics.grabLadder();
			//MonsterDebugger.trace(this, "grab ladder");
			//}
		}
		
		override public function moveDown():void
		{
			// check for ladder
			//if (platformPhysics.below.type == "ladder" && platformPhysics.centerTile().type == "ladder") {
			//platformPhysics.grabLadder();
			//MonsterDebugger.trace(this, "grab ladder");
			//}
		}
		
		override public function jump():void
		{
			lastTile = Tile.NIL;
		}
		
		override public function enter():void
		{
			// reset jumps
			platformPhysics.jumpsMade = 0;
		}
	
	}

}