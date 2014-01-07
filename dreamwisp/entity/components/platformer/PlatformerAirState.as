package dreamwisp.entity.components.platformer {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class PlatformerAirState implements IPlatformMovementState {
		
		private var platformPhysics:PlatformPhysics;
		private var host:Entity;
		
		private var maxJumps:uint = 0;
		private var jumps:uint;
		
		
		public function PlatformerAirState(platformController:PlatformPhysics, host:Entity) {
			this.platformPhysics = platformController;
			this.host = host;
			jumps = maxJumps;
		}
		
		/* INTERFACE dreamwisp.state.platform.IPlatformMovementState */
		
		public function update():void {
			/*if (platformController.onSlope == false) {
				MonsterDebugger.trace(this, "falling from gravity");
			}*/
			host.physics.yVelocity += platformPhysics.environment.gravity;
			
			if (host.physics.yVelocity > platformPhysics.terminalVelocityY) {
				MonsterDebugger.trace(this, "terminal fall velocity");
				host.physics.yVelocity = platformPhysics.terminalVelocityY;
			}
			
			if (!platformPhysics.walking) {
				host.physics.xVelocity *= (platformPhysics.friction);
				if (Math.abs(host.physics.xVelocity) < platformPhysics.maxWalkSpeed*0.1) host.physics.xVelocity = 0;
			}
			if (platformPhysics.center.type != "ladder") {
				platformPhysics.canGrabLadder = true;
			}
		}
		
		public function moveLeft():void {
			// walk left
			platformPhysics.walking = true;
			if (host.physics.xVelocity > -platformPhysics.maxWalkSpeed) {
				host.physics.xVelocity -= platformPhysics.acceleration;
			}
		}
		
		public function moveRight():void {
			// walk right
			platformPhysics.walking = true;
			if (host.physics.xVelocity < platformPhysics.maxWalkSpeed) {
				host.physics.xVelocity += platformPhysics.acceleration;
			}
		}
		
		public function moveUp():void {
			if (platformPhysics.above.type == "ladder" && platformPhysics.center.type == "ladder") {
				platformPhysics.grabLadder();
				//MonsterDebugger.trace(this, "grab ladder");
			}
		}
		
		public function moveDown():void {
			
		}
		
		public function jump():void {
			// do nothing, unless double jump
			if (jumps > 0) {
				
				host.physics.yVelocity = -9;
				jumps--;
			}
		}
			
		public function enter():void {
			
		}
				
		public function collideLeft():void {
			//platformController.x = (platformController.left + 1) * platformController.tile_size /*+ xSize*/ +platformController.xDif;
			//platformController.xspeed = 0;
			//react();
		}
		
		public function collideRight():void {
			
			//react();
		}
		
		public function collideTop():void {
			
		}
		
		public function collideBottom():void {
			//MonsterDebugger.trace(this, "hit the bottom from air");
			platformPhysics.movementSM.changeState( "groundState" );
			jumps = maxJumps;
		}
		
	}

}