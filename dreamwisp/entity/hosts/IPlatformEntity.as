package dreamwisp.entity.hosts {
	
	import dreamwisp.entity.components.platformer.PlatformPhysics;
	import dreamwisp.world.tile.TileScape;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IPlatformEntity extends IEntity {
				
		function get platformPhysics():PlatformPhysics;		
	}
	
}