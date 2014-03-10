package dreamwisp.entity.hosts {
	
	import dreamwisp.entity.components.platformer.PlatformPhysics;
	
	/**
	 * ...
	 * @author Brandon
	 */
	public interface IPlatformEntity extends IEntity {
		
		function setTileGrid(tileGrid:Vector.<Vector.<Tile>>):void;
		
		function get platformPhysics():PlatformPhysics;
		function set platformPhysics(value:PlatformPhysics):void;
		
	}
	
}