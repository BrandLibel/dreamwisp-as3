package dreamwisp.world.editor {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.input.KeyMap;
	import dreamwisp.core.GameScreen;
	import dreamwisp.world.base.Location;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public class Editor extends GameScreen {
		
		private var tileScapeEditor:TileScapeEditor;
		private var _location:Location;
		
		private var keyMap:KeyMap;
		
		private var isActive:Boolean = false;
		
		public function Editor(location:Location) {
			this.location = location;
			//if (location.tileScape) tileScapeEditor = new TileScapeEditor(this, location.tileScape);
			if (location.deepestLocation.tileScape) tileScapeEditor = new TileScapeEditor(this, location.tileScape);
			
			keyMap = new KeyMap();
			keyMap.bind(Keyboard.C, toggle);
			
		}
		
		private function toggle():void {
			if (!isActive) {
				enter();
			} else {
				//exit();
			}
		}
		
		override public function enter():void {
			//MonsterDebugger.trace(this, "entered");
			isActive = true;
			location.pause();
		}
		
		/*private function exit():void {
			MonsterDebugger.trace(this, "Exited");
			isActive = false;
			location.resume();
		}*/
		
		override public function hearKeyInput(type:String, keyCode:uint):void {
			keyMap.receiveKeyInput(type, keyCode);
		}
		
		override public function hearMouseInput(type:String, mouseX:int, mouseY:int):void {
			if (type == MouseEvent.MOUSE_DOWN) {
				MonsterDebugger.trace(this, "pressing mouse");
			} else {
				//MonsterDebugger.trace(this, "other mouse action");
			}
		}
		
		public function get location():Location {
			return _location;
		}
		
		public function set location(value:Location):void {
			_location = value;
		}
		
	}

}