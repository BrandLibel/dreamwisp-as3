package dreamwisp.entity.components.platformer
{
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class PlatformerLadderState implements IPlatformMovementState
	{
		private var platformPhysics:PlatformPhysics;
		private var host:Entity;
		private var climbSpeed:uint = 4;
		
		public function PlatformerLadderState(platformController:PlatformPhysics, host:Entity)
		{
			this.platformPhysics = platformController;
			this.host = host;
		}
		
		/* INTERFACE dreamwisp.state.platform.IPlatformMovementState */
		
		public function update():void
		{
			host.physics.velocityY = 0;
		}
		
		public function moveLeft():void
		{
			// do nothing
		}
		
		public function moveRight():void
		{
			// do nothing
		}
		
		public function moveUp():void
		{
			if (platformPhysics.topMidTile().type != "ladder")
			{
				// reaching a platform that doesn't cont. up w/ a ladder stops the climb
				if (platformPhysics.centerTile().isSolidUp())
					return;
				// gets off of ladder when 
				platformPhysics.changeState("airState");
			}
			if (platformPhysics.centerTile().type != "ladder")
			{
				MonsterDebugger.trace(this, "leaving ladder");
				platformPhysics.changeState("groundState");
			}
			host.physics.velocityY = -climbSpeed;
		}
		
		public function moveDown():void
		{
			if (platformPhysics.centerTile().type != "ladder")
				return;
			host.physics.velocityY = climbSpeed;
		}
		
		public function jump():void
		{
			host.physics.velocityY = platformPhysics.jumpPower;
			platformPhysics.changeState("airState");
			//MonsterDebugger.trace(this, "JUMP!");
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
			// reaching bottom of the ladder, transition to ground state
			MonsterDebugger.trace(this, "hit ground from ladder");
			platformPhysics.changeState("groundState");
		
		}
	
	}

}