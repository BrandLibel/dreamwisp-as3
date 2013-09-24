package dreamwisp.entity.components.inventory {
	
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * Inventory is a component of an Entity. It holds items, which are Entities themselves.
	 * It always uses a 1-dimensional Vector to hold items. A 2-dimensional grid can be
	 * faked by resizing the grid by setting the rows and cols properties.
	 * @author Brandon
	 */
	
	public class Inventory {
		
		private var host:Entity;
		private var items:Vector.<Item>;
		
		private var _size:uint;
		
		private var _rows:uint;
		private var _cols:uint;
		
		public function Inventory(entity:Entity, size:uint, rows:uint, cols:uint) {
			host = entity;
			this.size = size;
			this.rows = rows;
			this.cols = cols;
			items = new Vector.<Item>;
		}
		
		public function addItem(item:Item):void {
			items.push(item);
			item.inventory = this;
		}
		
		public function addItems(items:Vector.<Item>):void {
			
		}
		
		/**
		 * Removes an item from the inventory.
		 * @return The item that was removed.
		 */
		public function removeItem():Item {
			
		}
		
		public function resize(additionalItems:uint):void {
			size += additionalItems;
		}
		
		public function get size():uint { return _size; }
		
		public function set size(value:uint):void { _size = value; }
		
		public function get rows():uint { return _rows; }
		
		public function set rows(value:uint):void {_rows = value; }
		
		public function get cols():uint { return _cols; }
		
		public function set cols(value:uint):void { _cols = value; }
		
	}

}