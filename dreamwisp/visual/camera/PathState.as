package dreamwisp.visual.camera {
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import flash.geom.Point;
	import tools.Belt;
	/**
	 * PathState is a Camera state where the camera follows a predetermined path.
	 * @author Brandon
	 */
	internal class PathState implements ICameraState {
		
		private var camera:Camera;
		private var path:CameraPath;
		private var center:Point;
		
		public const NODE_INSTANT:String = "instant";
		public const NODE_MOVE:String = "move";
		public const NODE_LOITER:String = "loiter";
				
		public function PathState(camera:Camera) {
			this.camera = camera;
		}
		
		/* INTERFACE dreamwisp.visual.camera.ICameraState */
		
		public function scroll():void {
			var focus:Body = camera.focus;
			//var node:Object = camera.node;
			
			if (path.type == path.NODE_LOITER) {
				if (path.ticks > 0) {
					path.ticks--;
				}
				if (path.ticks == 0) exitNode();
			}
			else if (path.type == path.NODE_MOVE) {
				center.x += camera.velocityX;
				center.y += camera.velocityY;
				MonsterDebugger.trace(this, center.y +"/" + path.y, "", "y pos");
				MonsterDebugger.trace(this, center.x +"/"+ path.x,"","x pos");
				if (center.y == path.y || (center.y > path.y && camera.velocityY > 0) || (center.y < path.y && camera.velocityY < 0)) {
					// stop y movement upon reaching OR passing y destination (determined with velocity dir)
					MonsterDebugger.trace(this, "stopping y: " + center.y);
					camera.velocityY = 0;
				}
				if (center.x == path.x || (center.x > path.x && camera.velocityX > 0) || (center.x < path.x && camera.velocityX < 0)) {
					// stop x movement upon reaching OR passing x destination (determined with velocity dir)
					camera.velocityX = 0;
				}
				if (camera.velocityX == 0 && camera.velocityY == 0 && path.type == "move") {
					// all movement has stopped
					exitNode();
				}
				
				// upon reaching the edges, consider the node reached, move to the next node
				if (camera.passedRightBound() || camera.passedLeftBound() || camera.passedUpBound() || camera.passedDownBound()) {
					MonsterDebugger.trace(this, "next node b/c out of bounds", "", "", 0xFF8000);
					exitNode();
				}
			}
			
		}
		
		private function exitNode():void {
			if (path.hasNextNode()) {
				// move to the next node
				path.nextNode();
				goToNode();
			} else {
				// no more nodes, terminate the path
				MonsterDebugger.trace(this, "path was terminated");
				camera.velocityX = 0;
				camera.velocityX = 0;
				camera.changeToLastState();
			}
		}
		
		private function goToNode():void {
			parseNode();
			// velocity becomes speed * direction
			if (path.type == path.NODE_INSTANT) {
				camera.center.x = path.x;
				camera.center.y = path.y;
				path.nextNode();
				goToNode();
			}
			else if (path.type == path.NODE_MOVE) {
				camera.velocityX = path.xSpeed * ((path.x > center.x) ? 1 : -1);
				camera.velocityY = path.ySpeed * ((path.y > center.y) ? 1 : -1);
			}
		}
		
		private function parseNode():void {
			//MonsterDebugger.trace(this, maxY,"","maxY");
			if (path.x is String) {
				path.x = camera[path.x];
			}
			if (path.y is String) {
				path.y = camera[path.y];
			}
		}
				
		public function enter():void {
			/*camera.velocityX = 0;
			camera.velocityY = 0;*/
			this.path = camera.cameraPath;
			center = camera.center;
			goToNode();
		}
		
	}

}