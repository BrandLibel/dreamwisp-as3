package dreamwisp.visual.camera {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.action.IActionReceptor;
	import dreamwisp.entity.components.Body;
	import dreamwisp.swift.geom.SwiftRectangle;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * The Camera class can 
	 */
	
	public class Camera implements IActionReceptor {
		
		public static const STATE_FOCUS:String = "focusState";
		public static const STATE_PATH:String = "pathState";
		public static const STATE_SLOW_FOCUS:String = "slowFocusState";
		
		public static const MAX_X:String = "maxX";
		public static const MAX_Y:String = "maxY";
		public static const MIN_X:String = "minX";
		public static const MIN_Y:String = "minY";
						
		private var _center:Point;// = new Point(width / 2, height / 2);
		
		/// The right most edge that the camera center can be, in pixels.
		internal var maxX:uint = 0;
		/// The left most edge that the camera center can be, in pixels.
		internal var minX:uint = 0;
		/// The bottom most edge that the camera center can be, in pixels.
		internal var maxY:uint = 0;
		/// The top most edge that the camera center can be, in pixels.
		internal var minY:uint = 0;
		
		private var rectWidth:uint;
		private var rectHeight:uint;
		
		internal var velocityX:int;
		internal var velocityY:int;
		
		private var _user:ICamUser;
		private var _focus:Body;
		
		private var currentState:ICameraState;
		private var lastState:ICameraState;
		private var focusState:ICameraState;
		private var pathState:ICameraState;
		private var slowFocusState:ICameraState;
		
		internal var cameraPath:CameraPath;
		
		private var actionQueue:Array = new Array();
		
		// After performing calculations, these optional offset values
		// can be added to the camera center in order to create a visual effect.
		// This will not affect normal camera position calculation.
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		
		private var isShaking:Boolean = false;
		private var initialShakeSeverity:uint = 0;
		private var shakeSeverity:uint = 0;
		private var shakeCount:uint = 0;
		
		private var height:uint;
		private var width:uint;
		
		public function Camera(width:uint = 768, height:uint = 480, initialStateName:String = STATE_FOCUS) {
			this.width = width;
			this.height = height;
			
			center = new Point(width / 2, height / 2);
			
			// creating states
			focusState = new FocusState(this);
			pathState = new PathState(this);
			slowFocusState = new SlowFocusState(this);
			changeToState(initialStateName);
		}
		
		public function update():void {
			// no need to update in a location the size of the camera
			if (isScrollable()) currentState.scroll();
			
			// camera shake code
			if (isShaking) {
				MonsterDebugger.trace(this, "shaking: " + shakeSeverity + "||" +offsetX+"/"+offsetY);
				offsetX = Math.random() * shakeSeverity;
				offsetY = Math.random() * shakeSeverity;
				shakeSeverity--;
				if (shakeSeverity == 0) {
					//shakeSeverity = 60;
					if (shakeCount == 0) {
						isShaking = false;
					} else {
						// another shake 
						shakeCount--;
						shakeSeverity = initialShakeSeverity;
					}
				}
			} else {
				offsetX = 0;
				offsetY = 0;
			}
			
			// offsets are added to create visual effect without affecting camera position calculation
			user.followCamera(center.x + offsetX, center.y + offsetY);
			
			// IActionReceptor
			if (actionQueue.length != 0) executeAction(actionQueue.shift()); 
		}
		
		/**
		 * Determines the boundaries of the possible scrolling area.
		 * @param	rect The rectangular area that the camera is allowed to scroll through.
		 */
		public function setBounds(rect:SwiftRectangle):void { 
			minX = (width/2) + rect.x;
			maxX = rect.width - (width/2) + rect.x;
			minY = (height/2) + rect.y;
			maxY = rect.height - (height / 2) + rect.y;
			rectWidth = rect.width;
			rectHeight = rect.height;
			// for setting camera to top-left most position of given rect
			// important for first time entry into locations
			user.followCamera(minX, minY);
			center.x = minX;
			center.y = minY;
			// camera repositioned, reset the path
			velocityX = 0;
			velocityY = 0;
			cameraPath = null;
		}
		
		/**
		 * 
		 * @param	path An array of pathNode objects (properties x, y, velocityX, velocityY)
		 */
		public function followPath(path:Array):void {
			cameraPath = new CameraPath(path);
			changeState(pathState);
			MonsterDebugger.trace(this, cameraPath);
		}
		
		/**
		 * 
		 * @param	severity
		 * @param	repeats The number of additional camera shakes to add.
		 */
		public function shake(severity:uint = 60, repeats:uint = 0):void {
			isShaking = true;
			initialShakeSeverity = severity;
			shakeSeverity = severity;
			shakeCount = repeats;
		}
				
		internal function changeToState(stateName:String):void {
			if (this[stateName] is ICameraState) {
				changeState(this[stateName]);
			} else {
				throw new Error("Tried to change the Camera state to a nonexistant state.");
			}
			
		}
		
		internal function changeState(cameraState:ICameraState):void {
			// only remember last state if its different from the new state
			if (cameraState !== currentState) lastState = currentState;
			currentState = cameraState;
			currentState.enter();
		}
		
		internal function changeToLastState():void {
			changeState(lastState);
		}
		
		internal function stayInBounds():void {
			// does not allow the camera to leave the bounds
			if (passedRightBound()) center.x = maxX;
			if (passedLeftBound()) center.x = minX;
			if (passedDownBound()) center.y = maxY;
			if (passedUpBound()) center.y = minY;
		}
		
		internal function passedLeftBound():Boolean {
			return (center.x < minX);
		}
		
		internal function passedRightBound():Boolean {
			return (center.x > maxX);
		}
		
		internal function passedUpBound():Boolean {
			return (center.y < minY);
		}
		
		internal function passedDownBound():Boolean {
			return (center.y > maxY);
		}
		
		// INTERFACE dreamwisp.action.IActionReceptor //
		
		public function queueAction(action:Object):void {
			actionQueue.push(action);
		}
		
		public function executeAction(action:Object):void {
			if (action.type == "followPath") {
				this[action.type].call(null, action.path);
			} else {
				this[action.type].call(null, action);
			}
			
		}
		
		public function attemptAction(action:Object):void {
			
		}
		
		public function abortAction(action:Object):void {
			actionQueue.splice(  actionQueue.indexOf(action), 1 );
		}
		
		/**
		 * If the target rect is bigger than the stage, allows camera to move.
		 */
		private function isScrollable():Boolean {
			return (rectWidth > width || rectHeight > height);
		}
		
		internal function centralizeX(value:*):* {
			return (value + width);
		}
		
		internal function centralizeY(value:*):* {
			return (value + height);
		}
		
		/// The focus is the body of the entity which the camera follows.
		public function get focus():Body { return _focus; }
		public function set focus(value:Body):void { _focus = value; }
		
		public function get center():Point { return _center; }
		public function set center(value:Point):void { _center = value; }
		
		/// Camera users are usually a View subclass implementing ICamUser.
		public function get user():ICamUser { return _user; }
		public function set user(value:ICamUser):void { _user = value; }
		
	}

}