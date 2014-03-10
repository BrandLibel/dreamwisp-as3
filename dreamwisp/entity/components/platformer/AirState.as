package dreamwisp.entity.components.platformer {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class AirState implements IPlatformMovementState {
		
		private var platformController:PlatformController;
		private var host:Entity;
		
		private var maxJumps:uint = 0;
		private var jumps:uint;
		
		
		public function AirState(platformController:PlatformController) {
			this.platformController = platformController;
			this.host = platformController.host;
			jumps = maxJumps;
		}
		
		/* INTERFACE dreamwisp.state.platform.IPlatformMovementState */
		
		public function update():void {
			/*if (platformController.onSlope == false) {
				MonsterDebugger.trace(this, "falling from gravity");
			}*/
			host.physics.velocityY += platformController.environment.gravity;
			
			if (host.physics.velocityY > platformController.terminalVelocityY) {
				MonsterDebugger.trace(this, "terminal fall velocity");
				host.physics.velocityY = platformController.terminalVelocityY;
			}
			
			if (!platformController.walking) {
				host.physics.velocityX *= (platformController.friction);
				if (Math.abs(host.physics.velocityX) < platformController.maxWalkSpeed*0.1) host.physics.velocityX = 0;
			}
			if (platformController.center.type != "ladder") {
				platformController.canGrabLadder = true;
			}
		}
		
		public function moveLeft():void {
			// walk left
			platformController.walking = true;
			if (host.physics.velocityX > -platformController.maxWalkSpeed) {
				host.physics.velocityX -= platformController.acceleration;
			}
		}
		
		public function moveRight():void {
			// walk right
			platformController.walking = true;
			if (host.physics.velocityX < platformController.maxWalkSpeed) {
				host.physics.velocityX += platformController.acceleration;
			}
		}
		
		public function moveUp():void {
			if (platformController.above.type == "ladder" && platformController.center.type == "ladder") {
				platformController.grabLadder();
				//MonsterDebugger.trace(this, "grab ladder");
			}
		}
		
		public function moveDown():void {
			
		}
		
		public function jump():void {
			// do nothing, unless double jump
			if (jumps > 0) {
				
				host.physics.velocityY = -9;
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
			platformController.movementSM.changeState( "groundState" );
			jumps = maxJumps;
		}
		
	}

}