package dreamwisp.visual.camera
{
	import dreamwisp.swift.geom.SwiftPoint;
	import flash.geom.Point;
	
	/**
	 * FocusState is a Camera state where the camera always centers on a Focus, an Entity Body.
	 * This is the default state.
	 * @author Brandon
	 */
	internal class FocusState implements ICameraState
	{
		private var camera:Camera;
		
		public function FocusState(camera:Camera)
		{
			this.camera = camera;
		}
		
		/* INTERFACE dreamwisp.visual.camera.ICameraState */
		
		/*public function scroll():void {
		   var focus:Body = camera.focus;
		   var center:Point = camera.center;
		
		   if (focus.globalX > center.x && center.x < camera.maxX) center.x = focus.globalX;
		   if (focus.globalX < center.x && center.x > camera.minX) center.x = focus.globalX;
		
		   if (focus.globalY > center.y && center.y < camera.maxY) center.y = focus.globalY;
		   if (focus.globalY < center.y && center.y > camera.minY) center.y = focus.globalY;
		
		   camera.stayInBounds();
		 }*/
		
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
				/*if (focus.displayObject.x > center.x && center.x < camera.maxX)
					center.x = focus.displayObject.x;
				else if (focus.displayObject.x < center.x && center.x > camera.minX)
					center.x = focus.displayObject.x;
				
				if (focus.displayObject.y > center.y && center.y < camera.maxY)
					center.y = focus.displayObject.y;
				else if (focus.displayObject.y < center.y && center.y > camera.minY)
					center.y = focus.displayObject.y;*/
				focus = new SwiftPoint(camera.focusBody.x, camera.focusBody.y);
			}
			
			center.x = focus.x;
			center.y = focus.y;
			
			camera.stayInBounds();
		}
		
		public function enter():void
		{
		
		}
	
	}

}