package dreamwisp.entity.components.platformer
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class LadderState extends PlatformState
	{
		private var climbSpeed:uint = 4;
		
		public function LadderState(platformPhysics:PlatformPhysics, host:Entity)
		{
			super(platformPhysics, host);
		}
				
		override public function update():void
		{
			host.physics.velocityY = 0;
		}
		
		override public function moveUp():void
		{
			if (platformPhysics.topMidTile().type != "ladder")
			{
				// reaching a platform that doesn't cont. up w/ a ladder stops the climb
				if (platformPhysics.centerTile().isSolidUp())
					return;
				// gets off of ladder when 
				platformPhysics.changeState("fallState");
			}
			if (platformPhysics.centerTile().type != "ladder")
			{
				MonsterDebugger.trace(this, "leaving ladder");
				platformPhysics.changeState("groundState");
			}
			host.physics.velocityY = -climbSpeed;
		}
		
		override public function moveDown():void
		{
			if (platformPhysics.centerTile().type != "ladder")
				return;
			host.physics.velocityY = climbSpeed;
		}
		
		override public function jump():void
		{
			host.physics.velocityY = platformPhysics.jumpPower;
			platformPhysics.changeState("riseState");
		}
		
		override public function collideBottom():void
		{
			// reaching bottom of the ladder, transition to ground state
			MonsterDebugger.trace(this, "hit ground from ladder");
			platformPhysics.changeState("groundState");
		
		}
	
	}

}