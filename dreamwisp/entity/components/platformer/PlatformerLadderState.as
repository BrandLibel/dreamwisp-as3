package dreamwisp.entity.components.platformer {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class PlatformerLadderState implements IPlatformMovementState {
		
		private var platformPhysics:PlatformPhysics;
		private var host:Entity;
		private var climbSpeed:uint = 4;
		
		public function PlatformerLadderState(platformController:PlatformPhysics, host:Entity) {
			this.platformPhysics = platformController;
			this.host = host;
		}
		
		/* INTERFACE dreamwisp.state.platform.IPlatformMovementState */
		
		public function update():void {
			host.physics.yVelocity = 0;
		}
		
		public function moveLeft():void {
			// do nothing
		}
		
		public function moveRight():void {
			// do nothing
		}
		
		public function moveUp():void {
			if (platformPhysics.top_center.type != "ladder") {
				// reaching a platform that doesn't cont. up w/ a ladder stops the climb
				if (platformPhysics.center.solid.up) return;
				// gets off of ladder when 
				platformPhysics.movementSM.changeState( "airState" );
			}
			if (platformPhysics.center.type != "ladder") { 
				MonsterDebugger.trace(this, "leaving ladder");
				platformPhysics.movementSM.changeState( "groundState" );
			}
			host.physics.yVelocity = -climbSpeed;
		}
		
		public function moveDown():void {
			if (platformPhysics.center.type != "ladder") return;
			host.physics.yVelocity = climbSpeed;
		}
		
		public function jump():void {
			host.physics.yVelocity = platformPhysics.jumpPower;
			platformPhysics.movementSM.changeState( "airState" );
			//MonsterDebugger.trace(this, "JUMP!");
		}
		
		public function enter():void {

		}
				
		public function collideLeft():void {
			
		}
		
		public function collideRight():void {
			
		}
		
		public function collideTop():void {
			
		}
		
		public function collideBottom():void {
			// reaching bottom of the ladder, transition to ground state
			MonsterDebugger.trace(this, "hit ground from ladder");
			platformPhysics.movementSM.changeState( "groundState" );
			
		}
		
	}

}