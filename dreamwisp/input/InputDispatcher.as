package dreamwisp.input {
	
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	
	/**
	 * This class takes user input and dispatches it to anything ingame
	 * that is listening for input. 
	 * @author Brandon
	 */
	public class InputDispatcher {
		
		private var _receptor:IReceptor;
		
		private var isEnabled:Boolean;
		
		public function InputDispatcher(stage:Stage, inputReceptor:IReceptor) {
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
		
		public function get receptor():IReceptor { return _receptor; }
		
		public function set receptor(value:IReceptor):void { _receptor = value; }
		
	}

}