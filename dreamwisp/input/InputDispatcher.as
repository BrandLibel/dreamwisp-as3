package dreamwisp.input {
	
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	
	/**
	 * This class takes user input and dispatches it to anything ingame
	 * that is listening for input. The listener, or 'InputReceptor', can be
	 * something like a GameState, which is an 'InputManager' and can handle
	 * many other InputReceptors, or something like a Player, which is a normal
	 * InputReceptor.
	 * @author Brandon
	 */
	public class InputDispatcher {
		
		private var _receptor:IInputReceptor;
		
		private var isEnabled:Boolean;
		
		public function InputDispatcher(stage:Stage, inputReceptor:IInputReceptor) {
			stage.addEventListener(MouseEvent.CLICK, mouseHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
			
			receptor = inputReceptor;
			
			isEnabled = true;
		}
		
		public function enable():void {
			isEnabled = true;
		}
		
		public function disable():void {
			isEnabled = false;
		}
		
		public function mouseHandler(e:MouseEvent):void {
			receptor.hearMouseInput(e.type, int(e.stageX), int(e.stageY));
		}
		
		public function keyHandler(e:KeyboardEvent):void {
			//MonsterDebugger.trace(this, "dispatching input");
			receptor.hearKeyInput(e.type, e.keyCode);
		}
		
		public function get receptor():IInputReceptor { return _receptor; }
		
		public function set receptor(value:IInputReceptor):void { _receptor = value; }
		
	}

}