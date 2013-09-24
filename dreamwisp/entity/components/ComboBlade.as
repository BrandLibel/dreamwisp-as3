package dreamwisp.entity.components {
	
	import dreamwisp.entity.hosts.Entity;
	
	/**
	 * ComboBlade is a melee Weapon that can execute combos when fired.
	 * @author Brandon
	 */
	
	public class ComboBlade extends Weapon {
		
		public function ComboBlade(entity:Entity) {
			super(entity);
		}
		
		override public function fire():void {
			
		}
		
	}

}