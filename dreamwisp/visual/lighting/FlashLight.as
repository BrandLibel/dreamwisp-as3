package dreamwisp.visual.lighting {
	
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * FlashLight is a LightSource that is cone-shaped rather than circular. 
	 * @author Brandon
	 */
	public class FlashLight extends LightSource {
		
		public function FlashLight(entity:Entity, x:Number=0, y:Number=0) {
			super(entity, x, y);
			
		}
		
		override public function render():void {
			
		}
		
	}

}
