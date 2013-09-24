package dreamwisp.visual.camera {
	import dreamwisp.entity.components.Body;
	import flash.geom.Point;
	/**
	 * FocusState is a Camera state where the camera always centers on a Focus, an Entity Body. 
	 * This is the default state.
	 * @author Brandon
	 */
	internal class FocusState implements ICameraState {
		
		private var camera:Camera;
		
		public function FocusState(camera:Camera) {
			this.camera = camera;
		}
		
		/* INTERFACE dreamwisp.visual.camera.ICameraState */
		
		public function scroll():void {
			var focus:Body = camera.focus;
			var center:Point = camera.center;
			
			if (focus.globalX > center.x && center.x < camera.maxX) center.x = focus.globalX; 
			if (focus.globalX < center.x && center.x > camera.minX) center.x = focus.globalX;
				
			if (focus.globalY > center.y && center.y < camera.maxY) center.y = focus.globalY; 
			if (focus.globalY < center.y && center.y > camera.minY) center.y = focus.globalY;
			
			camera.stayInBounds();
		}
				
		public function enter():void {
			
		}
		
	}

}