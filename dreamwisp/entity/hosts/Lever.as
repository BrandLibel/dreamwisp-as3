package dreamwisp.entity.hosts {
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.action.ActionStream;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import org.osflash.signals.Signal;
	import tools.Belt;
	
	/**
	 * ...
	 * @author Brandon
	 */
	
	public class Lever extends Entity implements IInteractible {
		
		private var isOn:Boolean = false;
		private var leverFlipped:Signal;
		
		public function Lever() {
			body = new Body(this, 32, 32);
			
			view = new View(this);
			//view.movieClip = Belt.addClassFromLibrary("E5", Belt.CLASS_MOVIECLIP);
			
			groupName = "Interactibles";
			view.layer = Data.text.LAYER_INTERACTIBLES;
			
			leverFlipped = new Signal(String, Boolean);
			leverFlipped.add(accessLocation);
			//leverFlipped.removeAll();
		}
		
		private function accessLocation(name:String, on:Boolean):void {
			//MonsterDebugger.trace(this, myLocation);
			// test - turning the tile below the lever into air
			myLocation.tileScape.alterTile((body.y / 32)+1, body.x / 32, uint(isOn));
		}
		
		/* INTERFACE dreamwisp.entity.hosts.IInteractible */
		
		public function interact(entity:Entity = null):void {
			MonsterDebugger.trace(this, "FLIPPED SWITCH");
			isOn = !isOn;
			var frameLabel:String = (isOn) ? "on" : "off";
			view.movieClip.gotoAndStop( frameLabel );
			leverFlipped.dispatch("name", isOn);
		}
		
	}

}