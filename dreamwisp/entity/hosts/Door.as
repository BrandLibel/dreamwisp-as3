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
		
		public var destination:Object;
		protected var locked:Boolean;
		
		public function Door(protoTypeData:Object = null, protoTypeID:uint = 0) {
			super(protoTypeData, protoTypeID);			
		}
		
		/* INTERFACE dreamwisp.entity.hosts.IInteractible */
		
		public function interact(entity:Entity = null):void {
			// destination contains the travelling entity;
			destination.entity = entity;
			// open the door to enter a new area
			myLocation.highestLocation.moveTo(destination);
			
			MonsterDebugger.trace(this, "interacted with door");
		}
		
		public function touch():void 
		{
			
		}
		
		public function unlock():void 
		{
			locked = false;
		}
		
		public function lock():void 
		{
			locked = true;
		}
		
		public function isLocked():Boolean 
		{
			return locked;
		}
		
	}

}