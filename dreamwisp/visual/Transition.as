package dreamwisp.visual {
	
	import com.demonsters.debugger.MonsterDebugger;
	import org.osflash.signals.Signal;
	/**
	 * THIS IS AN UNREFERENCED CLASS LEFT INTACT FOR LEARNING FROM MISTAKES.
	 * @author Brandon
	 */
	public class Transition extends AnimHandler {
		
		/// List of transitions saved for a complex transition.
		private var exitEffects:Array = [];
		private var entryEffects:Array = [];
		
		/// The function to call once exit is finished and entry is preparing
		private var switchActions:Vector.<Function> = new Vector.<Function>;
		private var actionParams:Array = [];
		
		private var _isRunning:Boolean = false;
				
		private var _started:Signal;
		private var _stopped:Signal;
		
		/**
		 * 
		 * @param	view
		 * @param	action The function to execute when the transition is complete.
		 */
		public function Transition(view:ContainerView) {
			// TODO: Prevent transitions from handling the render of their targets; only let them update
			actual = view;
			x.init();
			y.init();
			alpha.init(1, 0, 1);
			rotationX.init(0, -180, 180);
			rotationY.init(0, -180, 180);
			nullify();
			
			started = new Signal();
			stopped = new Signal();
			//animList =  new <Animatable>[x, y, alpha, rotationX, rotationY];
		}
		
		override public function update():void {
			super.update();
			// transitions do not directly render the actual displayObject. only update the view object properties.
			actual.x = x.currentValue;
			actual.y = y.currentValue;
			actual.alpha = alpha.currentValue;
			//TODO: when rendering, setting rotationX and Y destroys the scrollRect property...
			actual.rotationX = rotationX.currentValue;
			actual.rotationY = rotationY.currentValue;
			
			/*MonsterDebugger.trace(this, alpha, "ALPHA","", 0xFF1717);
			MonsterDebugger.trace(this, x, "X", "", 0x3AFF17);
			MonsterDebugger.trace(this, y, "Y", "", 0x1B70FC);*/
		}
		
		override public function render():void {
			//throw new Error("Do not call render from transition. It can not directly affect displayObjects");
		}
		
		public function changeTarget(target:ContainerView):void {
			actual = target;
		}
		
		/// Starts all prepared transitions.
		public function start():void {
			started.dispatch();
			_isRunning = true;
			for (var i:int = 0; i < exitEffects.length; i++) {
				var effectData:Object = exitEffects[i];
				var animatable:Animatable = this[effectData.name];
				//animatable.setLimits(effectData.minVal, effectData.maxVal);
				if (effectData.isPrimary) {
					/*
					 * TODO: is temporary fix for playList dupe & dispatch order problem
					 */
					animatable.stopped.remove(removeFromPlay);
					animatable.stopped.addOnce(finishedExit);
					animatable.stopped.add(removeFromPlay);
				}
				animatable.currentValue = effectData.startVal;
				animatable.animateTo(effectData.targetVal, effectData.speed);
			}
			exitEffects = [];
		}
		
		
		
		/**
		 * Defines a single transition which is saved
		 * to be executed by <code>animateTo()</code> later.
		 * The first transition declared is 'primary'.
		 * Upon the completion of the primary transition,
		 * the entire transition is considered finished and
		 * the ending action is executed.
		 */ 
		public function prepare(name:String, startVal:Number, targetVal:Number, speed:Number, forEntry:Boolean = false):void {
			
			var transition:Object = new Object();
			transition.name = name;
			/*transition.minVal = minVal;
			transition.maxVal = maxVal;*/
			transition.startVal = startVal;
			transition.targetVal = targetVal;
			transition.speed = speed;
			
			if (forEntry) {
				transition.isPrimary = (entryEffects.length == 0) ? true : false;
				entryEffects.push(transition);
			} else {
				transition.isPrimary = (exitEffects.length == 0) ? true : false;
				exitEffects.push(transition);
			}	
		}
		
		public function addSwitchAction(action:Function, ...params):void {
			switchActions.push(action);
			var currentIndex:uint = switchActions.indexOf(action);
			actionParams[currentIndex] = new Array();
			for (var i:int = 0; i < params.length; i++) {
				actionParams[currentIndex].push(params[i]);
			}
		}
		
		/// Loads and prepares a single transition type using a specified preset.
		public function load(preset:Object, forEntry:Boolean = false):void {
			if (preset is Array) {
				
			}
		}
		
		private function finishedExit(animatable:Animatable):void {
			//MonsterDebugger.trace(this, actual.alpha);
			
			// TODO: allow transition completion only when all animatables report completed
			
			/*
			 * TODO: fix bug - actual values do not equal animatable values
			 * animHandler does not make its final update; when 0 is reached, 
			 * switch happens first, then it updates 
			 * (!) Without this switchAction call upon animatable.stopped, it would be fine
			 * this finishedExit is the first dispatched; other things like removeFromPlay are last
			 */
			
			/*
			 * TODO: transitions require duplicate properties 
			 * in the playList to switch properly because 
			 */
			
			// manually setting values, temporary fix for the above bugs
			update();
			actual.render();
			/*actual.x = x.currentValue;
			actual.y = y.currentValue;
			actual.alpha = alpha.currentValue;
			//TODO: when rendering, setting rotationX and Y destroys the scrollRect property...
			actual.rotationX = rotationX.currentValue;
			actual.rotationY = rotationY.currentValue;*/
			
			MonsterDebugger.trace(this, playList.length);
			MonsterDebugger.trace(this, alpha, "ALPHA","", 0xFF1717);
			MonsterDebugger.trace(this, x, "X", "", 0x3AFF17);
			MonsterDebugger.trace(this, y, "Y", "", 0x1B70FC);
			// executing all switch actions
			for (var j:int = 0; j < actionParams.length; j++) {
				if (actionParams[j].length == 0) switchActions[j].call();
				else switchActions[j].call(null, actionParams[j]);
			}
			actionParams = [];
			switchActions.length = 0;
			
			/*if (actionParams.length == 0) {
				switchActions.call();
			} else {
				switchActions.call(null, actionParams);
			}*/
				
			// begin entry, starts affecting a different view
			if (!entryEffects) return;
			for (var i:int = 0; i < entryEffects.length; i++) {
				var effectData:Object = entryEffects[i];
				var animatable:Animatable = this[effectData.name];
				//animatable.setLimits(effectData.minVal, effectData.maxVal);
				if (effectData.isPrimary) animatable.stopped.addOnce(finishedEntry);
				animatable.currentValue = effectData.startVal;
				animatable.animateTo(effectData.targetVal, effectData.speed);
			}
			entryEffects = [];
		}
		
		private function finishedEntry(animatable:Animatable):void {
			MonsterDebugger.trace(this, "STOPPED");
			_isRunning = false;
			stopped.dispatch();
		}
		
		public function get isRunning():Boolean { return _isRunning; }
		
		public function get started():Signal { return _started; }
		
		public function set started(value:Signal):void { _started = value; }
		
		public function get stopped():Signal { return _stopped; }
		
		public function set stopped(value:Signal):void { _stopped = value; }
				
	}

}