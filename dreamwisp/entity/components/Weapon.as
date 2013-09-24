package dreamwisp.entity.components {
	
	import dreamwisp.entity.hosts.Entity;
	
	public class Weapon {
		
		protected var host:Entity;
		
		public function Weapon(entity:Entity) {
			host = entity;
		}
		
		public function fire():void {
			
		}
		
	}

}