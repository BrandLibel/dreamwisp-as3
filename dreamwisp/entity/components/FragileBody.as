package dreamwisp.entity.components {
	
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * This 
	 */
	
	public class FragileBody extends SolidBody {
		
		private var host:Entity;
		
		public function FragileBody(entity:Entity) {
			host = entity;
		}
		
		override protected function collideBottom():void {
			host.health.die();
		}
		
		override protected function collideTop():void {
			host.health.die();
		}
		
		override protected function collideLeft():void {
			host.health.die();
		}
		
		override protected function collideRight():void {
			host.health.die();
		}
		
	}

}