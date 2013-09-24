package dreamwisp.entity.components.inventory {
	
	/**
	 * A FloatyItem is a type of item for Platformer games that doesn't collide or follow physics.
	 * It simply floats up and down.
	 * @author Brandon
	 */
	
	public class FloatyItem extends Item {
		
		public function FloatyItem() {
			
		}
		
		override public function update():void {
			super.update();
		}
		
	}

}