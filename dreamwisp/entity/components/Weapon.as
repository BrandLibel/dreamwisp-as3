package dreamwisp.entity.components {
	
	import dreamwisp.entity.hosts.Entity;
	import org.osflash.signals.Signal;
	
	public class Weapon {
		
		protected var host:Entity;
		private var _attacked:Signal;
		
		public function Weapon(entity:Entity) {
			host = entity;
			attacked = new Signal();
		}
		
		public function fire():void {
			
		}
		
		public function get attacked():Signal { return _attacked; }
		
		public function set attacked(value:Signal):void { _attacked = value; }
		
	}

}