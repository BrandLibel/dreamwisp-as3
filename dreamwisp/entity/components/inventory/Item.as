package dreamwisp.entity.components.inventory {
	
	import dreamwisp.entity.components.Body;
	import dreamwisp.entity.components.View;
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * Item is an Entity that can exist within a Location and be transferred
	 * into an Inventory, a component of Entitys.
	 * @author Brandon
	 */
	
	public class Item extends Entity {
		
		private var _description:String;
		
		private var _stats:Object;
				
		public function Item(protoTypeData:Object = null, id:uint = 0) {
			super(protoTypeData, id);
		}
		
		public function get description():String {
			return _description;
		}
		
		public function set description(value:String):void {
			_description = value;
		}
		
		public function get stats():Object {
			return _stats;
		}
		
		public function set stats(value:Object):void {
			_stats = value;
		}
		
	}

}