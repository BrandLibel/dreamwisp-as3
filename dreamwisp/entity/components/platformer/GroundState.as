package dreamwisp.entity.components.platformer {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.IPlatformEntity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class GroundState implements IPlatformMovementState {
		
		private var platformController:PlatformController;
		private var host:IPlatformEntity;
		
		public function GroundState(platformController:PlatformController) {
			this.platformController = platformController;
			host = platformController.host;
		}
		
		/* INTERFACE dreamwisp.state.platform.IPlatformMovementState */
		
		public function update():void {
			if (!platformController.walking) {
				host.physics.xVelocity *= (platformController.friction);
				if (Math.abs(host.physics.xVelocity) < platformController.maxWalkSpeed*0.1) host.physics.xVelocity = 0;
			}
			
		}
		
		public function moveLeft():void {
			// walk left
			platformController.walking = true;
			if (host.physics.xVelocity > -platformController.maxWalkSpeed) {
				host.physics.xVelocity -= platformController.acceleration;
			} else {
				host.physics.xVelocity = -platformController.maxWalkSpeed;
			}
			//MonsterDebugger.trace(this, "walking");
		}
		
		public function moveRight():void {
			// walk right
			platformController.walking = true;
			if (host.physics.xVelocity < platformController.maxWalkSpeed) {
				host.physics.xVelocity += platformController.acceleration;
			} else {
				host.physics.xVelocity = platformController.maxWalkSpeed;
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
			host.physics.yVelocity = platformController.jumpPower;
			platformController.movementSM.changeState("airState");
		}
		
		public function crouch():void {
			
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