package dreamwisp.entity.components.platformer {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class GroundState implements IPlatformMovementState {
		
		private var platformController:PlatformController;
		private var host:Entity;
		
		public function GroundState(platformController:PlatformController) {
			this.platformController = platformController;
			host = platformController.host;
		}
		
		/* INTERFACE dreamwisp.state.platform.IPlatformMovementState */
		
		public function update():void {
			if (!platformController.walking) {
				host.physics.velocityX *= (platformController.friction);
				if (Math.abs(host.physics.velocityX) < platformController.maxWalkSpeed*0.1) host.physics.velocityX = 0;
			}
			
		}
		
		public function moveLeft():void {
			// walk left
			platformController.walking = true;
			if (host.physics.velocityX > -platformController.maxWalkSpeed) {
				host.physics.velocityX -= platformController.acceleration;
			} else {
				host.physics.velocityX = -platformController.maxWalkSpeed;
			}
			//MonsterDebugger.trace(this, "walking");
		}
		
		public function moveRight():void {
			// walk right
			platformController.walking = true;
			if (host.physics.velocityX < platformController.maxWalkSpeed) {
				host.physics.velocityX += platformController.acceleration;
			} else {
				host.physics.velocityX = platformController.maxWalkSpeed;
			}
			
		}
		
		public function moveUp():void {
			// check for ladder
			if (platformController.above.type == "ladder" && platformController.center.type == "ladder") {
				platformController.grabLadder();
				//MonsterDebugger.trace(this, "grab ladder");
			}
		}
		
		public function moveDown():void {
			// check for ladder
			if (platformController.below.type == "ladder" && platformController.center.type == "ladder") {
				platformController.grabLadder();
				//MonsterDebugger.trace(this, "grab ladder");
			}
		}
		
		public function jump():void {
			host.physics.velocityY = platformController.jumpPower;
			platformController.movementSM.changeState("airState");
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
			
		}
		
	}

}