package dreamwisp.visual.camera {
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import flash.geom.Point;
	import tools.Belt;
	/**
	 * SlowFocusState is a Camera state where the camera approaches a Focus, an Entity Body.
	 * @author Brandon
	 */
	internal class SlowFocusState implements ICameraState {
		private var camera:Camera;
		
		public function SlowFocusState(camera:Camera) {
			this.camera = camera;
			
		}
		
		/* INTERFACE dreamwisp.visual.camera.ICameraState */
		
		public function scroll():void {
			var focus:Body = camera.focus;
			var center:Point = camera.center;
			
			if (focus.globalX != center.x) {
				camera.velocityX = 1 * Belt.getSignOf(focus.globalX - center.x);
			}
			if (focus.globalY != center.y) {
				camera.velocityY = 1 * Belt.getSignOf(focus.globalY - center.y);
			}
			//MonsterDebugger.trace(this, center.x + "/" + focus.globalX);
			if (center.x == Math.round(focus.globalX)) {
				// stopping x movement 
				camera.velocityX = 0;
			}
			//MonsterDebugger.trace(this, center.y + "/" + focus.globalY);
			if (center.y == Math.round(focus.globalY)) {
				// stopping y movement
				camera.velocityY = 0;
			}
			if (camera.velocityX == 0 && camera.velocityY == 0) {
				// centered on the focus
			}
			
			center.x += camera.velocityX;
			center.y += camera.velocityY;
			
			camera.stayInBounds();
		}
		
		public function enter():void {
			
		}
		
	}

}