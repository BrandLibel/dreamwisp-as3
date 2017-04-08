package dreamwisp.entity.components {
	
	import dreamwisp.entity.hosts.Entity;
	import org.osflash.signals.Signal;
	
	/**
	 * This class is for entitys that can take damage. 
	 * It includes hits
	 */
	
	public class Health {
		
		private var host:Entity;
		public var hits:int = 0;
		
		public var hurt:Signal;
		public var died:Signal;
		
		public function Health(entity:Entity, maxHits:uint = 0) {
			host = entity;
			hits = maxHits;
			hurt = new Signal(Entity);
			died = new Signal(Entity);
		}
		
		public function hit(damage:Number):void {
			hits -= damage;
			if (hits <= 0) {
				die();
			}
		}
		
		public function die():void {
			host.destroyed.dispatch(host);
		}
		
	}

}