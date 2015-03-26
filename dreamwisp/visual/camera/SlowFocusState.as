package dreamwisp.visual.camera
{
	import dreamwisp.swift.geom.SwiftPoint;
	import flash.geom.Point;
	
	/**
	 * SlowFocusState is a Camera state where the camera approaches a focus.
	 * @author Brandon
	 */
	
	internal class SlowFocusState implements ICameraState
	{
		private var camera:Camera;
		
		public function SlowFocusState(camera:Camera)
		{
			this.camera = camera;
		
		}
		
		public function scroll():void
		{
			var focus:SwiftPoint;
			var center:Point = camera.center;
			var nearestPoint:SwiftPoint = camera.findNearestPoint();
			
			if (nearestPoint != null)
				focus = nearestPoint;
			else
				focus = new SwiftPoint(camera.focusBody.x, camera.focusBody.y);
				
			var deltaX:Number = (focus.x - center.x) / 5;
			var deltaY:Number = (focus.y - center.y) / 5;
			
			center.x += deltaX;
			center.y += deltaY;
			
			camera.stayInBounds();
		}
		
		public function enter():void
		{
		
		}
	
	}

}