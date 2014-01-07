package dreamwisp.entity.components.platformer {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class PlatformerGroundState implements IPlatformMovementState {
		
		private var platformPhysics:PlatformPhysics;
		private var host:Entity;
		
		public function PlatformerGroundState(platformController:PlatformPhysics, host:Entity) {
			this.platformPhysics = platformController;
			this.host = host;
		}
		
		/* INTERFACE dreamwisp.state.platform.IPlatformMovementState */
		
		public function update():void {
			if (!platformPhysics.walking) {
				host.physics.xVelocity *= (platformPhysics.friction);
				if (Math.abs(host.physics.xVelocity) < platformPhysics.maxWalkSpeed*0.1) host.physics.xVelocity = 0;
			}
			
		}
		
		public function moveLeft():void {
			// walk left
			platformPhysics.walking = true;
			if (host.physics.xVelocity > -platformPhysics.maxWalkSpeed) {
				host.physics.xVelocity -= platformPhysics.acceleration;
			} else {
				host.physics.xVelocity = -platformPhysics.maxWalkSpeed;
			}
			//MonsterDebugger.trace(this, "walking");
		}
		
		public function moveRight():void {
			// walk right
			platformPhysics.walking = true;
			if (host.physics.xVelocity < platformPhysics.maxWalkSpeed) {
				host.physics.xVelocity += platformPhysics.acceleration;
			} else {
				host.physics.xVelocity = platformPhysics.maxWalkSpeed;
			}
			
		}
		
		public function moveUp():void {
			// check for ladder
			if (platformPhysics.above.type == "ladder" && platformPhysics.center.type == "ladder") {
				platformPhysics.grabLadder();
				//MonsterDebugger.trace(this, "grab ladder");
			}
		}
		
		public function moveDown():void {
			// check for ladder
			if (platformPhysics.below.type == "ladder" && platformPhysics.center.type == "ladder") {
				platformPhysics.grabLadder();
				//MonsterDebugger.trace(this, "grab ladder");
			}
		}
		
		public function jump():void {
			host.physics.yVelocity = platformPhysics.jumpPower;
			platformPhysics.movementSM.changeState("airState");
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