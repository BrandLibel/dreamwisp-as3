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
			var nearestPoint:InterestPoint = camera.findNearestPoint();
			
			if (nearestPoint != null)
			{
				focus = nearestPoint;
				const innerRadius:Number = nearestPoint.innerRadius;
				var distToPoint:Number = camera.focusBody.distanceTo(focus.x, focus.y);
				
				if (distToPoint > innerRadius)
				{
					// we want the interpolation (0.0 - 1.0).
					// using the interpolation of player from innerRadius,
					// the camera will focus on a point between outerRadius and the center point.
					var interp:Number = 1 - ((distToPoint - innerRadius) / (nearestPoint.radius - innerRadius));
					var distX:Number = focus.x - camera.focusBody.x;
					var distY:Number = focus.y - camera.focusBody.y;
					
					focus = new SwiftPoint(camera.focusBody.x, camera.focusBody.y);
					focus.x += distX * interp;
					focus.y += distY * interp;
				}
			}
			else 
			{
				focus = new SwiftPoint(camera.focusBody.x, camera.focusBody.y);
			}
			
			var deltaX:Number = (focus.x - center.x) / 10;
			var deltaY:Number = (focus.y - center.y) / 10;
			
			center.x += deltaX;
			center.y += deltaY;
			
			camera.stayInBounds();
		}
		
		public function enter():void
		{
		
		}
	
	}

}