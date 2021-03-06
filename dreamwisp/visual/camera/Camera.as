package dreamwisp.visual.camera
{
	//import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import dreamwisp.entity.hosts.Entity;
	import dreamwisp.swift.geom.SwiftRectangle;
	import dreamwisp.visual.ContainerView;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * The Camera class can
	 */
	
	public class Camera
	{
		public static const STATE_FOCUS:String = "focusState";
		public static const STATE_PATH:String = "pathState";
		public static const STATE_SLOW_FOCUS:String = "slowFocusState";
		
		public static const MAX_X:String = "maxX";
		public static const MAX_Y:String = "maxY";
		public static const MIN_X:String = "minX";
		public static const MIN_Y:String = "minY";
		
		public var center:Point;
		
		internal var velocityX:int;
		internal var velocityY:int;
		
		/// Camera users are usually a View subclass implementing ICamUser.
		private var user:ContainerView;
		/// The focus is the body of the entity which the camera follows.
		internal var focusBody:Body;
		internal var focusView:View;
		internal var interestPoints:Vector.<InterestPoint>;
		
		private var currentState:ICameraState;
		private var lastState:ICameraState;
		private var focusState:ICameraState;
		private var pathState:ICameraState;
		private var slowFocusState:ICameraState;
		
		internal var cameraPath:CameraPath;
		
		private var initialShakeSeverity:uint = 0;
		private var shakeSeverity:uint = 0;
		private var shakeCount:uint = 0;
		
		private var _height:uint;
		private var _width:uint;
		internal var zoomValue:Number = 1;
		
		private var boundRect:SwiftRectangle;
		
		public function Camera(width:uint = 768, height:uint = 480, initialStateName:String = STATE_FOCUS)
		{
			_width = width;
			_height = height;
			
			center = new Point(width / 2, height / 2);
			
			// creating states
			focusState = new FocusState(this);
			pathState = new PathState(this);
			slowFocusState = new SlowFocusState(this);
			changeToState(initialStateName);
		}
		
		public function render(interpolation:Number):void
		{
			currentState.scroll();
			
			// After performing calculations, these optional offset values
			// can be added to the camera center in order to create a visual effect.
			// This will not affect normal camera position calculation.
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			
			// camera shake code
			if (shakeSeverity > 0)
			{
				offsetX = Math.random() * shakeSeverity;
				offsetY = Math.random() * shakeSeverity;
				//MonsterDebugger.trace(this, "shaking: " + shakeSeverity + "||" + offsetX + "/" + offsetY);
				shakeSeverity--;
				if (shakeSeverity == 0)
				{
					if (shakeCount > 0)
					{
						// another shake 
						shakeCount--;
						shakeSeverity = initialShakeSeverity;
					}
				}
			}
			
			if (_width != width() || _height != height())
			{
				offsetX += (width() / zoomValue);
				offsetY += (height() / zoomValue);
			}
			
			user.followCamera(center.x + offsetX, center.y + offsetY);
		}
		
		/**
		 * Sets the new boundaries to limit the camera's movement
		 * @param	user the view that needs to be scrolled
		 * @param	boundary the rectangular limits of the area
		 */
		public function redefineBounds(user:ContainerView, boundary:SwiftRectangle):void 
		{
			this.user = user;
			this.boundRect = boundary;
		}
		
		public function getBounds():SwiftRectangle { return boundRect; }
		
		public function zoom(value:Number):void 
		{
			user.scaleX = value;
			user.scaleY = value;
			zoomValue = value;
		}
		
		public function zoomPlus():void 
		{
			zoom(zoomValue + 1);
		}
		
		/**
		 * Sets a new focus for the Camera to follow
		 * @param	focus the new entity to focus on
		 */
		public function refocus(focus:Entity):void
		{
			focusBody = focus.body;
			focusView = focus.view;
			focusView.render(1);
			
			var nearestPoint:InterestPoint = findNearestPoint();
			if (nearestPoint != null)
			{
				center.x = nearestPoint.x;
				center.y = nearestPoint.y;
			}
			
			currentState.scroll();
			user.followCamera(center.x, center.y);
		}
		
		public function setInterestPoints(interestPoints:Vector.<InterestPoint>):void 
		{
			this.interestPoints = interestPoints;
		}
		
		/**
		 * Find the distance of the provided InterestPoint
		 * @param	point an InterestPoint with 
		 * @return	a positive Number
		 */
		internal function findDistanceOfPoint(point:InterestPoint):Number
		{
			if (point.allowVertical && !point.allowHorizontal)
				return Math.abs(focusBody.y - point.y);
			else if (!point.allowVertical && point.allowHorizontal)
				return Math.abs(focusBody.x - point.x);
			return focusBody.distanceTo(point.x, point.y);
		}
		
		internal function findNearestPoint():InterestPoint
		{
			if (interestPoints == null || interestPoints.length == 0) return null;
			var nearest:InterestPoint = null;
			var lowest:Number = uint.MAX_VALUE;
			for each (var point:InterestPoint in interestPoints) 
			{
				var dist:Number = findDistanceOfPoint(point);
				
				if (nearest == null || dist < lowest)
				{
					nearest = point;
					lowest = dist;
				}
			}
			if (lowest > point.radius) return null;
			return nearest;
		}
		
		/**
		 *
		 * @param	path An array of pathNode objects (properties x, y, velocityX, velocityY)
		 */
		public function followPath(path:Array):void
		{
			cameraPath = new CameraPath(path);
			changeState(pathState);
			//MonsterDebugger.trace(this, cameraPath);
		}
		
		public function slide(x:Number, y:Number):void 
		{
			// start from 0 -> target parabolically
			// return from target -> 0 parabolically
		}
		
		/**
		 *
		 * @param	severity
		 * @param	repeats The number of additional camera shakes to add.
		 */
		public function shake(severity:uint = 60, repeats:uint = 0):void
		{
			initialShakeSeverity = severity;
			shakeSeverity = severity;
			shakeCount = repeats;
		}
		
		internal function changeToState(stateName:String):void
		{
			if (this[stateName] is ICameraState)
				changeState(this[stateName]);
			else
				throw new Error("Tried to change the Camera state to a nonexistant state.");
		
		}
		
		internal function changeState(cameraState:ICameraState):void
		{
			// only remember last state if its different from the new state
			if (cameraState !== currentState)
				lastState = currentState;
			currentState = cameraState;
			currentState.enter();
		}
		
		internal function changeToLastState():void
		{
			changeState(lastState);
		}
		
		/// Stops the Camera from being outside of bounds
		internal function stayInBounds():void
		{
			if (passedRightBound()) center.x = maxX;
			if (passedLeftBound()) center.x = minX;
			if (passedDownBound()) center.y = maxY;
			if (passedUpBound()) center.y = minY;
		}
		
		internal function passedLeftBound():Boolean { return center.x < minX; }
		
		internal function passedRightBound():Boolean { return center.x > maxX; }
		
		internal function passedUpBound():Boolean { return center.y < minY; }
		
		internal function passedDownBound():Boolean { return center.y > maxY; }
		
		/**
		 * If the target rect is bigger than the stage, allows camera to move.
		 */
		private function isScrollable():Boolean
		{
			return (boundRect.width > width() || boundRect.height > height());
		}
		
		/// The right most edge that the camera center can be, in pixels.
		internal function get maxX():uint
		{
			return boundRect.width - (width() / 2) + boundRect.x;
		}
		
		/// The left most edge that the camera center can be, in pixels.
		internal function get minX():uint
		{
			return (width() / 2) + boundRect.x;
		}
		
		/// The bottom most edge that the camera center can be, in pixels.
		internal function get maxY():uint
		{
			return boundRect.height - (height() / 2) + boundRect.y;
		}
		
		/// The top most edge that the camera center can be, in pixels.
		internal function get minY():uint
		{
			return (height() / 2) + boundRect.y;
		}
		
		private function width():uint { return (_width / zoomValue); }
		
		private function height():uint { return (_height / zoomValue); }
	
	}

}