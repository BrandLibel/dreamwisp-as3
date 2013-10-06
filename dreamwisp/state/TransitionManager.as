package dreamwisp.state {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.visual.Animatable;
	import dreamwisp.visual.AnimHandler;
	import dreamwisp.visual.ContainerView;
	import org.osflash.signals.Signal;
	
	/**
	 * OneTransition deals with changing alpha values.
	 * @author Brandon
	 */
	
	 //TODO: make TransitionManager a component like AnimHandler and give it a ref to GameState
	 
	public class TransitionManager extends AnimHandler {
		
		private var _finished:Signal;
		
		private var stateView:ContainerView;
				
		public function TransitionManager(view:ContainerView) {
			if (view) actual = view;
			init();
			nullify();
			finished = new Signal();
		}
		
		private function init():void {
			alpha.init(1, 0, 1);
		}
		
		public function reset():void {
			init();
		}
		
		/**
		 * 
		 * @param	transition Must contain: type, targetVal, speed. 
		 * 			Optional: startVal.
		 */
		public function start(transition:Object):void {
			// default transition for a new state entry - fade in
			if (!transition) transition = { type: "alpha", startVal: 0, targetVal: 1, speed: 0.05 };
			
			var animatable:Animatable = this[transition.type];
			if (transition.hasOwnProperty("startVal")) {
				animatable.currentValue = transition.startVal;
			}
			animatable.animateTo(transition.targetVal, transition.speed);
			animatable.stopped.addOnce(finish);
		}
		
		override public function update():void {
			super.update();
		}
		
		private function finish(a:*):void {
			//MonsterDebugger.trace(this, "transition finish", "", "", 0xF90000);
			/* TODO: This finish function is called before the final update/render, which
			 * 		necessitates the 3 update/render calls. There can be no fix, because the
			 * 		Animatable dispatches 'stop' as soon as it reaches it's target, causing 
			 * 		a state change 
			 * TODO: the AnimHandler.render() can be misleading.
			 * 	It updates Actual, but if Actual is a view then it does not actually "render"
			 *	Clean up number of update() and render() calls.
			 */
			update();
			render();
			actual.render();
			finished.dispatch();
		}
		
		public function get finished():Signal {
			return _finished;
		}
		
		public function set finished(value:Signal):void {
			_finished = value;
		}
		
	}

}