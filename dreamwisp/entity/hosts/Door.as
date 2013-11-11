package dreamwisp.entity.hosts {
	
	import com.demonsters.debugger.MonsterDebugger;
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import tools.Belt;
	
	/**
	 * DoorFrame is a generic, data-driven entity.
	 * For complex location systems, create a new Door
	 * 
	 * @author Brandon
	 */
	
	public class Door extends Entity implements IInteractible {
		
		private var _destination:Object;
		
		public function Door() {
			
			body = new Body(this, 48, 96);
			
			view = new View(this);
			//view.movieClip = Belt.addClassFromLibrary("E4", Belt.CLASS_MOVIECLIP);
			
			groupName = "Interactibles";
			//view.layer = Data.text.LAYER_INTERACTIBLES;
		}
		
		public function get destination():Object { return _destination; }
		
		public function set destination(value:Object):void { _destination = value; }
		
		/* INTERFACE dreamwisp.entity.hosts.IInteractible */
		
		public function interact(entity:Entity = null):void {
			// destination contains the travelling entity;
			destination.entity = entity;
			// open the door to enter a new area
			myLocation.highestLocation.goto(destination);
			
			MonsterDebugger.trace(this, "interacted with door");
		}
		
	}

}