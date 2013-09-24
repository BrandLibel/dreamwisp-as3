package dreamwisp.visual {
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.MovieClip;
	import org.osflash.signals.Signal;
	import tools.Belt;
	/**
	 * This class defines a 'rich' property which is autononomously animated.
	 * @author Brandon
	 */
	public class Animatable {
		
		private var _name:String;
		
		private var playVelocity:Number = 0;
		private var _currentValue:Number = 0;
		private var _targetValue:Number = 0;
		private var _reachedTarget:Function;
		private var minValue:Number = int.MIN_VALUE;
		private var maxValue:Number = int.MAX_VALUE;
						
		private var _action:Function;
		
		private var _started:Signal;
		private var _stopped:Signal;
		
		private var ticks:uint = 0;
		private var updateRate:uint = 1;
		
		/// The number of decimal places in the playVelocity
		private var precision:uint;
								
		public function Animatable(name:String = "") {
			this.name = name;
			
			started = new Signal(Animatable);
			stopped = new Signal(Animatable);
			
			reachedTarget = stop;
			reachedMax = toMax;
			reachedMin = toMin;
		}
		
		public var wasInitialized:Boolean = false;
		
		public function init(startVal:Number = 0, minVal:int = int.MIN_VALUE, maxVal:int = int.MAX_VALUE, isLooping:Boolean = false):void {
			wasInitialized = true;
			currentValue = startVal;
			setLimits(minVal, maxVal);
			if (isLooping) {
				reachedMax = toMin;
				reachedMin = toMax;
			}
		}
		
		public function update():void {
			ticks++;
			if (ticks == updateRate) {
				ticks = 0;
			} else {
				return;
			}
			currentValue += playVelocity;
			//if (name == "alpha") MonsterDebugger.trace(this, "UPDATING: " + currentValue);
			//if (name == "alpha") MonsterDebugger.trace(this, "val: " + currentValue, "", "", 0xFF1717);
			currentValue = Belt.toFixed(currentValue, precision);
			//if (name == "alpha") MonsterDebugger.trace(this, "val: " + currentValue, "", "", 0x3CFD1A);
			checkLimits();
						
			//if (this.name == "alpha") MonsterDebugger.trace(this, currentValue + "," + targetValue + "," + playVelocity);
			checkTarget();
		}
		
		public function checkLimits():void {
			if (currentValue > maxValue) {
				if (reachedMax != null) reachedMax.call();
			}
			if (currentValue < minValue) {
				if (reachedMin != null) reachedMin.call();
			}
		}
		
		public function checkTarget():void {
			if (currentValue == targetValue && playVelocity != 0) {
				if (reachedTarget != null) {
					//MonsterDebugger.trace(this, "Finished: " + this.name);
					reachedTarget.call();
					
				}
			}
		}
		
		public function animateTo(targetValue:Number, speed:Number = 1):void {
			precision = Belt.getDecimalPlaces(speed);
			started.dispatch(this);
			this.targetValue = targetValue;
			// If the target is adjacent, no need to animate; go immediately to target and STOP
			if (Math.abs(targetValue - currentValue) <= speed) {
				//MonsterDebugger.trace(this, "instant go to");
				currentValue = targetValue;
				//stopped.dispatch(this);
				return;
			} else {
				if (targetValue > currentValue) {
					//MonsterDebugger.trace(this, "pos speeed");
					playVelocity = speed;
				} else {
					playVelocity = -speed;
					//MonsterDebugger.trace(this, "neg speeed: " + (-speed));
				}
			}
			//if (name == "alpha") MonsterDebugger.trace(this, "STARTED: " + playVelocity);
			//if (name == "alpha") MonsterDebugger.trace(this, "SPEED:" + playVelocity, "", "", 0xFF0000);
		}
		
		
		public function animate(velocity:Number = 1, minVal:Number = int.MAX_VALUE, maxVal:Number = int.MAX_VALUE, updateRate:uint = 1):void {
			//if (name == "alpha") MonsterDebugger.trace(this, "changedVel: " + playVelocity);
			started.dispatch(this);
			playVelocity = velocity;
			minValue = minVal;
			maxValue = maxVal;
			this.updateRate = updateRate;
		}
		
		private var _reachedMax:Function;
		private var _reachedMin:Function;
		
		public function stop():void {
			//if (name == "alpha") MonsterDebugger.trace(this, "STOPPED");
			//if (name == "alpha") MonsterDebugger.trace(this, "DISPATCHING: " + currentValue, "", "", 0xF29D00);
			playVelocity = 0;
			stopped.dispatch(this);
			//if (name == "alpha") MonsterDebugger.trace(this, "DONE DISPATCHING: " + currentValue, "", "", 0xF29D00);
		}
		
		public function toMax():void {
			currentValue = maxValue;
		}
		
		public function toMin():void {
			currentValue = minValue;
		}
		
		/// Reverses the playVelocity, making the animation go backwards.
		public function bounce():void {
			//if (name == "alpha") MonsterDebugger.trace(this, "changedVel: " + playVelocity);
			playVelocity = -playVelocity;
		}
		
		/**
		 * Defines the allowed extreme values for 
		 * If not set, limits will be <code>int.MIN_VALUE</code>
		 * and <code>int.MAX_VALUE</code>
		 */
		public function setLimits(min:int, max:int):void {
			minValue = min;
			maxValue = max;
		}
		
		public function setActions(reachMin:Function, reachMax:Function, reachTarget:Function):void {
			reachedMin = reachMin;
			reachedMax = reachMax;
			reachedTarget = reachTarget;
		}
		
		// The following is movieClip specific functionality
		protected var frameLabels:Array;

		public function mapFrameLabels(movieClip:MovieClip):void {
			frameLabels = movieClip.currentLabels;
			//MonsterDebugger.trace(this, frameLabels);
		}
		
		public function findFrame(label:String, movieClip:MovieClip):int {
			if (movieClip.totalFrames == 1) return 1;
			var i:uint = 0;
			for (i; i < frameLabels.length; i++) {
				if (frameLabels[i].name == label) {
					break;
				}
			}
			//MonsterDebugger.trace(this, frameLabels[i].frame);
			return frameLabels[i].frame;
		}
				
		public function get currentValue():Number { return _currentValue; }
		
		public function set currentValue(value:Number):void { _currentValue = value; }
		
		public function get targetValue():Number { return _targetValue; }
		
		public function set targetValue(value:Number):void { _targetValue = value; }
		
		public function get action():Function { return _action; }
		
		public function set action(value:Function):void { _action = value; }
		
		public function get name():String { return _name; }
		
		public function set name(value:String):void { _name = value; }
		
		public function get reachedMax():Function { return _reachedMax; }
		
		public function set reachedMax(value:Function):void { _reachedMax = value; }
		
		public function get reachedMin():Function { return _reachedMin; }
		
		public function set reachedMin(value:Function):void { _reachedMin = value; }
		
		public function get reachedTarget():Function { return _reachedTarget; }
		
		public function set reachedTarget(value:Function):void { _reachedTarget = value; }
		
		public function get started():Signal { return _started; }
		
		public function set started(value:Signal):void { _started = value; }
		
		public function get stopped():Signal { return _stopped; }
		
		public function set stopped(value:Signal):void { _stopped = value; }
		
	}

}