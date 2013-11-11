package dreamwisp.entity.components.platformer {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.hosts.IPlatformEntity;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class LadderState implements IPlatformMovementState {
		
		private var platformController:PlatformController;
		private var host:IPlatformEntity;
		private var climbSpeed:uint = 4;
		
		public function LadderState(platformController:PlatformController) {
			this.platformController = platformController;
			this.host = platformController.host;
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
			if (platformController.top_center.type != "ladder") {
				// reaching a platform that doesn't cont. up w/ a ladder stops the climb
				if (platformController.center.solid.up) return;
				// gets off of ladder when 
				platformController.movementSM.changeState( "airState" );
			}
			if (platformController.center.type != "ladder") { 
				MonsterDebugger.trace(this, "leaving ladder");
				platformController.movementSM.changeState( "groundState" );
			}
			host.physics.yVelocity = -climbSpeed;
		}
		
		public function moveDown():void {
			if (platformController.center.type != "ladder") return;
			host.physics.yVelocity = climbSpeed;
		}
		
		public function jump():void {
			host.physics.yVelocity = platformController.jumpPower;
			platformController.movementSM.changeState( "airState" );
			//MonsterDebugger.trace(this, "JUMP!");
		}
		
		public function crouch():void {
			// do nothing, or moveDown
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
			platformController.movementSM.changeState( "groundState" );
			
		}
		
	}

}