package dreamwisp.input {
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import org.osflash.signals.Signal;
	/**
	 * manages the state of ONE single keyboard key
	 * 
	 * @author Jody Hall
	 */
	public class OneKeyManager {
		private var _stage:Stage;
		private var _keyCode:uint;
		private var _pressHandler:Function;
		private var _releaseHandler:Function;
		private var _isDown:Boolean;
		private var _isActive:Boolean;
		
		private var _pressSignal:Signal;
		private var _releaseSignal:Signal;
		
		public function OneKeyManager(theStage:Stage, 
								   keyCode:uint, 
								   pressHandler:Function = null, 
								   releaseHandler:Function = null) {
			//_stage = theStage;
			_keyCode = keyCode;
			_pressHandler = pressHandler;
			_releaseHandler = releaseHandler;
			_isDown = false;
			
			//_stage.focus = _stage;
			//_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_isActive = true; //set flag to indicate KEY_DOWN listener is active
			
			init();
		}
		
		private function init():void {
			pressSignal = new Signal();
			releaseSignal = new Signal();
		}
		private function onKeyDown(event:KeyboardEvent):void {
			if (event.keyCode == _keyCode && _isDown == false) {
				_isDown = true;
				//_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				if (_pressHandler != null) {
					_pressHandler(event);
				}
				if (pressSignal != null) {
					pressSignal.dispatch();
				}
			}
		}
		private function onKeyUp(event:KeyboardEvent):void {
			if (event.keyCode == _keyCode) {
				//_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				_isDown = false;
				if (_releaseHandler != null) {
					_releaseHandler(event);
				}
				if (releaseSignal != null) {
					releaseSignal.dispatch();
				}
			}
		}
		public function set active(value:Boolean):void {
			if (_isActive != value) {
				_isActive = value;
				if (_isActive) {
					_stage.focus = _stage;
					_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				} else {
					_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				}
			}
		}
		public function get active():Boolean { return _isActive; }
		public function set pressHandler(value:Function):void { _pressHandler = value; }
		public function set releaseHandler(value:Function):void { _releaseHandler = value; }
		public function get isDown():Boolean { return _isDown; }
		
		public function get pressSignal():Signal {
			return _pressSignal;
		}
		
		public function set pressSignal(value:Signal):void {
			_pressSignal = value;
		}
		
		public function get releaseSignal():Signal {
			return _releaseSignal;
		}
		
		public function set releaseSignal(value:Signal):void {
			_releaseSignal = value;
		}
		
	}
}
