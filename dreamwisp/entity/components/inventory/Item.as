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
		
		private var _inventory:Inventory;
		
		public function Item() {
			body = new Body(this, 25, 40);
			
			view = new View(this);
			
		}
		
		override public function destroy():void {
			// 
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
		
		public function get inventory():Inventory {
			return _inventory;
		}
		
		public function set inventory(value:Inventory):void {
			_inventory = value;
		}
		
	}

}