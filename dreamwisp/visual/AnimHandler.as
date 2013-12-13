package dreamwisp.visual {

	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.DisplayObject;
	import tools.Belt;
	
	/**
	 * THIS IS AN UNREFERENCED CLASS LEFT INTACT FOR LEARNING FROM MISTAKES.
	 * @author Brandon
	 */
	public class AnimHandler {
		
		private static const X:String = "x";
		private static const Y:String = "y";
		private static const ALPHA:String = "alpha";
		private static const ROTATION_X:String = "rotationX";
		private static const ROTATION_Y:String = "rotationY";
		private static const FRAME:String = "frame";
		
		private var _x:Animatable = new Animatable(X);
		private var _y:Animatable = new Animatable(Y);
		private var _alpha:Animatable = new Animatable(ALPHA);
		private var _rotationX:Animatable = new Animatable(ROTATION_X);
		private var _rotationY:Animatable = new Animatable(ROTATION_Y);
		private var _frame:Animatable = new Animatable(FRAME);
				
		/// List of the properties currently being animated.
		protected var playList:Vector.<Animatable> = new Vector.<Animatable>;
		/// The real view object that the animatables affect
		private var _actual:Object;
		
		public function AnimHandler() {
			//MonsterDebugger.trace(this, "another initialized");
			x.started.add(addToPlay);
			x.stopped.add(removeFromPlay);
			y.started.add(addToPlay);
			y.stopped.add(removeFromPlay);
			alpha.started.add(addToPlay);
			alpha.stopped.add(removeFromPlay);
			rotationX.started.add(addToPlay);
			rotationY.stopped.add(removeFromPlay);
			frame.started.add(addToPlay);
			frame.stopped.add(removeFromPlay);
		}
		
		/// Sets all unused Animatables to null
		protected function nullify():void {
			if (!x.wasInitialized) x = null;
			if (!y.wasInitialized) y = null;
			if (!alpha.wasInitialized) alpha = null;
			if (!rotationX.wasInitialized) rotationX = null;
			if (!rotationY.wasInitialized) rotationY = null;
			if (!frame.wasInitialized) frame = null;
		}
		
		public function update():void {
			// TODO: final update is not made before the stopped action is called
			if (playList.length == 0) return;			
			for each (var animatable:Animatable in playList) animatable.update();
			
			//for (var i:int = 0; i < playList.length; i++) {
				//var animProp:Animatable = playList[i];
				//var propName:String = animProp.name;
				//animProp.update();
				//if (animProp.name == "alpha") MonsterDebugger.trace(this, animProp.currentValue, "", "", 0x178BFF);
				//
				//if (propName == FRAME) {
					//actual.gotoAndStop(animProp.currentValue);
					//return;
				//} else {
					//actual[propName] = animProp.currentValue;
				//}
				//
				///*animProp.checkLimits();
				//animProp.checkTarget();*/
				//
				//if (animProp.name == "alpha") MonsterDebugger.trace(this, actual[propName] + "/" + animProp.currentValue);
			//}
		}
		
		/// Override this function to manually decide which properties to animate
		public function render():void {
			/*
			 * README: When stopped is dispatched, the animatable is REMOVED FROM LIST.
			 * The update for-each loop does not break, but it IS STILL removed from the list.
			 * So, it can continue to update the property. 
			 * Here, however, after the update for-each loop ends, the property doesn't exist
			 * in the playList anymore so it cannot be renderered IN HERE LOOP.
			 * SO, rather than rendering by playList, we must render each property manually.
			 */
			
			//
			
			if (x) actual.x = x.currentValue;
			if (y) actual.y = y.currentValue;
			if (alpha) actual.alpha = alpha.currentValue;
			//TODO: when rendering, setting rotationX and Y destroys the scrollRect property...
			if (rotationX) {
				MonsterDebugger.trace(this, "ACTUAL: " + actual.rotationX + " ROTATION: " + rotationX.currentValue, "", "", 0xA800A4);
				actual.rotationX = rotationX.currentValue;
			}
			if (rotationY) {
				actual.rotationY = rotationY.currentValue;
			}
			if (frame) actual.gotoAndStop(frame.currentValue);
				
				
			/*for each (var animatable:Animatable in playList) {
				
				if (animatable.name == FRAME) {
					MonsterDebugger.trace(this, "Render value: " + animatable.currentValue, "", "", 0xF20000);
					actual.gotoAndStop(animatable.currentValue);
				} else {
					actual[animatable.name] = animatable.currentValue;
				}
			}*/
			
		}
		
		protected function addToPlay(animatable:Animatable):void {
			//if (animatable.name == "alpha") MonsterDebugger.trace(this, "added Alpha", "AnimHandler");
			
			// tests if property already exists; no duplicates allowed
			if (playList.indexOf(animatable) == -1) {
				playList.push(animatable);
			}
		}
		
		protected function removeFromPlay(animatable:Animatable):void {
			//if (animatable.name == "alpha") MonsterDebugger.trace(this, "removed Alpha", "AnimHandler", "", 0x00BB21);
			//render();
			playList.splice(playList.indexOf(animatable), 1);
		}
		
		public function get x():Animatable { return _x; }
		
		public function set x(value:Animatable):void { _x = value; }
		
		public function get y():Animatable { return _y; }
		
		public function set y(value:Animatable):void { _y = value; }
		
		public function get alpha():Animatable { return _alpha; }
		
		public function set alpha(value:Animatable):void { _alpha = value; }
		
		public function get rotationX():Animatable { return _rotationX; }
		
		public function set rotationX(value:Animatable):void { _rotationX = value; }
		
		public function get rotationY():Animatable { return _rotationY; }
		
		public function set rotationY(value:Animatable):void { _rotationY = value; }
		
		public function get frame():Animatable { return _frame; }
		
		public function set frame(value:Animatable):void { _frame = value; }
		
		public function get actual():Object { return _actual; }
		
		public function set actual(value:Object):void { _actual = value; }
		
		//public function get playList():Vector.<Animatable> { return _playList; }
		
	}

}